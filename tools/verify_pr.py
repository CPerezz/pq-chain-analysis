# /// script
# requires-python = ">=3.10"
# dependencies = ["pyyaml", "eth-abi", "pycryptodome"]
# ///
"""Review the cards a pull request adds or changes before they enter the registry (.github/workflows/verify.yml).

    uv run tools/verify_pr.py PR            review the pull request, then merge it or ask the maintainers
    uv run tools/verify_pr.py PR --dry      review and print the comment; posts and merges nothing
    uv run tools/verify_pr.py --card FILE   review one card file and print the verdict
    uv run tools/verify_pr.py --resume      restart the reviews a Claude usage limit paused (hourly, from CI)
    uv run tools/verify_pr.py --mcp BLOCK   the node tool Claude calls: an MCP server on stdin and stdout

Commands, as a pull request comment (CI passes it in COMMENT, COMMENT_BY, COMMENT_ID): `/verify` (its author or a
maintainer) reviews again the cards not accepted and the cards changed since their verdict, with the reasons given
since; `/verify all` (a maintainer) reviews every card afresh; `/accept CARD REASON` (a maintainer) accepts one card.

A card is reviewed when the pull request adds it to findings/ or changes what it claims: an edit of `related`,
`reviews`, `sources` or History alone changes no claim. A pull request with no such card is merged without review when
a maintainer opened it and it only removes entries or edits bookkeeping (no new file outside review/held/, no card
removed without a new card for its contract); any other gets no comment. Per card:
- tools/build.py (this checkout's) checks the pull request's files: a card it refuses is rejected as `format`;
- tools/verify.py re-runs its facts and checks on the archive node (ETH_RPC_URL): one the node contradicts rejects it
  as `unproven`; one that could not run is tried 3 times, 5 minutes apart, then the card is left not checked;
- Claude (MODEL, EFFORT) reads a brief (its claims, the checks behind each and what the node returned, the other
  findings for its contract, its cited transactions), its source, decompiled code and traces, may query the node
  through `--mcp`, and accepts it or rejects it with a class and a reason (tools/verify_pr.md). Severity is not judged.
The pull request's files are data: nothing from them runs, and Claude works in a folder outside the checkout.

The bot's comment carries the registry of verdicts (SHA-256 of each card, verdict, class, reason, commit). The pull
request is approved and merged when every card is accepted, its author is a maintainer (MAINTAINERS), no card is
removed without a new card for its contract, and it touches only cards, triage entries, decompiled code and the
queue's files. Otherwise the maintainers are asked. A pull request labeled `no-merge` is reviewed the same way and
never merged by the verifier. A node that does not answer (3 tries, 5 minutes apart) or a failed Claude login stops
the review with a comment; a Claude usage limit pauses it until the limit resets.
"""

import argparse
import base64
import concurrent.futures as cf
import datetime as dt
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
import zlib
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))
import build  # noqa: E402
import new_finding as nf  # noqa: E402
import verify  # noqa: E402

WORK = Path(os.environ.get("RUNNER_TEMP") or tempfile.gettempdir()) / "pq-verify"  # outside the checkout: no CLAUDE.md
MODEL, EFFORT = "claude-sonnet-5-5", "xhigh"
PARALLEL, MAX_CARDS, CARD_SECONDS = 10, 60, 2400
TRIES, PAUSE = 3, 300  # a node that does not answer: 3 tries, 5 minutes apart
DEADLINE = time.time() + 330 * 60  # verify.yml stops the job at 350 minutes
MAINTAINERS = [m for m in os.environ.get("MAINTAINERS", "").split(",") if m]
NODE = "127.0.0.1:8545"  # the archive node, through verify.yml's SSH forward
VIEM = "npm:viem@2.21.0"  # cached by verify.yml before any card is read
PROMPT = (ROOT / "tools" / "verify_pr.md").read_text(encoding="utf-8")
# what a pull request may touch and still merge on its own: cards, triage entries, decompiled code, the queue's state
AUTO = re.compile(r"^(findings/|triage/|code/|review/held/|review/(queue\.tsv|ledger\.tsv|added\.jsonl)$)")
BOOKKEEPING = ("related", "reviews", "sources")
CARD = re.compile(r"^format:\s*2\s*$", re.M)
ADDRESS = re.compile(r"^\s*(?:-\s+)?(?:address|proxy_of):\s*['\"]?(0x[0-9a-fA-F]{40})", re.M)
TX_LINK = re.compile(r"/tx/(0x[0-9a-fA-F]{64})")
TX_HASH = re.compile(r"0x[0-9a-f]{64}")
TRANSIENT = re.compile(r"^could not run|no verified source on Sourcify or Blockscout")
FLAKY = ("contract.code", "contract.name")  # read from Sourcify and Blockscout, which can be down
MARK, BOT = "<!-- pq-verifier -->", "github-actions[bot]"
REGISTRY = re.compile(r"<!-- registry ([A-Za-z0-9+/=]+) -->")
PRECOMPILES = {f"0x{n:040x}": name for n, name in [
    (1, "ecrecover"), (2, "sha256"), (3, "ripemd160"), (4, "identity"), (5, "modexp"), (6, "bn254 add"), (7, "bn254 mul"),
    (8, "bn254 pairing"), (9, "blake2f"), (10, "kzg point evaluation"), (11, "bls12-381 g1 add"), (12, "bls12-381 g1 msm"),
    (13, "bls12-381 g2 add"), (14, "bls12-381 g2 msm"), (15, "bls12-381 pairing"), (16, "bls12-381 map fp to g1"),
    (17, "bls12-381 map fp2 to g2"), (0x100, "p256verify")]}
SCHEMA = {"type": "object", "additionalProperties": False, "required": ["verdict", "class", "reason", "notes"],
          "properties": {"verdict": {"enum": ["accept", "reject"]},
                         "class": {"enum": ["", "false", "unproven", "not-affected", "duplicate", "sensitive"]},
                         "reason": {"type": "string", "maxLength": 240},
                         "notes": {"type": "array", "maxItems": 2, "items": {"type": "string", "maxLength": 160}}}}
TOOL = ("Runs a TypeScript snippet (the body of an async function) against the archive node and returns what it "
        "returns, as JSON. Helpers: BLOCK (the card's block, hex), rpc(method, params), batch([[method, params], ...]), "
        "call(to, 'owner() returns (address)', args?, block?, from?), code(address, block?), storage(address, slot, "
        "block?), balance(address, block?), trace(txHash) (callTracer). Put every read a question needs in one script "
        "(Promise.all, follow-up reads in the same script) and return only what you need.")
