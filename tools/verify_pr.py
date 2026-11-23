# /// script
# requires-python = ">=3.10"
# dependencies = ["pyyaml", "eth-abi", "pycryptodome"]
# ///
"""Check the cards a pull request adds or changes before they enter the registry (.github/workflows/verify.yml).

    uv run tools/verify_pr.py PR           check every card, then approve and merge, or ask the maintainers
    uv run tools/verify_pr.py PR --dry     check, and print the comment instead of posting or merging anything
    uv run tools/verify_pr.py --card FILE  check one card file and print the verdict

Needs an archive node at ETH_RPC_URL (with debug_traceTransaction), `claude` signed in (CLAUDE_CODE_OAUTH_TOKEN in
CI), and for a pull request `gh` (GH_TOKEN) with the repository checked out at its base.

For each card the pull request adds or changes: tools/verify.py re-runs its facts and checks on the node; the verified
source, the decompiled code it links and call traces of the transactions it cites are saved beside it; then Claude
(claude-sonnet-5, effort xhigh, read-only tools) answers valid, invalid or unsure, with its reasons
(tools/verify_pr.md). Severity is not judged. The pull request's files are data: nothing from them runs.

The bot's comment is the registry of the cards checked so far: each card's SHA-256 and verdict. A later run checks
only the cards whose file changed, so a run cut short continues where it stopped.

The pull request is approved and merged only when every card is valid with no check failing on the node, no card is
removed without a new card for its contract, and it touches nothing but cards, triage entries, decompiled code and the
review's queue files. Otherwise the comment lists what is in doubt and the maintainers are asked to review.
"""

import argparse
import base64
import concurrent.futures as cf
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
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

WORK = ROOT / "ci-work"  # evidence and source caches; git-ignored
MODEL, EFFORT = "claude-sonnet-5", "xhigh"
PARALLEL = int(os.environ.get("VERIFY_PARALLEL", "2"))
MAINTAINERS = [m for m in os.environ.get("MAINTAINERS", "").split(",") if m]
# what a pull request may touch and still merge on its own: cards, triage entries, decompiled code, the queue's state
AUTO = re.compile(r"^(findings/|triage/|code/|review/held/|review/(queue\.tsv|ledger\.tsv|added\.jsonl)$)")
CARD = re.compile(r"^format:\s*2\s*$", re.M)
TX_LINK = re.compile(r"/tx/(0x[0-9a-fA-F]{64})")
TX_HASH = re.compile(r"0x[0-9a-f]{64}")
MARK, BOT = "<!-- pq-verifier -->", "github-actions[bot]"
REGISTRY = re.compile(r"<!-- registry ([A-Za-z0-9+/=]+) -->")
PRECOMPILES = {f"0x{n:040x}": name for n, name in [
    (1, "ecrecover"), (2, "sha256"), (3, "ripemd160"), (4, "identity"), (5, "modexp"), (6, "bn254 add"), (7, "bn254 mul"),
    (8, "bn254 pairing"), (9, "blake2f"), (10, "kzg point evaluation"), (11, "bls12-381 g1 add"), (12, "bls12-381 g1 msm"),
    (13, "bls12-381 g2 add"), (14, "bls12-381 g2 msm"), (15, "bls12-381 pairing"), (16, "bls12-381 map fp to g1"),
    (17, "bls12-381 map fp2 to g2"), (0x100, "p256verify")]}
SCHEMA = {"type": "object", "additionalProperties": False, "required": ["verdict", "summary", "problems", "gaps"],
          "properties": {"verdict": {"enum": ["valid", "invalid", "unsure"]}, "summary": {"type": "string"},
                         "problems": {"type": "array", "items": {"type": "string"}},
                         "gaps": {"type": "array", "items": {"type": "string"}}}}
ICON = {"valid": "✅ valid", "invalid": "❌ invalid", "unsure": "❓ unsure"}


def gh(*args: str, body: dict | None = None) -> str:
    return subprocess.run(["gh", *args] + (["--input", "-"] if body is not None else []), check=True, capture_output=True,
                          text=True, input=json.dumps(body) if body is not None else None).stdout


def gh_list(path: str, jq: str) -> list:
    """Every item of a paginated list, through a jq projection."""
    return [json.loads(x) for x in gh("api", path, "--paginate", "--jq", f".[] | {jq} | @json").splitlines() if x]


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(ROOT), *args], check=True, capture_output=True, text=True).stdout


def header(text: str) -> dict:
    end = text.find("\n---\n", 4)
    try:
        head = yaml.load(text[4:end], Loader=build.Loader) if text.startswith("---\n") and end > 0 else None
    except yaml.YAMLError:
        head = None
    return head if isinstance(head, dict) else {}


