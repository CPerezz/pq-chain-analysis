"""The only way a refuter finishes a row: its answers are checked for completeness and its checks are run.

    ... -m review.refute KEY --who NAME [--dry]
    ... -m review.refute --list                       the attempts a refuter must make, with what each means

Reads work/out/<address>-<issue>/refute.json (see REFUTER.md). It must judge every part of the card, make every
attempt of the list for its case, and state a verdict that fits them. Its checks are run through the gateway like
an author's. Accepted: refute_results.json is written and the row moves to `refuted`.
"""

import argparse
import json
import os
import sys

from . import GATEWAY
from . import rows as R
from .submit import dossier, out_dir, run_checks

# How findings of this study have been wrong so far. A refuter tries each one against the card.
FINDING = {
    "erc1271": "A signer that has code is asked another way (ERC-1271, a code-size branch, a second path), so its signature still counts.",
    "unused-implementation": "The address is implementation code behind proxies or clones and is not used on its own (never initialized).",
    "key-state": "The key the card speaks of is unset, is already a contract, or is not the one the code checks.",
    "setter": "The function the card names (to replace a key, to upgrade, to exit) does not do that, or nobody can call it any more.",
    "path-closed": "The signed path is closed for good (no function and no live key can open it again: a sale that ended, a registry that disabled it, a pause nobody can lift), so nothing can break.",
    "direct-path": "The same act is possible by a direct call without a signature (or, where the card says a direct call exists, it does not).",
    "rechecked-later": "Another party already holds the signature and acted on it, and the contract checks it later on chain (a voucher, a channel state), while the signer cannot take that back without migrating; then this is not a notice but a rated finding (PQ-15).",
    "taken-back": "For a rated signature finding (PQ-15): the signer can already take back what the other party relies on without migrating (a timeout passed, a cancel or a withdrawal it alone signs), so migrating adds nothing and this is a notice.",
    "wrong-code": "The card describes other code than what runs at this address (a template match, another implementation, a library).",
    "value-whose": "What the address holds is not whose the card says, or the amount is counted across copies or is another figure.",
    "children": "The code that matters is in contracts this one deploys, or in a contract it calls, not here.",
    "gas": "For a gas finding: the amount is not a constant below the new price, the call is not to the precompile, or its failure is handled.",
    "breaks-by-itself": "For a notice: something here fails under the change with nobody migrating (a replay under EIP-8151 alone fails, or a fixed or tight gas amount); then a rated finding is missing or this is the wrong root issue.",
}
# How removals have been wrong so far. A refuter tries each one against the disproof.
REMOVAL = {
    "recoveries-seen": "Real recoveries by this address are in the dossier's traces (scan.window, scan.recovered) or replays.",
    "unnamed-call": "The code has a call of the recovery's shape whose target the scanner could not name, or a delegate-call (scan.codes).",
    "other-contract": "Another contract checks the signature on this one's behalf, so this one still depends on it.",
    "proxies": "Proxies or clones run this code with their own state, so the code is in use even if this address is not.",
    "disproof-read": "The read that decides the disproof does not say what the author says, or it is not at the pinned block.",
    "reopened": "What the author calls closed or unset can be opened or set again by someone, and then the finding applies.",
}
RESULTS = ("does-not-apply", "tried-holds", "refutes", "could-not-check")
COLD = ("what_is_wrong", "how_bad", "whose_money", "what_can_the_team_do")


def card_parts(draft: dict) -> list[str]:
    if draft["verdict"] != "finding":
        return ["disproof"] if draft["verdict"] == "not-affected" else []
    return ([f"what-{i}" for i in range(1, len(draft["what"]) + 1)] + [f"evidence-{i}" for i in range(1, len(draft["evidence"]) + 1)]
            + ["title", "justification", "severity", "pattern"] + (["action"] if draft.get("action") else []) + (["whose"] if draft.get("whose") else [])
            + (["facts"] if draft.get("facts") else []))


