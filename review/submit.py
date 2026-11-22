"""The only way an author finishes a row: the draft is checked, the finding is written by this tool, not by hand.

    ... -m review.submit KEY --who NAME [--draft FILE] [--dry]

Reads work/out/<address>-<issue>/draft.json (see AUTHOR.md for its fields). In this order:

  1. the draft's shape: every sentence, bullet, the justification and the action name the checks that back them;
  2. every check is run through the gateway, and must give the result it states;
  3. the finding file is written from the tool's facts (the dossier) and the draft's judgment;
  4. tools/build.py checks the file's format; tools/verify.py compares its facts with the tool's.

Any problem is printed and nothing is accepted. Without problems: finding.md, card.md (what a reader sees) and
results.json are written next to the draft and the row moves to `authored`. A draft whose verdict is `not-affected`
or `question` writes proposal.json instead. --dry checks without accepting.
"""

import argparse
import json
import os
import re
import sys
import tempfile
from pathlib import Path

import yaml

from . import AS_OF, GATEWAY, H, ISSUES, REGISTRY, WORK, key_dir
from . import rows as R

import build  # noqa: E402
import verify  # noqa: E402

VERDICTS = ("finding", "not-affected", "question")
PART = re.compile(r"^(what|evidence-[123]|justification|action|notes|proxy_of|upgradeable|admin|name|whose)$")
_REG: dict = {}


def registry() -> tuple[dict, dict, dict]:
    """(patterns, studies, category names) of the registry, loaded once."""
    if not _REG:
        p = build.Problems()
        _, _REG["patterns"] = build.load_patterns(p)
        _REG["studies"] = {s["id"]: s for path in sorted((REGISTRY / "studies").glob("*/README.md")) if (s := build.load_study(path, p)) is not None}
        _REG["categories"] = build.categories()
    return _REG["patterns"], _REG["studies"], _REG["categories"]


def out_dir(key: str) -> Path:
    return WORK / "out" / key_dir(key)


def dossier(key: str) -> dict:
    from .dossier import ensure
    return json.loads((ensure(key) / "dossier.json").read_text())


def replays_of(d: dict) -> dict:
    """tx -> {run: succeeded} for the replays whose unmodified run reproduced the real receipt."""
    out = {}
    for fam in (d["scan"].get("families") or {}).values():
        for r in fam.get("replays") or []:
            today = (r.get("runs") or {}).get("today") or {}
            if r.get("tx") and today.get("ok") and today.get("as_receipt"):
                out[r["tx"].lower()] = {k: v["ok"] for k, v in r["runs"].items() if v.get("ok") is not None}
    return out


def texts(items, where: str, problems: list) -> list[dict]:
    if not isinstance(items, list) or not all(isinstance(x, dict) and isinstance(x.get("text"), str) and isinstance(x.get("checks"), list) for x in items):
        problems.append(f"{where} must be a list of {{\"text\": ..., \"checks\": [ids]}}")
        return []
    return items