def contract(text: str) -> dict:
    c = header(text).get("contract")
    return c if isinstance(c, dict) else {}


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


def prepare(cid: str, text: str, code: dict[str, str]) -> tuple[Path, list]:
    """The evidence folder of one card: the card, its re-run, its sources, its decompiled code, its traces."""
    ev = WORK / "cards" / cid
    shutil.rmtree(ev, ignore_errors=True)
    ev.mkdir(parents=True)
    card = ev / "card.md"
    card.write_text(text, encoding="utf-8")
    rows = verify.verify_file(card, {"value": False, "names": True, "no_facts": False, "sources": WORK / "sources", "replays": {}})
    (ev / "verify.json").write_text(json.dumps([{"what": w, "status": s, "found": f} for w, s, f in rows], indent=1))
    c = contract(text)
    checks = [x for x in header(text).get("checks") or [] if isinstance(x, dict)]
    for a in dict.fromkeys(str(a).lower() for a in [c.get("address"), c.get("proxy_of")] + [x.get("source") for x in checks] if a):
        for p, t in verify.sources_of(a, WORK / "sources").items():
            dest = ev / "source" / a / safe(p)
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(t, encoding="utf-8")
    if str(c.get("code_url") or "") in code:
        (ev / "code").mkdir()
        (ev / "code" / Path(c["code_url"]).name).write_text(code[c["code_url"]], encoding="utf-8")
    txs = {str(x.get(k)).lower() for x in checks for k in ("tx", "replay") if x.get(k)} | {t.lower() for t in TX_LINK.findall(text)}
    for tx in sorted(t for t in txs if TX_HASH.fullmatch(t)):
        try:
            frame = compact(nf.rpc("debug_traceTransaction", [tx, {"tracer": "callTracer"}]))
        except Exception as e:
            frame = {"error": f"not traced: {str(e)[:200]}"}
        (ev / "traces").mkdir(exist_ok=True)
        (ev / "traces" / f"{tx}.json").write_text(json.dumps(frame, indent=1))
    return ev, rows


def judge(ev: Path, rows: list) -> dict | None:
    """Claude's verdict on one prepared card, or None when it could not answer (left for the next run)."""
    rel = ev.relative_to(ROOT).as_posix()
    cmd = ["claude", "-p", (ROOT / "tools" / "verify_pr.md").read_text().replace("{folder}", rel),
           "--model", MODEL, "--effort", EFFORT, "--permission-mode", "dontAsk", "--restricted",
           "--allowedTools", f"Read(./{rel}/**),Read(./AGENTS.md),Read(./patterns.md),Grep,Glob",
           "--disallowedTools", "Bash,Edit,Write,NotebookEdit,WebFetch,WebSearch,Task",
           "--output-format", "json", "--json-schema", json.dumps(SCHEMA)]
    for attempt in range(3):
        r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, timeout=5400)
        try:
            out = json.loads(r.stdout)
        except json.JSONDecodeError:
            out = {"is_error": True, "result": (r.stdout + r.stderr)[-300:]}
        v = out.get("structured_output")
        if not isinstance(v, dict):
            try:
                v = json.loads(out.get("result") or "")
            except (json.JSONDecodeError, TypeError):
                v = None
        if not out.get("is_error") and isinstance(v, dict) and v.get("verdict") in ICON:
            break
        print(f"  {ev.name}: no verdict (attempt {attempt + 1}): {str(out.get('result'))[:200]}", flush=True)
        time.sleep(60 * (attempt + 1))
    else:
        return None
    v = {k: v.get(k) or ([] if k in ("problems", "gaps") else "") for k in ("verdict", "summary", "problems", "gaps")}
    fails = [f"{w}: {f}" for w, s, f in rows if s == verify.FAIL]
    if fails and v["verdict"] == "valid":  # a fact or check the node does not show leaves the card unproven
        v["verdict"], v["problems"] = "unsure", v["problems"] + [f"fails on the node: {x}" for x in fails]
    return v


def load_registry(repo: str, n: int) -> tuple[int | None, dict]:
    """The bot's comment on the pull request and the registry it carries; only the bot's own comment counts."""
    for c in gh_list(f"repos/{repo}/issues/{n}/comments", "{id, login: .user.login, body}"):
        if c["login"] == BOT and MARK in c["body"]:
            m = REGISTRY.search(c["body"])
            return c["id"], json.loads(zlib.decompress(base64.b64decode(m.group(1)))) if m else {}
    return None, {}