PRELUDE = """import { decodeFunctionResult, encodeFunctionData, parseAbiItem } from "%(viem)s";
const BLOCK = "%(block)s";
let n = 0;
async function post(body: unknown): Promise<any> {
  const r = await fetch("http://%(node)s", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
  return await r.json();
}
async function rpc(method: string, params: unknown[] = []): Promise<any> {
  const r = await post({ jsonrpc: "2.0", id: ++n, method, params });
  if (r.error) throw new Error(`${method}: ${r.error.message}`);
  return r.result;
}
async function batch(calls: [string, unknown[]?][]): Promise<any[]> {
  const rs = await post(calls.map(([method, params], id) => ({ jsonrpc: "2.0", id, method, params: params ?? [] })));
  return rs.sort((a: any, b: any) => a.id - b.id).map((r: any) => (r.error ? { error: r.error.message } : r.result));
}
const code = (a: string, b = BLOCK) => rpc("eth_getCode", [a, b]);
const storage = (a: string, slot: string, b = BLOCK) => rpc("eth_getStorageAt", [a, slot, b]);
const balance = (a: string, b = BLOCK) => rpc("eth_getBalance", [a, b]);
const trace = (tx: string) => rpc("debug_traceTransaction", [tx, { tracer: "callTracer" }]);
async function call(to: string, sig: string, args: unknown[] = [], b = BLOCK, from?: string): Promise<any> {
  const abi = [parseAbiItem(`function ${sig}`)] as any;
  const out = await rpc("eth_call", [{ to, data: encodeFunctionData({ abi, args }), ...(from ? { from } : {}) }, b]);
  return decodeFunctionResult({ abi, data: out });
}
const __out = await (async () => {
%(code)s
})();
console.log(JSON.stringify(__out, (_k, v) => (typeof v === "bigint" ? v.toString() : v)));
"""


class Limit(Exception):
    """Claude's usage limit; `until` is when it resets, None when Claude did not say."""

    def __init__(self, until: float | None):
        super().__init__(until)
        self.until = until


class LoginFailed(Exception):
    pass


class Paused(Exception):
    pass


def gh(*args: str, body: dict | None = None) -> str:
    return subprocess.run(["gh", *args] + (["--input", "-"] if body is not None else []), check=True, capture_output=True,
                          text=True, input=json.dumps(body) if body is not None else None).stdout


def gh_list(path: str, jq: str) -> list:
    """Every item of a paginated list, through a jq projection."""
    return [json.loads(x) for x in gh("api", path, "--paginate", "--jq", f".[] | {jq} | @json").splitlines() if x]


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(ROOT), *args], check=True, capture_output=True, text=True).stdout


def split(text: str) -> tuple[dict, str]:
    """(header, body) of a card; an empty header when it does not parse."""
    end = text.find("\n---\n", 4)
    if not text.startswith("---\n") or end < 0:
        return {}, text
    try:
        head = yaml.load(text[4:end], Loader=build.Loader)
    except yaml.YAMLError:
        head = None
    return (head if isinstance(head, dict) else {}), text[end + 5:]


def sections(body: str) -> dict[str, str]:
    """Each `## ` and `### ` section of a body, by title."""
    out, cur = {}, None
    for line in body.splitlines():
        m = re.match(r"^#{2,3} (.+?)\s*$", line)
        if m:
            cur = m.group(1)
            out[cur] = ""
        elif cur:
            out[cur] += line + "\n"
    return {k: v.strip() for k, v in out.items()}


def essence(text: str) -> str:
    """What a card claims: all of it but `related`, `reviews`, `sources` and History."""
    head, body = split(text)
    sec = sections(body)
    sec.pop("History", None)
    return json.dumps([{k: v for k, v in head.items() if k not in BOOKKEEPING}, sec], sort_keys=True, default=str)


def many(k: int, noun: str) -> str:
    return f"{k} {noun}" + ("" if k == 1 else "s")


def sha16(text: str) -> str:
    return hashlib.sha256(text.encode()).hexdigest()[:16]


def safe(path: str) -> Path:
    """A source file's path from Sourcify or Blockscout, kept inside the evidence folder."""
    return Path(*[p for p in Path(path.replace("\\", "/")).parts if p not in ("..", "/", "") and ":" not in p] or ["source.sol"])


def compact(f: dict, depth: int = 0) -> dict:
    """A callTracer frame with what a reader needs: who called what, precompile calls and their output, failures."""
    to = str(f.get("to") or "").lower()
    out = {k: f[k] for k in ("type", "from", "to") if f.get(k)}
    if to in PRECOMPILES:
        out["precompile"], out["output"] = PRECOMPILES[to], str(f.get("output") or "")[:130]
    else:
        out["selector"] = str(f.get("input") or "")[:10]
    if int(str(f.get("value") or "0x0"), 16):
        out["value"] = f["value"]
    out["gasUsed"] = int(str(f.get("gasUsed") or "0x0"), 16)
    out.update({k: f[k] for k in ("error", "revertReason") if f.get(k)})
    kids = f.get("calls") or []
    if kids and depth < 10:
        out["calls"] = [compact(k, depth + 1) for k in kids[:100]] + ([{"omitted": len(kids) - 100}] if len(kids) > 100 else [])
    elif kids:
        out["calls_below"] = len(kids)
    return out


def summary(tx: str, f: dict) -> str:
    """One line for a call tree: who called what, whether it failed, its precompile calls and what they returned."""
    seen = []

    def walk(x: dict) -> None:
        if x.get("precompile"):
            out = str(x.get("output") or "")
            seen.append(f"{x['precompile']} → " + ("0x" + out[-40:] if x["precompile"] == "ecrecover" and len(out) >= 42 else out[:66] or "nothing"))
        for k in x.get("calls") or []:
            walk(k)
    walk(f)
    state = f"failed: {f['error']}" if f.get("error") else "ok"
    return f"- {tx}: {f.get('from')} → {f.get('to')} {f.get('selector', '')} · {state} · " + ("; ".join(seen[:8]) or "no precompile call")