def shape(draft: dict) -> tuple[list[str], dict[str, set]]:
    """Problems of the draft's shape, and for each check id the parts of the card it backs."""
    problems, backs = [], {}
    if draft.get("verdict") not in VERDICTS:
        return [f"verdict must be one of {list(VERDICTS)}"], {}
    checks = draft.get("checks") if isinstance(draft.get("checks"), list) else []
    ids = [c.get("id") for c in checks if isinstance(c, dict)]
    if len(ids) != len(checks) or len(set(ids)) != len(ids) or not all(isinstance(i, str) and build.CHECK_ID.match(i) for i in ids):
        problems.append("checks: a list of mappings, each with its own short lowercase `id`")
    for c in checks:
        if isinstance(c, dict) and ("for" in c):
            problems.append(f"check {c.get('id')}: leave `for` out, this tool fills it from where the check is used")

    def use(part: str, used, where: str):
        if not isinstance(used, list) or not used:
            problems.append(f"{where} names no check: nothing goes on the card without one")
            return
        for i in used:
            if i not in ids:
                problems.append(f"{where} names check {i!r}, which is not in `checks`")
            backs.setdefault(i, set()).add(part)

    if draft["verdict"] == "finding":
        what = texts(draft.get("what"), "what", problems)
        if not what:
            problems.append("what: one entry per sentence of What happens")
        for i, s in enumerate(what, 1):
            use("what", s["checks"], f"what, sentence {i}")
        ev = texts(draft.get("evidence"), "evidence", problems)
        if not 1 <= len(ev) <= 3:
            problems.append("evidence: one to three bullets")
        for i, b in enumerate(ev, 1):
            use(f"evidence-{i}", b["checks"], f"evidence bullet {i}")
        for part in ("justification", "action"):
            v = draft.get(part)
            if v is None and part == "action":
                continue
            if not isinstance(v, dict) or not isinstance(v.get("text"), str):
                problems.append(f"{part} must be {{\"text\": ..., \"checks\": [ids]}}" + (" or null" if part == "action" else ""))
            else:
                use(part, v.get("checks"), part)
        for fact, v in (draft.get("facts") or {}).items():
            if fact not in ("proxy_of", "upgradeable", "admin", "name", "project", "label"):
                problems.append(f"facts.{fact}: only proxy_of, upgradeable, admin, name, project and label can be stated here")
            elif fact in build.CHECK_FACTS:
                if not isinstance(v, dict) or "value" not in v:
                    problems.append(f"facts.{fact} must be {{\"value\": ..., \"checks\": [ids]}}")
                else:
                    use(fact, v.get("checks"), f"facts.{fact}")
                    said = [c for c in checks if isinstance(c, dict) and c.get("id") in (v.get("checks") or [])]
                    if fact in ("admin", "proxy_of") and v["value"] not in (None, "none") and not any(
                            str(v["value"]).lower()[2:] in json.dumps(c.get("is", "")).lower() for c in said if "call" in c or "storage" in c):
                        problems.append(f"facts.{fact}: one of its checks must be a call or a storage read whose `is` is that address")
        w = draft.get("whose")
        if w is not None and (not isinstance(w, dict) or w.get("value") not in build.WHOSE):
            problems.append(f"whose must be null or {{\"value\": one of {list(build.WHOSE)}, \"checks\": [ids]}}")
        elif w is not None:
            use("whose", w.get("checks"), "whose")
        if not isinstance(draft.get("mechanism"), str) or not 40 <= len(draft["mechanism"]) <= 1500:
            problems.append("mechanism: 40 to 1,500 characters, the path through the code for this contract")
        if not isinstance(draft.get("ruled_out"), list) or not all(isinstance(x, str) for x in draft.get("ruled_out") or []):
            problems.append("ruled_out: a list of lines, what you tried in order to disprove the finding and what it showed")
        if draft.get("issue") not in ISSUES and not (isinstance(draft.get("issue"), str) and build.SLUG.match(draft["issue"]) and len(draft["issue"]) <= 40):
            problems.append("issue: the root issue's name, or for a first-study finding a short slug")
    if draft["verdict"] == "not-affected":
        dp = draft.get("disproof")
        if not isinstance(dp, dict) or not isinstance(dp.get("text"), str) or len(dp["text"]) < 40:
            problems.append("disproof must be {\"text\": why it is not affected (40+ characters), \"checks\": [ids]}")
        else:
            use("notes", dp.get("checks"), "disproof")
    if draft["verdict"] == "question" and not draft.get("questions"):
        problems.append("a question verdict needs `questions`")
    if not isinstance(draft.get("questions") or [], list):
        problems.append("questions must be a list of lines")
    for i in ids:
        backs.setdefault(i, set()).add("notes") if i not in backs else None
    return problems, backs


def run_checks(draft: dict, d: dict) -> tuple[list[str], list[dict]]:
    ctx = {"sources": WORK / "sources", "replays": replays_of(d)}
    problems, results = [], []
    for c in draft.get("checks") or []:
        kinds = [k for k in build.CHECK_KINDS if k in c]
        if len(kinds) != 1:
            problems.append(f"check {c.get('id')}: needs exactly one of {list(build.CHECK_KINDS)}")
            continue
        try:
            status, found = verify.run_check(c, H, ctx)
        except Exception as e:
            status, found = verify.FAIL, f"could not run: {type(e).__name__}: {str(e)[:120]}"
        if status == verify.SKIP and kinds[0] == "replay":
            status, found = verify.FAIL, "no replay of this transaction with that run is in the dossier (scan.families.*.replays)"
        results.append({"id": c.get("id"), "says": c.get("says"), "status": status, "found": found})
        if status == verify.FAIL:
            problems.append(f"check {c.get('id')} fails: it states {json.dumps({k: v for k, v in c.items() if k not in ('id', 'says')})[:200]}; found: {found}")
    return problems, results


def dated(v, key: str = ""):
    """The header with its dates as YAML dates (build.py wants a date, not text)."""
    if isinstance(v, dict):
        return {k: dated(x, k) for k, x in v.items()}
    if isinstance(v, list):
        return [dated(x, key) for x in v]
    if key in ("as_of", "last", "date") and isinstance(v, str) and re.fullmatch(r"\d{4}-\d\d-\d\d", v):
        return __import__("datetime").date.fromisoformat(v)
    return v