def wait_checks(repo: str, head: str, names=("check", "board"), minutes: int = 90) -> str | None:
    """None once the required jobs have passed on the head commit, else what is wrong."""
    for _ in range(minutes * 2):
        runs = {r["name"]: r for r in gh_list(f"repos/{repo}/commits/{head}/check-runs", "{name, conclusion}")}
        bad = [x for x in names if runs.get(x, {}).get("conclusion") not in (None, "success")]
        if bad:
            return f"the {', '.join(bad)} job failed"
        if all(runs.get(x, {}).get("conclusion") == "success" for x in names):
            return None
        time.sleep(30)
    return f"the {', '.join(names)} jobs did not finish within {minutes} minutes"


def render(cards: dict, reg: dict, blocked: list, orphans: list, state: str, link) -> str:
    def cut(s: str, n: int = 400) -> str:
        s = " ".join(str(s).split())
        return s if len(s) <= n else s[:n] + "…"
    count = {k: sum(1 for c in cards if reg.get(c, {}).get("verdict") == k) for k in ICON}
    left = sum(1 for c in cards if c not in reg)
    out = [MARK, f"### Card check: {count['valid']} valid, {count['invalid']} invalid, {count['unsure']} unsure, "
                 f"{left} not checked yet, of {len(cards)}", "", state, ""]
    doubt = sorted(c for c in cards if reg.get(c, {}).get("verdict") in ("invalid", "unsure"))
    if doubt:
        out += ["| Card | Verdict | Why |", "|---|---|---|"]
        out += [f"| [`{c}`]({link(cards[c][0])}) | {ICON[reg[c]['verdict']]} | "
                f"{cut('; '.join(reg[c]['problems']) or reg[c]['summary']).replace('|', '/')} |" for c in doubt] + [""]
    if blocked:
        out += ["**Files only a maintainer merges:**"] + [f"- `{p}`" for p in blocked[:40]] + (["- …"] if len(blocked) > 40 else []) + [""]
    if orphans:
        out += ["**Cards removed with no new card for their contract:**"] + [f"- `{p}` ({a})" for p, a in orphans[:40]] + [""]
    valid = sorted(c for c in cards if reg.get(c, {}).get("verdict") == "valid")
    notes = [f"- `{c}`: {cut('; '.join(reg[c]['gaps']), 300)}" for c in sorted(reg) if c in cards and reg[c].get("gaps")]
    tail = [f"<!-- registry {base64.b64encode(zlib.compress(json.dumps(reg, separators=(',', ':')).encode(), 9)).decode()} -->"]
    for extra in ([f"<details><summary>{len(valid)} valid</summary>\n\n" + ", ".join(f"`{c}`" for c in valid) + "\n</details>", ""] if valid else [],
                  ["<details><summary>Missing information (does not block)</summary>\n"] + notes + ["</details>", ""] if notes else []):
        if len("\n".join(out + extra + tail)) < 60000:
            out += extra
    body = "\n".join(out + tail)
    for name in ("GH_TOKEN", "GITHUB_TOKEN", "CLAUDE_CODE_OAUTH_TOKEN"):  # a secret never reaches a public comment
        if len(os.environ.get(name, "")) > 8:
            body = body.replace(os.environ[name], "[redacted]")
    return body