def forward() -> None:
    """Open the SSH forward to the archive node (verify.yml leaves the key in NODE_SSH_KEY_FILE); a no-op when open."""
    if os.environ.get("NODE_SSH_KEY_FILE"):
        subprocess.run(["ssh", "-i", os.environ["NODE_SSH_KEY_FILE"], "-o", "BatchMode=yes", "-o", "ExitOnForwardFailure=yes",
                        "-o", "ServerAliveInterval=30", "-f", "-N", "-L", f"{NODE}:127.0.0.1:8545", os.environ["NODE_SSH"]],
                       capture_output=True, timeout=60)


def health(blocks: list[int], address: str) -> str | None:
    """None when the node is mainnet, synced, past every card's block and keeps state at the oldest; else what failed."""
    try:
        if nf.rpc("eth_chainId", []) != "0x1":
            return "the node is not on mainnet"
        if nf.rpc("eth_syncing", []) is not False:
            return "the node is syncing"
        head = int(nf.rpc("eth_blockNumber", []), 16)
        if head < max(blocks):
            return f"the node is at block {head:,}, behind block {max(blocks):,}"
        nf.rpc("eth_getBalance", [address, hex(min(blocks))])
    except BaseException as e:  # new_finding.rpc exits on a node it cannot reach
        return f"{type(e).__name__}: {str(e)[:200]}"
    return None


def format_problems(head: str) -> list[str]:
    """What tools/build.py (this checkout's) finds in the pull request's files."""
    tree = WORK / "tree"
    shutil.rmtree(tree, ignore_errors=True)
    tree.mkdir(parents=True)
    tar = subprocess.run(["git", "-C", str(ROOT), "archive", head, "findings", "triage", "studies", "code", "patterns.md", "templates"],
                         check=True, capture_output=True).stdout
    subprocess.run(["tar", "-x", "-C", str(tree)], input=tar, check=True)
    shutil.copytree(ROOT / "tools", tree / "tools")
    r = subprocess.run([sys.executable, str(tree / "tools" / "build.py")], cwd=tree, capture_output=True, text=True, timeout=1200)
    return [x for x in r.stdout.splitlines() if ": " in x] if r.returncode else []


def view(changed: dict[str, str], gone: set[str]) -> dict[str, list[tuple[str, str]]]:
    """Address -> (path, text) of every finding as the pull request leaves the registry."""
    texts = {f"findings/{p.name}": p.read_text(encoding="utf-8") for p in (ROOT / "findings").glob("*.md")}
    for p in gone:
        texts.pop(p, None)
    texts.update(changed)
    idx: dict[str, list[tuple[str, str]]] = {}
    for path, text in texts.items():
        for a in {m.lower() for m in ADDRESS.findall(text[:text.find("\n---\n", 4)])}:
            idx.setdefault(a, []).append((path, text))
    return idx


def others(path: str, text: str, idx: dict) -> list[str]:
    """One line per other card filed for this address, then up to 3 cards of the proxies that run its code or of the
    code it runs. Format 1 entries are left out: they were filed in bulk before any review, and the review's cards
    replace them."""
    c = split(text)[0].get("contract") or {}
    a, impl = str(c.get("address") or "").lower(), str(c.get("proxy_of") or "").lower()
    seen, same, near = {path}, [], []
    for key in dict.fromkeys(x for x in (a, impl) if x):
        for p, t in idx.get(key, []):
            if p in seen or not CARD.search(t.split("\n---", 1)[0]):
                continue
            seen.add(p)
            h, b = split(t)
            at = str((h.get("contract") or {}).get("address") or "").lower()
            what = " ".join(str(sections(b).get("What happens") or "").split())[:300]
            where = "this address" if at == a else "the code this address runs" if at == impl else f"{at}, a proxy that runs this code"
            (same if at == a else near).append(f"- `{Path(p).stem}` ({where}) · {h.get('pattern')} · {h.get('status')} · {h.get('title')} — {what}")
    return same + near[:3] + ([f"- and {len(near) - 3} more cards of proxies that run this code"] if len(near) > 3 else [])


def rules(pattern: str) -> str:
    """The card's pattern in full (its Detection notes marked as hints), the category rule of AGENTS.md for its
    category, the categories, and every pattern in one line (patterns.md)."""
    text = (ROOT / "patterns.md").read_text(encoding="utf-8")
    own, mine, every = f"{pattern}: not in patterns.md", "", []
    for m in re.finditer(r"^## (PQ-\d+): (.+?)\n(.*?)(?=^## |\Z)", text, re.M | re.S):
        cat, words = re.search(r"\*\*Category:\*\* (\S+)", m.group(3)), re.search(r"\*\*In words:\*\* (.+)", m.group(3))
        every.append(f"- {m.group(1)} ({cat.group(1) if cat else '?'}): {words.group(1).strip() if words else m.group(2)}")
        if m.group(1) == pattern:
            own = m.group(0).strip().replace("**Detection:**", "**Detection** (how a study finds it: search hints, not part of the definition):")
            mine = cat.group(1) if cat else ""
    cats = text[text.find("## Categories"):text.find("## Classes")].strip()
    agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
    head = "### Category `quantum-exposure`" if mine == "quantum-exposure" else "### Categories of a protocol change"
    start = agents.find(head)
    end = re.search(r"\n#{2,3} ", agents[start + len(head):]) if start >= 0 else None
    rule = agents[start:start + len(head) + end.start()].strip() if end else agents[start:].strip() if start >= 0 else ""
    return "\n\n".join(x for x in ["# The card's pattern\n\n" + own, "# The category rule (AGENTS.md)\n\n" + rule if rule else "",
                                   cats, "## Every pattern\n\n" + "\n".join(every)] if x) + "\n"