def problems_of(ref: dict, draft: dict, table_clear: bool = False) -> list[str]:
    out = []
    finding = draft["verdict"] == "finding"
    if draft["verdict"] == "question":
        return [] if ref.get("verdict") in ("agree", "disagree", "unsure") else ["verdict: agree, disagree or unsure"]
    if finding:
        cold = ref.get("cold_read") or {}
        for k in COLD:
            if not isinstance(cold.get(k), str) or len(cold[k]) < 15:
                out.append(f"cold_read.{k}: your answer from the card alone, before you opened anything else")
    parts = {p.get("part"): p for p in ref.get("parts") or [] if isinstance(p, dict)}
    for part in card_parts(draft):
        p = parts.get(part)
        if p is None or not isinstance(p.get("holds"), bool) or not isinstance(p.get("why"), str) or len(p["why"]) < 15:
            out.append(f"parts: judge {part} with {{\"part\": \"{part}\", \"holds\": true or false, \"why\": what you read that says so}}")
    wanted = FINDING if finding else REMOVAL
    attempts = ref.get("attempts") if isinstance(ref.get("attempts"), dict) else {}
    for k in wanted:
        a = attempts.get(k)
        if not isinstance(a, dict) or a.get("result") not in RESULTS or not isinstance(a.get("note"), str) or len(a["note"]) < 15:
            out.append(f"attempts.{k}: {{\"result\": one of {list(RESULTS)}, \"note\": what you did and saw}}")
        elif a["result"] == "tried-holds" and not a.get("checks") and not (k == "proxies" and table_clear):
            out.append(f"attempts.{k}: you tried it, so name the check (in `checks`) that shows the card holds"
                       + (" (or, for proxies, the dossier's scan.implementation_of when it is empty)" if k == "proxies" else ""))
    ids = {c.get("id") for c in ref.get("checks") or [] if isinstance(c, dict)}
    for where, used in [(f"attempts.{k}", (a or {}).get("checks") or []) for k, a in attempts.items() if isinstance(a, dict)] + \
                       [(f"parts {p.get('part')}", p.get("checks") or []) for p in parts.values()]:
        for i in used:
            if i not in ids:
                out.append(f"{where} names check {i!r}, which is not in your `checks`")
    refuted = [k for k, a in attempts.items() if isinstance(a, dict) and a.get("result") == "refutes"] + [k for k, p in parts.items() if p.get("holds") is False]
    unknown = [k for k, a in attempts.items() if isinstance(a, dict) and a.get("result") == "could-not-check"]
    v = ref.get("verdict")
    if v not in ("agree", "disagree", "unsure"):
        out.append("verdict: agree, disagree or unsure")
    elif refuted and v == "agree":
        out.append(f"verdict agree, but you refute {refuted}: disagree, or say why each no longer stands")
    elif unknown and v == "agree":
        out.append(f"verdict agree, but you could not check {unknown}: unsure, with what is needed to check them")
    elif v != "agree" and not ref.get("objections"):
        out.append("objections: one line per thing that is wrong or open, each naming the part of the card")
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("key", nargs="?")
    ap.add_argument("--who", default=os.environ.get("REVIEW_WHO", "refuter"))
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--list", action="store_true")
    args = ap.parse_args()
    if args.list:
        for title, d in (("Against a finding", FINDING), ("Against a removal (verdict not-affected)", REMOVAL)):
            print(title + ":")
            for k, v in d.items():
                print(f"  {k}: {v}")
        return
    os.environ["ETH_RPC_URL"] = f"{GATEWAY}/{args.who}"
    out = out_dir(args.key)
    if not (out / "draft.json").exists() or not ((out / "finding.md").exists() or (out / "proposal.json").exists()):
        sys.exit(f"{args.key} has no accepted draft to refute")
    try:
        ref = json.loads((out / "refute.json").read_text())
    except FileNotFoundError:
        sys.exit(f"no refute.json in {out}")
    except json.JSONDecodeError as e:
        sys.exit(f"refute.json is not valid JSON: {e}")
    draft = json.loads((out / "draft.json").read_text())
    d = dossier(args.key)
    problems = problems_of(ref, draft, table_clear=not (d.get("scan") or {}).get("implementation_of"))
    more, results = run_checks({"checks": ref.get("checks") or []}, d)
    problems += more
    if problems:
        print(f"NOT ACCEPTED: {len(problems)} problem(s)")
        for x in problems:
            print(" -", x)
        sys.exit(1)
    if args.dry:
        print("no problems (dry run, nothing written)")
        return
    (out / "refute_results.json").write_text(json.dumps(results, indent=1))
    R.advance(args.key, "refuted", args.who, "refuter", ref["verdict"], "; ".join(ref.get("objections") or [])[:500])
    print(f"ACCEPTED: {ref['verdict']}")


if __name__ == "__main__":
    main()