def slug(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", str(text).lower()).strip("-")


def render(draft: dict, d: dict, backs: dict[str, set]) -> tuple[str, str, dict]:
    """(finding id, file text, header) from the tool's facts and the draft's judgment."""
    patterns, _, _ = registry()
    r, f = d["row"], d["facts"]
    over = draft.get("facts") or {}
    fact = lambda k: over[k]["value"] if isinstance(over.get(k), dict) else f.get(k)
    name = fact("name") or None
    fid = f"{slug(name or 'contract')}-{r['address'][2:10]}-{draft['issue']}"
    stated = fact("proxy_of")  # the tool's, or an author's backed by a check (a Safe's singleton in an older dossier)
    runs = stated or (d.get("implementation") or {}).get("address") or r["address"]  # a 7702 delegation sets no proxy_of
    # verified = the code that runs is verified: behind a proxy, clone or delegation, the implementation's
    if stated and stated != f.get("proxy_of"):
        verified = verify.nf.verification(stated)[0]
    else:
        verified = ((d.get("implementation") or {}).get("facts") or {}).get("verified") if d.get("implementation") else f["verified"]
    decompiled = bool(draft.get("used_decompiled")) and not verified and d.get("decompiled")
    code_hash = ((d.get("implementation") or {}).get("facts") or f)["code_hash"]
    solo = (r.get("copies") or 1) == 1
    fams = [x for x in str(r.get("family") or "").split(", ") if x]
    # Money is what the tool reads as held at this address (one card describes one address in use; its copies
    # are their own rows). Old escrow and market-cap figures are not carried over: no tool here re-reads them; what is
    # at stake elsewhere goes in What happens, checked.
    usd, basis = f.get("value_usd"), "held"
    if draft.get("pattern") in ("PQ-1", "PQ-2"):  # a forged permit reaches every holder: the token's supply (AGENTS.md, value.basis)
        cap = verify.nf.Value(hex(H), verify.nf.block_time(H)[1]).supply_usd(r["address"])
        if cap is not None:
            usd, basis = cap, "market-cap"
    whose = (draft.get("whose") or {}).get("value")
    status = "candidate" if (draft.get("questions") or draft.get("evidence_level") == "bytecode") else "confirmed"
    checks = [{**c, "for": sorted(backs.get(c["id"], {"notes"}))} for c in draft["checks"]]
    old = None
    if r["src"] == "finding":  # once filed, the old file is gone and the card it became keeps its sources
        p = next((x for x in (REGISTRY / r["old_path"], out_dir(d["key"]) / "finding.md") if x.exists()), None)
        old = build.split(p, build.Problems())[0] if p else None
    sources = [{k: s[k] for k in ("study", "who", "date", "by", "verdict", "rating") if s.get(k) is not None} for s in (old or {}).get("sources") or r.get("sources") or []] or [
        {"study": "eip-8151-impact", "who": "Claude (families read, judged from bytecode or placed by measured rules)", "date": "2026-11-19",
         "by": "ai-assisted", "verdict": "reported"}]
    drop = lambda m: {k: v for k, v in m.items() if v not in (None, "", [])}
    head = drop({
        "id": fid, "format": 2, "title": draft.get("title"), "status": status, "severity": draft.get("severity"),
        "justification": (draft.get("justification") or {}).get("text"), "category": patterns.get(draft.get("pattern"), {}).get("category"),
        "pattern": draft.get("pattern"), "study": r.get("study") or "eip-8151-impact", "as_of": AS_OF, "block": H,
        "contract": drop({"address": r["address"], "name": name, "project": over.get("project"), "label": over.get("label"),
                          "code": "verified" if verified else "decompiled" if decompiled else "bytecode",
                          "code_url": f"code/{code_hash}.sol" if decompiled else f"https://etherscan.io/address/{runs if verified else r['address']}#code",
                          "proxy_of": fact("proxy_of"), "copies": r.get("copies") or 1, "family": fams[0] if fams and not solo else None,
                          "upgradeable": fact("upgradeable"), "admin": fact("admin")}),
        "value": drop({"usd": int(usd) if usd is not None else None, "whose": whose, "basis": basis if usd is not None else None}),
        # the address's own count from the 90-day read (reading/row_activity.py, in the dossier's `use`), else the study's count for a
        # row that stands for one address; the study's last-activity date proved stale for busy contracts (wstETH, R-7f39c581)
        "activity": drop({"txs_90d": ((d.get("use") or {}).get("calls_in_90_days") or {}).get("transactions")
                          if (d.get("use") or {}).get("calls_in_90_days") else
                          int(float(r["txs"])) if solo and r.get("txs") not in (None, "") and r.get("txs_window") == "90d" else None}),
        "impact": draft.get("impact"), "action": (draft.get("action") or {}).get("text"), "evidence_level": draft.get("evidence_level"),
    })
    head.update({"checks": checks, "sources": sources, "reviews": [], "related": []})
    first = (sources[0].get("date"), sources[0].get("study"))
    notes = ["### Mechanism", "", draft["mechanism"].strip(), "", "### Checks", ""]
    notes += [f"- Header facts: this address alone, at block {H:,}" + ("" if solo else f"; {r['copies']:,} addresses run this code") + "."]
    notes += [f"- Ruled out: {x.strip()}" for x in draft.get("ruled_out") or []]
    if draft.get("questions"):
        notes += ["", "### Questions", ""] + [f"- {q.strip()}" for q in draft["questions"]]
    notes += ["", "### History", "", f"- {first[0]}: reported by study {first[1]}.", f"- {R.now()[:10]}: reviewed again and rewritten from checks that were re-run."]
    body = "\n".join(["## What happens", "", " ".join(s["text"].strip() for s in draft["what"]), "", "## Evidence", ""]
                     + [f"- {b['text'].strip()}" for b in draft["evidence"]] + ["", "## Reviewer notes", ""] + notes) + "\n"
    return fid, "---\n" + yaml.safe_dump(dated(head), sort_keys=False, allow_unicode=True, width=110, default_flow_style=False) + "---\n\n" + body, head


def card(head: dict, text: str) -> str:
    """What a reader of the site sees: nothing of the reviewer notes, the checks or the working fields."""
    patterns, studies, cats = registry()
    c, v, a = head.get("contract") or {}, head.get("value") or {}, head.get("activity") or {}
    body = text.split("\n---\n", 1)[1]
    what = body.split("## What happens", 1)[1].split("## Evidence", 1)[0].strip()
    ev = body.split("## Evidence", 1)[1].split("## Reviewer notes", 1)[0].strip()
    usd = v.get("usd")
    money = "not established" if usd is None else f"${usd:,}" + (
        {"users": ", users' funds", "operator": ", the operator's own", "mixed": ", users' and the operator's"}.get(v.get("whose"))
        or (", whose funds not established" if usd else ""))
    label = {"held": "Holds in ETH and priced tokens", "escrow": "A forged message could release", "market-cap": "Token supply affected (upper bound)"}.get(v.get("basis"), "Holds in ETH and priced tokens")
    if (c.get("copies") or 1) > 1:
        money += " (this address)"
    spec = (studies.get(head.get("study")) or {}).get("spec") or {}
    change = Path(spec["path"]).stem.upper() if spec.get("path") else "the change"  # EIPS/eip-8151.md -> EIP-8151
    lines = [f"[{head.get('severity')}] {cats.get(head.get('category'), head.get('category')).replace('<change>', change)} · {head.get('status')}  (as of {head.get('as_of')})",
             str(head.get("title")), "",
             f"Contract: {c.get('name') or 'unnamed'} {c.get('address')}" + (f" · project {c['project']}" if c.get("project") else "") + (f" · {c['label']}" if c.get("label") else ""),
             f"Found by: {head.get('study')} · {patterns.get(head.get('pattern'), {}).get('words', '')}",
             f"{label}: {money}",
             "Activity: " + (f"{a['txs_90d']:,} transactions in 90 days" if a.get("txs_90d") is not None else "not established"),
             f"Upgradeable: {c.get('upgradeable') or 'not established'}",
             f"Code: {c.get('code')} ({c.get('code_url')})", "",
             f"Why this severity: {head.get('justification')}", "",
             f"What happens: {what}", "",
             f"What the team can do: {head.get('action') or '(left empty)'}", "", "Evidence:", ev]
    return "\n".join(lines) + "\n"


def validate(fid: str, text: str, d: dict, draft: dict) -> list[str]:
    patterns, studies, _ = registry()
    problems = []
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        (root / "findings").mkdir()
        if "\n  code: decompiled\n" in text:
            (root / "code").mkdir()
            (root / "code" / re.search(r"code_url: code/(\S+)", text).group(1)).write_text((WORK / "dossier" / key_dir(d["key"]) / "decompiled.sol").read_text())
        path = root / "findings" / f"{fid}.md"
        path.write_text(text)
        p = build.Problems()
        build.load_finding(path, patterns, studies, p, pool="findings", root=root)
        problems += [str(x) for x in p]
        head, _ = build.split(path, build.Problems())
        for what, status, found in verify.check_facts(head, {"names": False, "value": False}):
            if status == verify.FAIL:
                problems.append(f"{what}: {found}. The tool's facts stand unless a check backs yours (draft `facts`).")
    return problems


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("key")
    ap.add_argument("--who", default=os.environ.get("REVIEW_WHO", "author"))
    ap.add_argument("--draft", type=Path)
    ap.add_argument("--dry", action="store_true")
    args = ap.parse_args()
    os.environ["ETH_RPC_URL"] = f"{GATEWAY}/{args.who}"
    out = out_dir(args.key)
    path = args.draft or out / "draft.json"
    if not path.exists():
        sys.exit(f"no draft at {path}")
    try:
        draft = json.loads(path.read_text())
    except json.JSONDecodeError as e:
        sys.exit(f"the draft is not valid JSON: {e}")
    d = dossier(args.key)
    problems, backs = shape(draft)
    results = []
    if not problems:
        more, results = run_checks(draft, d)
        problems += more
    fid = text = head = None
    if not problems and draft["verdict"] == "finding":
        try:
            fid, text, head = render(draft, d, backs)
            problems += validate(fid, text, d, draft)
        except Exception as e:
            problems.append(f"could not write the finding: {type(e).__name__}: {str(e)[:200]}")
    if problems:
        print(f"NOT ACCEPTED: {len(problems)} problem(s)")
        for x in problems:
            print(" -", x)
        sys.exit(1)
    if args.dry:
        print("no problems (dry run, nothing written)")
        return
    out.mkdir(parents=True, exist_ok=True)
    if path != out / "draft.json":
        (out / "draft.json").write_text(path.read_text())
    (out / "results.json").write_text(json.dumps(results, indent=1))
    for stale in ("finding.md", "card.md", "proposal.json", "refuter_input.md", "refute.json", "refute_results.json"):
        (out / stale).unlink(missing_ok=True)
    shown = "\n".join(f"- [{x['status']}] {c['id']}: {c.get('says')}\n    {json.dumps({k: v for k, v in c.items() if k not in ('id', 'says')})}\n    found: {x['found']}"
                      for c, x in zip(draft["checks"], results))
    if draft["verdict"] == "finding":
        (out / "finding.md").write_text(text)
        (out / "card.md").write_text(card(head, text))
        over = {k: (v["value"] if isinstance(v, dict) else v) for k, v in (draft.get("facts") or {}).items()}
        (out / "refuter_input.md").write_text(
            "# The card, as a reader sees it\n\n" + card(head, text) + "\n# Sentences of What happens\n\n"
            + "\n".join(f"- what-{i}: {s['text']}  (checks: {', '.join(s['checks'])})" for i, s in enumerate(draft["what"], 1))
            + "\n\n# Other parts and their checks\n\n"
            + "\n".join(f"- evidence-{i}: checks {', '.join(b['checks'])}" for i, b in enumerate(draft["evidence"], 1))
            + f"\n- justification: checks {', '.join(draft['justification']['checks'])}"
            + (f"\n- action: checks {', '.join(draft['action']['checks'])}" if draft.get("action") else "")
            + (f"\n- whose ({draft['whose']['value']}): checks {', '.join(draft['whose']['checks'])}" if draft.get("whose") else "")
            + f"\n- pattern {head.get('pattern')}, severity {head.get('severity')}, impact {head.get('impact')}, evidence level {head.get('evidence_level')}"
            + (f"\n- facts the author states beside the tool's: {json.dumps(over)}" if over else "")
            + "\n\n# The author's checks, as run\n\n" + shown + "\n")
        note = f"{head['status']} {head.get('severity')} {head.get('pattern')} as {fid}"
    else:
        (out / "proposal.json").write_text(json.dumps({"verdict": draft["verdict"], "disproof": draft.get("disproof"),
                                                       "questions": draft.get("questions"), "results": results}, indent=1))
        (out / "refuter_input.md").write_text(
            f"# The author proposes: {draft['verdict']}\n\n" + ((draft.get("disproof") or {}).get("text") or "")
            + ("\n\nQuestions:\n" + "\n".join(f"- {q}" for q in draft.get("questions") or []) if draft.get("questions") else "")
            + "\n\n# The author's checks, as run\n\n" + shown + "\n")
        note = draft["verdict"]
    R.advance(args.key, "authored", args.who, "author", draft["verdict"], note)
    print(f"ACCEPTED: {note}")


if __name__ == "__main__":
    main()