def brief(text: str, rows: list, other: list[str], txs: list[str]) -> str:
    """The card's claims and the checks behind each; every check once, with what the node returned; header facts,
    other findings for the contract, cited transactions."""
    head, body = split(text)
    sec, c = sections(body), head.get("contract") or {}
    result, facts = {}, []
    for what, status, found in rows:
        m = re.match(r"check (\S+) \(", what)
        if m:
            result[m.group(1)] = f"{status}: {found}"
        else:
            facts.append(f"- {what}: {status}: {found}")
    checks = [x for x in head.get("checks") or [] if isinstance(x, dict)]
    bullets = [b[2:] for b in sec.get("Evidence", "").splitlines() if b.startswith("- ")]
    parts = ([("title", head.get("title")), ("what", sec.get("What happens"))] + [(f"evidence-{i}", b) for i, b in enumerate(bullets, 1)]
             + [("justification", head.get("justification")), ("action", head.get("action")), ("notes", sec.get("Mechanism"))]
             + [(f, f"{f} {c.get(f, head.get(f))}") for f in build.CHECK_FACTS if any(f in (x.get("for") or []) for x in checks)])
    out = [f"# {head.get('id')}",
           (f"Status {head.get('status')} · pattern {head.get('pattern')} · category {head.get('category')} · severity "
            f"{head.get('severity')} (not judged) · study {head.get('study')}"),
           (f"Contract {c.get('address')} ({c.get('name') or 'no name'}) · code {c.get('code')} · proxy of "
            f"{c.get('proxy_of') or 'none'} · upgradeable {c.get('upgradeable')} · admin {c.get('admin') or 'none'} · block {head.get('block')}"),
           "", "## Claims (← the checks behind each)"]
    for part, txt in parts:
        if txt:
            ids = [str(x.get("id")) for x in checks if part in (x.get("for") or [])]
            out.append(f"- **{part}**: {' '.join(str(txt).split())}" + (f" ← {', '.join(ids)}" if ids else " ← no check"))
    out += ["", "## Checks, re-run on the node at the block"] + [
        f"- `{x.get('id')}` says {x.get('says')!r} (" + ", ".join(f"{k} {v}" for k, v in x.items() if k not in ("id", "says", "for"))
        + f") → {result.get(str(x.get('id')), 'not re-run')}" for x in checks]
    out += ["", "## Header facts re-read on the node"] + (facts or ["- none"])
    if sec.get("Questions"):
        out += ["", "## Open questions", sec["Questions"]]
    out += ["", "## Other findings filed for this contract"] + (other or ["- none"])
    out += ["", "## Cited transactions"] + (txs or ["- none"])
    return "\n".join(out) + "\n"


def prepare(cid: str, path: str, text: str, code: dict[str, str], idx: dict) -> tuple[Path, list]:
    """The evidence folder of one card (card, brief, rules, sources, decompiled code, traces) and the node's re-run of
    its facts and checks."""
    ev = WORK / "cards" / cid
    shutil.rmtree(ev, ignore_errors=True)
    ev.mkdir(parents=True)
    (ev / "card.md").write_text(text, encoding="utf-8")
    rows = verify.verify_file(ev / "card.md", {"value": False, "names": True, "no_facts": False, "sources": WORK / "sources", "replays": {}})
    head = split(text)[0]
    c = head.get("contract") or {}
    checks = [x for x in head.get("checks") or [] if isinstance(x, dict)]
    for a in dict.fromkeys(str(a).lower() for a in [c.get("address"), c.get("proxy_of")] + [x.get("source") for x in checks] if a):
        for p, t in verify.sources_of(a, WORK / "sources").items():
            dest = ev / "source" / a / safe(p)
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(t, encoding="utf-8")
    if str(c.get("code_url") or "") in code:
        (ev / "code").mkdir()
        (ev / "code" / Path(c["code_url"]).name).write_text(code[c["code_url"]], encoding="utf-8")
    txs = {str(x.get(k)).lower() for x in checks for k in ("tx", "replay") if x.get(k)} | {t.lower() for t in TX_LINK.findall(text)}
    lines = []
    for tx in sorted(t for t in txs if TX_HASH.fullmatch(t)):
        try:
            frame = compact(nf.rpc("debug_traceTransaction", [tx, {"tracer": "callTracer"}]))
        except BaseException as e:  # new_finding.rpc exits on a node it cannot reach
            frame = {"error": f"not traced: {str(e)[:200]}"}
        (ev / "traces").mkdir(exist_ok=True)
        (ev / "traces" / f"{tx}.json").write_text(json.dumps(frame, indent=1))
        lines.append(summary(tx, frame))
    (ev / "brief.md").write_text(brief(text, rows, others(path, text, idx), lines), encoding="utf-8")
    (ev / "rules.md").write_text(rules(str(head.get("pattern") or "")), encoding="utf-8")
    return ev, rows


def ask(ev: Path, block: int) -> dict:
    """Claude's verdict on a prepared card; raises Limit, LoginFailed, or RuntimeError for anything else."""
    server = {"mcpServers": {"node": {"command": sys.executable, "args": [str(Path(__file__).resolve()), "--mcp", str(block)]}}}
    cmd = ["claude", "-p", PROMPT, "--model", MODEL, "--effort", EFFORT, "--permission-mode", "dontAsk", "--restricted",
           "--strict-mcp-config", "--mcp-config", json.dumps(server), "--allowedTools", "Read,Grep,Glob,mcp__node__run",
           "--disallowedTools", "Bash,Edit,Write,NotebookEdit,WebFetch,WebSearch,Task",
           "--output-format", "json", "--json-schema", json.dumps(SCHEMA)]
    env = {k: os.environ[k] for k in ("PATH", "HOME", "TMPDIR", "LANG", "DENO_DIR", "CLAUDE_CODE_OAUTH_TOKEN") if k in os.environ}
    r = subprocess.run(cmd, cwd=ev, env=env, capture_output=True, text=True, timeout=CARD_SECONDS)
    try:
        out = json.loads(r.stdout)
    except json.JSONDecodeError:
        out = {"is_error": True, "result": (r.stdout + r.stderr)[-400:]}
    v = out.get("structured_output")
    if not isinstance(v, dict):
        try:
            v = json.loads(out.get("result") or "")
        except (json.JSONDecodeError, TypeError):
            v = None
    if not out.get("is_error") and isinstance(v, dict) and v.get("verdict") in ("accept", "reject"):
        (ev / "answer.json").write_text(json.dumps(out, indent=1))
        cls = (v.get("class") or "") if v["verdict"] == "reject" else ""
        reason = str(v.get("reason") or "")
        return {"verdict": v["verdict"], "class": cls, "reason": re.sub(rf"^{re.escape(cls)}:\s*", "", reason, flags=re.IGNORECASE) if cls else reason,
                "notes": [str(x) for x in v.get("notes") or []][:2]}
    msg = str(out.get("result") or out.get("error") or r.stderr)[-400:]
    low = msg.lower()
    if re.search(r"\b401\b|invalid api key|/login|oauth|authenticat|unauthori[sz]ed|revoked", low):
        raise LoginFailed(msg)
    if re.search(r"usage limit|rate.?limit|limit reached|hit your .*limit|resets", low):
        stamp, rel = re.search(r"\|(\d{10})\b", msg), re.search(r"resets in (\d+)\s*(h|m)", low)
        if stamp:
            raise Limit(int(stamp.group(1)))
        # ponytail: a reset worded otherwise is retried every 15 minutes
        raise Limit(time.time() + int(rel.group(1)) * (3600 if rel.group(2) == "h" else 60) if rel else None)
    raise RuntimeError(msg)