def run(n: int, dry: bool) -> int:
    repo = os.environ.get("GITHUB_REPOSITORY") or gh("repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner").strip()
    pr = json.loads(gh("api", f"repos/{repo}/pulls/{n}"))
    files = gh_list(f"repos/{repo}/pulls/{n}/files", "{status, filename, previous_filename}")
    git("fetch", "--quiet", "--no-tags", "--depth=1", "origin", f"pull/{n}/head")
    head = git("rev-parse", "FETCH_HEAD").strip()  # the pull request's head, read as data only
    show = lambda ref, p: git("show", f"{ref}:{p}")
    link = lambda p: f"https://github.com/{(pr['head'].get('repo') or {}).get('full_name') or repo}/blob/{head}/{p}"

    cards, code, blocked, removed = {}, {}, [], []
    for f in files:
        status, path, prev = f["status"], f["filename"], f.get("previous_filename")
        blocked += [p for p in (path, prev) if p and not AUTO.match(p)]
        gone = prev if status == "renamed" else path if status == "removed" else None
        if gone and gone.startswith("findings/") and gone.endswith(".md"):
            try:
                old = show("HEAD", gone)
            except subprocess.CalledProcessError:
                old = ""
            if CARD.search(old.split("\n---", 1)[0]):
                removed.append((gone, str(contract(old).get("address") or "").lower()))
        if status == "removed":
            continue
        if path.startswith("code/"):
            code[path] = show(head, path)
        if path.startswith("findings/") and path.endswith(".md"):
            text = show(head, path)
            if CARD.search(text.split("\n---", 1)[0]):
                cards[Path(path).stem] = (path, text)
            elif status == "added":
                blocked.append(f"{path} (a new format 1 file)")
    for path in {str(contract(t).get("code_url") or "") for _, t in cards.values()}:
        if path.startswith("code/") and path not in code:
            try:
                code[path] = show(head, path)
            except subprocess.CalledProcessError:
                pass
    addresses = {str(contract(t).get("address") or "").lower() for _, t in cards.values()}
    orphans = [(p, a) for p, a in removed if a not in addresses]

    comment, reg = load_registry(repo, n)
    reg = {c: e for c, e in reg.items() if c in cards and e.get("sha") == sha16(cards[c][1])}
    todo = sorted(c for c in cards if c not in reg)
    lock = threading.Lock()

    def publish(state: str) -> None:
        nonlocal comment
        body = render(cards, reg, blocked, orphans, state, link)
        if dry:
            return
        if comment:
            gh("api", "-X", "PATCH", f"repos/{repo}/issues/comments/{comment}", body={"body": body})
        else:
            comment = json.loads(gh("api", "-X", "POST", f"repos/{repo}/issues/{n}/comments", body={"body": body}))["id"]

    def one(cid: str) -> None:
        try:
            ev, rows = prepare(cid, cards[cid][1], code)
            v = judge(ev, rows)
        except Exception as e:  # left unchecked: the next run tries it again
            print(f"  {cid}: not checked: {type(e).__name__}: {str(e)[:200]}", flush=True)
            v = None
        with lock:
            if v:
                reg[cid] = {"sha": sha16(cards[cid][1]), **v}
            print(f"{cid}: {v['verdict'] if v else 'not checked'}", flush=True)
            publish(f"Checking: {sum(1 for c in cards if c in reg)} of {len(cards)} done.")

    print(f"pull request {n}: {len(cards)} cards, {len(cards) - len(todo)} already checked, {len(todo)} to check", flush=True)
    publish(f"Checking: {len(cards) - len(todo)} of {len(cards)} done.")
    with cf.ThreadPoolExecutor(PARALLEL) as ex:
        list(ex.map(one, todo))

    left = [c for c in cards if c not in reg]
    doubt = [c for c in cards if c in reg and reg[c]["verdict"] != "valid"]
    ok = not (left or doubt or blocked or orphans)
    if left:
        state = f"**{len(left)} cards could not be checked this time.** Run the workflow again: the checked ones are kept."
    elif ok:
        state = "**Every card holds.** Approved; merging once the `check` and `board` jobs pass."
    else:
        state = "**A maintainer has to review this pull request:** " + ", ".join(
            x for x in [f"{len(doubt)} cards in doubt" if doubt else "", f"{len(blocked)} files outside the cards" if blocked else "",
                        f"{len(orphans)} cards removed without a new card" if orphans else ""] if x) + "."
    publish(state)
    if dry:
        print(render(cards, reg, blocked, orphans, state, link))
        return 0 if ok else 1
    gh("api", "-X", "POST", f"repos/{repo}/statuses/{head}", body={
        "state": "pending" if left else "success" if ok else "failure", "context": "verifier",
        "description": f"{len(cards) - len(left) - len(doubt)} of {len(cards)} cards hold" + (", maintainer needed" if not (ok or left) else "")})
    if ok:
        gh("pr", "review", str(n), "-R", repo, "--approve", "--body", "Every card holds: see the verifier's comment.")
        why = wait_checks(repo, head)
        if not why:
            try:
                gh("pr", "merge", str(n), "-R", repo, "--merge", "--match-head-commit", head)
                gh("workflow", "run", "pages.yml", "-R", repo, "--ref", "main")  # a merge by the workflow's token triggers no workflow
                return 0
            except subprocess.CalledProcessError as e:
                why = f"the merge was refused: {e.stderr.strip()[:300]}"
        publish(f"**Every card holds, but it is not merged:** {why}. Bring the branch up to date with `main`, or merge by hand.")
    elif not left:
        for m in MAINTAINERS:
            subprocess.run(["gh", "pr", "edit", str(n), "-R", repo, "--add-reviewer", m], capture_output=True)
    return 1 if left else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("pr", nargs="?", type=int)
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--card", type=Path)
    args = ap.parse_args()
    if args.card:
        text = args.card.read_text(encoding="utf-8")
        url = str(contract(text).get("code_url") or "")
        code = {url: (ROOT / url).read_text()} if url.startswith("code/") and (ROOT / url).exists() else {}
        ev, rows = prepare(args.card.stem, text, code)
        print(f"evidence: {ev}")
        print(json.dumps(judge(ev, rows), indent=1))
        return 0
    if args.pr is None:
        ap.error("give a pull request number or --card FILE")
    return run(args.pr, args.dry)


if __name__ == "__main__":
    sys.exit(main())