def run_ts(code: str, block: int) -> tuple[str, bool]:
    """A snippet of the node tool, in Deno with no permission but the node's address: no files, no environment."""
    try:
        r = subprocess.run(["deno", "run", "--quiet", "--no-prompt", "--no-config", "--no-lock", "--cached-only", "--ext=ts",
                            f"--allow-net={NODE}", "-"], input=PRELUDE % {"viem": VIEM, "block": hex(block), "node": NODE, "code": code},
                           capture_output=True, text=True, timeout=120,
                           env={k: os.environ[k] for k in ("PATH", "HOME", "DENO_DIR") if k in os.environ})
    except subprocess.TimeoutExpired:
        return "stopped after 120 seconds: read less in one script", True
    out = (r.stdout if r.returncode == 0 else r.stderr).strip()
    return out[:20000] + (" [cut at 20,000 characters: return less]" if len(out) > 20000 else ""), r.returncode != 0


def mcp(block: int) -> None:
    """The node tool as an MCP server: one tool, `run`, on stdin and stdout."""
    def reply(i, **result) -> None:
        sys.stdout.write(json.dumps({"jsonrpc": "2.0", "id": i, **result}) + "\n")
        sys.stdout.flush()
    for line in sys.stdin:
        try:
            m = json.loads(line)
        except json.JSONDecodeError:
            continue
        method, i, params = m.get("method"), m.get("id"), m.get("params") or {}
        if i is None:
            continue
        if method == "initialize":
            reply(i, result={"protocolVersion": params.get("protocolVersion", "2025-06-18"), "capabilities": {"tools": {}},
                             "serverInfo": {"name": "node", "version": "1"}})
        elif method == "tools/list":
            reply(i, result={"tools": [{"name": "run", "description": TOOL, "inputSchema": {
                "type": "object", "properties": {"code": {"type": "string"}}, "required": ["code"]}}]})
        elif method == "tools/call":
            text, bad = run_ts(str((params.get("arguments") or {}).get("code") or ""), block)
            reply(i, result={"content": [{"type": "text", "text": text}], "isError": bad})
        elif method == "ping":
            reply(i, result={})
        else:
            reply(i, error={"code": -32601, "message": f"no method {method}"})


def load_registry(repo: str, n: int) -> tuple[int | None, dict]:
    """The bot's comment on the pull request and the registry it carries; only the bot's own comment counts."""
    for c in gh_list(f"repos/{repo}/issues/{n}/comments", "{id, login: .user.login, body}"):
        if c["login"] == BOT and MARK in c["body"]:
            m = REGISTRY.search(c["body"])
            return c["id"], json.loads(zlib.decompress(base64.b64decode(m.group(1)))) if m else {}
    return None, {}


def wait_checks(repo: str, head: str, names=("check", "board"), minutes: int = 90) -> str | None:
    """None once each required job has passed on the head commit, else what is wrong."""
    for _ in range(minutes * 2):
        out = gh("api", f"repos/{repo}/commits/{head}/check-runs", "--paginate", "--jq", ".check_runs[] | [.name, .status, .conclusion] | @json")
        runs = [json.loads(x) for x in out.splitlines() if x]
        if all(any(nm == x and c == "success" for nm, _, c in runs) for x in names):
            return None
        bad = [x for x in names if any(nm == x for nm, _, _ in runs) and all(nm != x or (st == "completed" and c != "success") for nm, st, c in runs)]
        if bad:
            return f"the {', '.join(bad)} job failed"
        time.sleep(30)
    return f"the {', '.join(names)} jobs did not finish within {minutes} minutes"


def render(cards: dict, reg: dict, extra: list[str], state: str, link) -> str:
    def cut(s: str, n: int = 300) -> str:
        s = " ".join(str(s).split())
        return s if len(s) <= n else s[:n] + "…"
    by = {k: [c for c in sorted(cards) if reg.get(c, {}).get("verdict") == k] for k in ("accept", "reject", "unchecked")}
    left = [c for c in cards if c not in reg]
    out = [MARK, f"**Verifier:** {len(by['accept'])} accepted · {len(by['reject'])} rejected"
           + (f" · {len(by['unchecked'])} not checked" if by["unchecked"] else "") + (f" · {len(left)} to check" if left else "")
           + f", of {many(len(cards), 'card')}"]
    rows = [f"- ❌ [`{c}`]({link(cards[c][0])}) {reg[c]['class']}: {cut(reg[c]['reason'])}" for c in by["reject"]] + [
        f"- ⏳ [`{c}`]({link(cards[c][0])}) not checked: {cut(reg[c]['reason'])}" for c in by["unchecked"]]
    out += ([""] + rows if rows else []) + extra + ["", state, ""]
    if by["accept"]:
        out += [f"<details><summary>{len(by['accept'])} accepted</summary>\n"] + [
            f"- `{c}`" + (f" (by @{reg[c]['by']}: {cut(reg[c]['reason'], 200)})" if reg[c].get("by") else "") for c in by["accept"]] + ["</details>", ""]
    notes = [f"- `{c}`: {cut('; '.join(reg[c]['notes']), 300)}" for c in sorted(cards) if reg.get(c, {}).get("notes")]
    if notes:
        out += ["<details><summary>Notes (do not block)</summary>\n"] + notes + ["</details>", ""]
    if by["reject"] or by["unchecked"]:
        out.append("Fix a card or answer here, then comment `/verify`: only the cards not accepted are checked again.")
    out.append(f"<!-- registry {base64.b64encode(zlib.compress(json.dumps(reg, separators=(',', ':')).encode(), 9)).decode()} -->")
    body = "\n".join(out)
    for name in ("GH_TOKEN", "GITHUB_TOKEN", "CLAUDE_CODE_OAUTH_TOKEN"):  # a secret never reaches a public comment
        if len(os.environ.get(name, "")) > 8:
            body = body.replace(os.environ[name], "[redacted]")
    return body


def command(repo: str, author: str) -> tuple[str, list[str]] | None:
    """The comment that started this run: ('', []) when none started it, None when it is no command of a permitted
    user; else ('verify' | 'all' | 'accept', its words)."""
    words, by = os.environ.get("COMMENT", "").split(), os.environ.get("COMMENT_BY", "")
    if not words:
        return "", []
    if words[0] == "/verify" and words[1:2] == ["all"]:
        kind, allowed = "all", by in MAINTAINERS
    elif words[0] == "/verify":
        kind, allowed = "verify", by in MAINTAINERS or by == author
    elif words[0] == "/accept" and len(words) > 2:
        kind, allowed = "accept", by in MAINTAINERS
    else:
        return None
    if not allowed:
        return None
    if os.environ.get("COMMENT_ID"):
        subprocess.run(["gh", "api", "-X", "POST", f"repos/{repo}/issues/comments/{os.environ['COMMENT_ID']}/reactions",
                        "-f", "content=eyes"], capture_output=True)
    return kind, words[1:]


def run(n: int, dry: bool) -> int:
    repo = os.environ.get("GITHUB_REPOSITORY") or gh("repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner").strip()
    pr = json.loads(gh("api", f"repos/{repo}/pulls/{n}"))
    author = pr["user"]["login"]
    held = any(label["name"] == "no-merge" for label in pr.get("labels") or [])
    cmd = command(repo, author)
    if pr["state"] != "open" or cmd is None:
        return 0
    files = gh_list(f"repos/{repo}/pulls/{n}/files", "{status, filename, previous_filename}")
    git("fetch", "--quiet", "--no-tags", "origin", f"pull/{n}/head")
    head = git("rev-parse", "FETCH_HEAD").strip()  # the pull request's head, read as data only
    show = lambda ref, p: git("show", f"{ref}:{p}")
    link = lambda p: f"https://github.com/{(pr['head'].get('repo') or {}).get('full_name') or repo}/blob/{head}/{p}"

    cards, code, blocked, removed, changed, gone = {}, {}, [], [], {}, set()
    for f in files:
        status, path, prev = f["status"], f["filename"], f.get("previous_filename")
        blocked += [p for p in (path, prev) if p and not AUTO.match(p)]
        old_path = prev if status == "renamed" else None if status == "added" else path
        old = ""
        if old_path and old_path.startswith("findings/"):
            gone.add(old_path)
            try:
                old = show("HEAD", old_path)
            except subprocess.CalledProcessError:
                pass
        if status in ("removed", "renamed") and CARD.search(old.split("\n---", 1)[0]):
            removed.append((old_path, str((split(old)[0].get("contract") or {}).get("address") or "").lower()))
        if status == "removed":
            continue
        if path.startswith("code/"):
            code[path] = show(head, path)
        if path.startswith("findings/") and path.endswith(".md"):
            text = changed[path] = show(head, path)
            if CARD.search(text.split("\n---", 1)[0]):
                if not old or essence(old) != essence(text):
                    cards[Path(path).stem] = (path, text)
            elif status == "added":
                blocked.append(f"{path} (a new format 1 file)")
    addresses = {str((split(t)[0].get("contract") or {}).get("address") or "").lower() for _, t in cards.values()}
    orphans = [(p, a) for p, a in removed if a not in addresses]
    if not cards:
        added = [f["filename"] for f in files if f["status"] in ("added", "copied") and not f["filename"].startswith("review/held/")]
        if blocked or orphans or added or author not in MAINTAINERS:
            print(f"pull request {n}: no card added or changed in what it claims")
            return 0
        # only removals and bookkeeping, opened by a maintainer: nothing for Claude to check
        body = (f"{MARK}\n**Verifier:** no card to review: this pull request only removes entries or edits bookkeeping. "
                + ("Not merged: it is labeled `no-merge`." if held else "Approved; merging once the `check` and `board` jobs pass."))
        if dry:
            print(body)
            return 0
        comment = load_registry(repo, n)[0]
        if comment:
            gh("api", "-X", "PATCH", f"repos/{repo}/issues/comments/{comment}", body={"body": body})
        else:
            gh("api", "-X", "POST", f"repos/{repo}/issues/{n}/comments", body={"body": body})
        gh("api", "-X", "POST", f"repos/{repo}/statuses/{head}", body={"state": "success", "context": "verifier", "description": "no card to review"})
        if held:
            return 0
        why = merge(repo, n, head, "Only removals and bookkeeping: no card to review.")
        if why:
            gh("api", "-X", "POST", f"repos/{repo}/issues/{n}/comments", body={"body": " ".join(f"@{m}" for m in MAINTAINERS) + f" not merged: {why}."})
        return 0
    for path in {str((split(t)[0].get("contract") or {}).get("code_url") or "") for _, t in cards.values()}:
        if path.startswith("code/") and path not in code:
            try:
                code[path] = show(head, path)
            except subprocess.CalledProcessError:
                pass

    comment, reg = load_registry(repo, n)
    shas = {c: sha16(t) for c, (_, t) in cards.items()}
    previous = {c: e for c, e in reg.items() if c in cards and e.get("verdict") == "reject" and e.get("class") != "format"}
    reg = {c: e for c, e in reg.items() if c in cards and e.get("sha") == shas[c] and e.get("class") != "format"}
    kind, words = cmd
    if kind == "accept":
        if words[0] in cards:
            reg[words[0]] = {"sha": shas[words[0]], "verdict": "accept", "class": "", "reason": " ".join(words[1:])[:240],
                             "notes": [], "commit": head, "at": dt.datetime.now(dt.timezone.utc).isoformat(), "by": os.environ.get("COMMENT_BY", "")}
    elif kind == "all":
        reg, previous = {}, {}
    elif kind == "verify":
        reg = {c: e for c, e in reg.items() if e["verdict"] == "accept"}
    reg = {c: e for c, e in reg.items() if e["verdict"] in ("accept", "reject")}  # a card not checked is tried again
    lock = threading.Lock()
    pinged = threading.Event()
    talk = {"comment": comment}

    def publish(state: str, extra: list[str]) -> None:
        body = render(cards, reg, extra, state, link)
        if dry:
            return
        if talk["comment"]:
            gh("api", "-X", "PATCH", f"repos/{repo}/issues/comments/{talk['comment']}", body={"body": body})
        else:
            talk["comment"] = json.loads(gh("api", "-X", "POST", f"repos/{repo}/issues/{n}/comments", body={"body": body}))["id"]

    def ping(text: str) -> None:
        msg = " ".join(f"@{m}" for m in MAINTAINERS) + " " + text
        print(msg) if dry else gh("api", "-X", "POST", f"repos/{repo}/issues/{n}/comments", body={"body": msg})

    def status(state: str, text: str) -> None:
        if not dry:
            gh("api", "-X", "POST", f"repos/{repo}/statuses/{head}", body={"state": state, "context": "verifier", "description": text[:140]})

    def now() -> str:
        return dt.datetime.now(dt.timezone.utc).isoformat()

    def record(cid: str, v: dict) -> None:
        with lock:
            reg[cid] = {"sha": shas[cid], **v, "commit": head, "at": now()}
            print(f"{cid}: {v['verdict']} {v.get('class', '')} {v['reason'][:160]}", flush=True)
            publish(f"Checking: {sum(1 for c in cards if c in reg)} of {len(cards)} done.", extra)

    problems = format_problems(head)
    owner = lambda x: next((c for c in cards if x.split(": ", 1)[0].split(" ")[0] in (c, f"{c}.md")), None)
    loose = [p for p in problems if owner(p) is None]
    extra = ((["", "**Files only a maintainer merges:**"] + [f"- `{p}`" for p in blocked[:30]]) if blocked else []) \
        + ((["", "**Cards removed with no new card for their contract:**"] + [f"- `{p}` ({a})" for p, a in orphans[:30]]) if orphans else []) \
        + ((["", "**`tools/build.py` refuses other files:**"] + [f"- {p[:300]}" for p in loose[:20]]) if loose else [])
    for c in cards:
        mine = [p.split(": ", 1)[1] for p in problems if owner(p) == c]
        if mine:
            reg[c] = {"sha": shas[c], "verdict": "reject", "class": "format", "reason": "; ".join(mine)[:240], "notes": [], "commit": head, "at": now()}
    waiting = sorted(c for c in cards if c not in reg)
    todo = waiting[:MAX_CARDS]
    print(f"pull request {n}: {len(cards)} cards, {len(cards) - len(waiting)} with a verdict, {len(todo)} to review", flush=True)

    if todo:
        blocks = [int(split(cards[c][1])[0].get("block") or 0) for c in todo]
        why = None
        for attempt in range(TRIES):
            forward()
            why = health(blocks, str((split(cards[todo[0]][1])[0].get("contract") or {}).get("address")))
            if not why or attempt + 1 == TRIES:
                break
            print(f"node: {why}; trying again in {PAUSE // 60} minutes", flush=True)
            time.sleep(PAUSE)
        if why:
            publish(f"**The archive node did not answer** ({TRIES} tries, {PAUSE // 60} minutes apart): {why}. Nothing was "
                    "checked; comment `/verify` once it is back.", extra)
            ping(f"the archive node did not answer for this pull request: {why}.")
            status("error", "the archive node did not answer")
            return 1
    publish(f"Checking: {len(cards) - len(todo)} of {len(cards)} done.", extra)
    status("pending", f"reviewing {len(todo)} cards")
    comments = [c for c in gh_list(f"repos/{repo}/issues/{n}/comments", "{login: .user.login, at: .created_at, body}")
                + gh_list(f"repos/{repo}/pulls/{n}/comments", "{login: .user.login, at: .created_at, body: (.path + \": \" + .body)}")
                if c["login"] in set(MAINTAINERS) | {author}] if previous else []
    idx = view(changed, gone)
    pause = {"until": 0.0}
    stop = {"login": None}

    def wait_limit() -> None:
        while (left := pause["until"] - time.time()) > 0:
            if pause["until"] > DEADLINE:
                raise Paused()
            time.sleep(min(left, 60))

    def one(cid: str) -> None:
        path, text = cards[cid]
        block = int(split(text)[0].get("block") or 0)
        try:
            for attempt in range(TRIES):
                ev, rows = prepare(cid, path, text, code, idx)
                stuck = [f"{w}: {f}" for w, s, f in rows if s == verify.FAIL and (TRANSIENT.search(f) or w in FLAKY)]
                if not stuck or attempt + 1 == TRIES:
                    break
                time.sleep(PAUSE)
                forward()
        except Exception as e:  # left not checked: /verify tries it again
            return record(cid, {"verdict": "unchecked", "class": "", "notes": [], "reason": f"{type(e).__name__}: {str(e)[:200]}"})
        if stuck:
            return record(cid, {"verdict": "unchecked", "class": "", "notes": [],
                                "reason": f"did not run on the node ({TRIES} tries, {PAUSE // 60} minutes apart): {stuck[0]}"})
        fails = [f"{w}: {f}" for w, s, f in rows if s == verify.FAIL]
        if fails:
            return record(cid, {"verdict": "reject", "class": "unproven", "notes": [], "reason": f"fails on the node: {fails[0]}"})
        if cid in previous:
            p = previous[cid]
            (ev / "previous.json").write_text(json.dumps({k: p.get(k) for k in ("verdict", "class", "reason", "notes")}, indent=1))
            if p.get("commit") and p["commit"] != head:
                try:
                    git("fetch", "--quiet", "--no-tags", "origin", p["commit"])
                    diff = git("diff", p["commit"], head, "--", path)
                except subprocess.CalledProcessError:
                    diff = "(the version you judged is no longer on GitHub)"
                (ev / "diff.md").write_text(diff or "(the card did not change)")
            said = [f"### {c['login']}, {c['at']}\n{c['body'][:3000]}" for c in comments if c["at"] > p.get("at", "")]
            if said:
                (ev / "thread.md").write_text("\n\n".join(said)[:12000])
        errors = 0
        while True:
            wait_limit()
            if stop["login"]:
                return
            try:
                return record(cid, ask(ev, block))
            except Limit as e:
                with lock:
                    pause["until"] = max(pause["until"], e.until or time.time() + 900)
                    if not pinged.is_set():
                        pinged.set()
                        ping(f"Claude's usage limit is reached; this review waits until "
                             f"{dt.datetime.fromtimestamp(pause['until'], dt.timezone.utc):%Y-%m-%d %H:%M} UTC and then continues.")
            except LoginFailed as e:
                stop["login"] = str(e)
                return
            except (RuntimeError, subprocess.TimeoutExpired) as e:
                errors += 1
                print(f"  {cid}: no verdict ({errors}): {str(e)[:200]}", flush=True)
                if errors == 3:
                    return record(cid, {"verdict": "unchecked", "class": "", "notes": [], "reason": f"Claude gave no verdict: {str(e)[:160]}"})
                time.sleep(60 * errors)

    paused = False
    with cf.ThreadPoolExecutor(PARALLEL) as ex:
        for f in [ex.submit(one, c) for c in todo]:
            try:
                f.result()
            except Paused:
                paused = True
    if stop["login"]:
        publish(f"**Claude's login failed:** {stop['login'][:200]}. Renew `CLAUDE_CODE_OAUTH_TOKEN` (`claude setup-token`, then "
                "`gh secret set CLAUDE_CODE_OAUTH_TOKEN`) and comment `/verify`.", extra)
        ping("Claude's login failed, so this review stopped; renew `CLAUDE_CODE_OAUTH_TOKEN` and comment `/verify`.")
        status("error", "Claude's login failed")
        return 1
    if paused:
        until = f"{dt.datetime.fromtimestamp(pause['until'], dt.timezone.utc):%Y-%m-%dT%H:%MZ}"
        publish(f"**Paused by Claude's usage limit** until {until}; it continues by itself.", extra)
        status("pending", f"paused: usage limit, resumes after {until}")
        return 0

    rejected = [c for c in cards if reg.get(c, {}).get("verdict") == "reject"]
    unchecked = [c for c in cards if reg.get(c, {}).get("verdict") == "unchecked"]
    trusted = author in MAINTAINERS
    if len(waiting) > len(todo):
        state = f"**{many(len(waiting) - len(todo), 'card')} left for the next run**, which starts by itself."
    elif unchecked:
        state = f"**{many(len(unchecked), 'card')} not checked yet.** Comment `/verify` to try again."
    elif not (rejected or blocked or orphans or loose) and trusted:
        state = ("**Every card holds.** Not merged: the pull request is labeled `no-merge`." if held else
                 "**Every card holds.** Approved; merging once the `check` and `board` jobs pass.")
    else:
        state = "**A maintainer decides:** " + ", ".join(x for x in [
            f"{many(len(rejected), 'card')} rejected" if rejected else "", f"{many(len(blocked), 'file')} outside the cards" if blocked else "",
            f"{many(len(orphans), 'card')} removed without a new card" if orphans else "", "other files fail tools/build.py" if loose else "",
            f"@{author} is not a maintainer" if not trusted else ""] if x) + "."
    publish(state, extra)
    if dry:
        print(render(cards, reg, extra, state, link))
        return 0
    if len(waiting) > len(todo):
        gh("workflow", "run", "verify.yml", "-R", repo, "--ref", "main", "-f", f"pr={n}")
        status("pending", f"{many(len(waiting) - len(todo), 'card')} left for the next run")
        return 0
    if unchecked:
        status("pending", f"{many(len(unchecked), 'card')} not checked")
        ping(f"{many(len(unchecked), 'card')} of this pull request could not be checked; see the verifier's comment.")
        return 0
    if state.startswith("**Every card holds"):
        status("success", f"all {len(cards)} cards hold")
        why = None if held else merge(repo, n, head, "Every card holds: see the verifier's comment.")
        if why:
            publish(f"**Every card holds, but it is not merged:** {why}.", extra)
        return 0
    status("failure", f"{len(cards) - len(rejected)} of {len(cards)} cards hold; a maintainer decides")
    for m in MAINTAINERS:
        subprocess.run(["gh", "pr", "edit", str(n), "-R", repo, "--add-reviewer", m], capture_output=True)
    if todo:
        ping(state.removeprefix("**A maintainer decides:** ").rstrip(".") + ": see the verifier's comment.")
    return 0


def merge(repo: str, n: int, head: str, review: str) -> str | None:
    """Approve, wait for the check and board jobs, merge, publish the site; None once merged, else why not."""
    gh("pr", "review", str(n), "-R", repo, "--approve", "--body", review)
    why = wait_checks(repo, head)
    if why:
        return why
    try:
        gh("pr", "merge", str(n), "-R", repo, "--merge", "--match-head-commit", head)
    except subprocess.CalledProcessError as e:
        return f"the merge was refused: {e.stderr.strip()[:300]}"
    gh("workflow", "run", "pages.yml", "-R", repo, "--ref", "main")  # a merge by the workflow's token triggers no workflow
    return None


def resume() -> int:
    """Dispatch a review for every open pull request a usage limit paused, once the limit has reset."""
    repo = os.environ.get("GITHUB_REPOSITORY") or gh("repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner").strip()
    for pr in gh_list(f"repos/{repo}/pulls?state=open&per_page=100", "{number, sha: .head.sha}"):
        mine = [s for s in gh_list(f"repos/{repo}/commits/{pr['sha']}/statuses", "{context, state, description}") if s["context"] == "verifier"]
        m = re.search(r"resumes after (\S+)", mine[0]["description"] or "") if mine and mine[0]["state"] == "pending" else None
        if m and dt.datetime.fromisoformat(m.group(1).replace("Z", "+00:00")) <= dt.datetime.now(dt.timezone.utc):
            gh("workflow", "run", "verify.yml", "-R", repo, "--ref", "main", "-f", f"pr={pr['number']}")
            print(f"pull request {pr['number']}: review resumed")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("pr", nargs="?", type=int)
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--card", type=Path)
    ap.add_argument("--resume", action="store_true")
    ap.add_argument("--mcp", type=int, metavar="BLOCK")
    args = ap.parse_args()
    if args.mcp is not None:
        mcp(args.mcp)
        return 0
    if args.resume:
        return resume()
    if args.card:
        text = args.card.read_text(encoding="utf-8")
        url = str((split(text)[0].get("contract") or {}).get("code_url") or "")
        code = {url: (ROOT / url).read_text()} if url.startswith("code/") and (ROOT / url).exists() else {}
        forward()
        ev, rows = prepare(args.card.stem, f"findings/{args.card.name}", text, code, view({}, set()))
        print(f"evidence: {ev}")
        fails = [f"{w}: {s}: {f}" for w, s, f in rows if s == verify.FAIL]
        print("\n".join(fails) if fails else json.dumps(ask(ev, int(split(text)[0].get("block") or 0)), indent=1))
        return 0
    if args.pr is None:
        ap.error("give a pull request number, --card FILE, --resume or --mcp BLOCK")
    return run(args.pr, args.dry)


if __name__ == "__main__":
    sys.exit(main())
