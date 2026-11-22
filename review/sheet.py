"""What the final reader reads for each row, and how a row is settled.

    ... -m review.sheet show KEY [KEY ...]                 one sheet per row, to read before settling
    ... -m review.sheet list [--state refuted] [--who NAME]
    ... -m review.sheet settle KEY --as OUTCOME --who NAME [--note TEXT] [--by KEY]
    ... -m review.sheet reopen KEY --who NAME --note TEXT    a row settled in this review and found wrong: its filed card
                                                             leaves the registry, its folder is kept as
                                                             work/out/<row>.reopened-<time>, and it is todo again

Outcomes: kept (a finding of the row's issue), re-rated, moved (another root issue), removed (not affected: needs the
author's disproof, and the refuter's agreement or a note saying how the reader resolved each objection), question
(stays open for the owner, never filed), redo (back to the author with the note), covered (--by: another row of the
same address carries the card; this row is filed with it, like a removal), unused (no agent: a row for one address
that holds nothing and that nothing called in the 90 days before the block; the tool checks the dossier), trusted
(a first-study row whose finding the owner takes as valid: the author's draft is accepted with every check re-run,
and no refuter is sent). Nothing is filed into the registry here.

A card the reader corrected after its refuter answered keeps that answer as refute-before-edit.json and is settled
with --note saying how each objection was resolved; no second refuter is sent.
"""

import argparse
import json
import sys

from . import REGISTRY
from . import rows as R
from .submit import dossier, out_dir

OUTCOMES = ("kept", "re-rated", "moved", "removed", "question", "redo", "covered", "unused", "trusted")


def reopen(key: str, who: str, note: str) -> str:
    c = R.db()
    if c.execute("SELECT state FROM rows WHERE key = ?", (key,)).fetchone() != ("settled",):
        sys.exit(f"{key} is not settled")
    filed = c.execute("SELECT detail FROM ledger WHERE key = ? AND step = 'file' ORDER BY at DESC, rowid DESC", (key,)).fetchone()
    gone = ""
    if filed and filed[0] and filed[0].startswith("findings/") and (REGISTRY / filed[0]).exists():
        (REGISTRY / filed[0]).unlink()
        gone = f"; deleted {filed[0]}"
    out = out_dir(key)
    if out.exists():
        out.rename(out.with_name(f"{out.name}.reopened-{R.now().replace(':', '')}"))
    c.execute("UPDATE rows SET state = 'todo', who = NULL, taken_at = NULL, settled_at = NULL, outcome = NULL, reason = NULL WHERE key = ?", (key,))
    R.log(c, key, who, "reopen", None, note + gone)
    return f"reopened {key}{gone}"


def money(v) -> str:
    v = R.num(v)
    return f"${v / 1e6:.1f}M" if v >= 1e6 else f"${v / 1e3:.0f}k" if v >= 1e3 else f"${v:.0f}"


def leads(d: dict) -> list[str]:
    s, out = d["scan"], []
    for c in s.get("codes") or []:
        out.append(f"scanner ({c['via']}): {c['n_ec']} call(s) to the precompile, {c['ec_like_unknown']} of its shape to an unnamed target, "
                   f"{c['delegatecalls']} delegate-call(s), scan {'complete' if c['complete'] else 'incomplete'}, checks {c['checks']}")
    w = s.get("window")
    if w:
        out.append(f"traces: {w['calls']} recoveries in {w['txs']} txs of the two-week window; the recovered address was the sender in "
                   f"{w['recovered_is_sender']}, the account itself in {w['recovered_is_context']}; {w['distinct_recovered']} distinct")
    for x in d.get("signers") or []:
        out.append(f"recovered signer {x['address']}: {x['code']} at the block" + (f" (delegated to {x['delegated_to']})" if x.get("delegated_to") else "") + f", nonce {x['nonce']}")
    for fam, v in (s.get("families") or {}).items():
        for r in (v.get("replays") or [])[:2]:
            out.append(f"replay {r['tx'][:14]}… ({', '.join(r.get('kinds') or [])}): " + ", ".join(f"{k} {'ok' if x['ok'] else 'FAILS' if x['ok'] is False else '-'}" for k, x in r["runs"].items()))
    return out + d.get("notes", [])


def sheet(key: str) -> str:
    c = R.db()
    state, who = c.execute("SELECT state, who FROM rows WHERE key = ?", (key,)).fetchone()
    d, out = dossier(key), out_dir(key)
    r, f = d["row"], d["facts"]
    L = [f"=== {key}", f"state {state} ({who}) · wave {r['wave']} · from {r['src']} · was {r.get('old_sev')} · {money(r.get('value_usd'))} · {r.get('txs') or 0} txs "
         f"· placed by {r['placed']} · {r['reviewed']} · copies {r.get('copies') or 1}",
         f"tool facts: {f['code_bytes']:,} bytes, {'verified ' + f['name'] if f['verified'] else 'not verified'}, proxy_of {f['proxy_of'] or '-'} ({f['proxy_kind'] or 'none'}), "
         f"upgradeable {f['upgradeable'] or 'empty'}, admin {f['admin'] or '-'}, own value {money(f['value_usd'])}",
         f"OLD CLAIM (untrusted): {r.get('old_note') or ''}"[:700], "LEADS:"] + [f"  - {x}" for x in leads(d)]
    if not (out / "draft.json").exists():
        return "\n".join(L + ["(no draft yet)"])
    draft = json.loads((out / "draft.json").read_text())
    results = {x["id"]: x for x in json.loads((out / "results.json").read_text())} if (out / "results.json").exists() else {}
    L.append(f"--- AUTHOR: {draft['verdict']}")
    if draft["verdict"] == "finding" and (out / "card.md").exists():
        L += [(out / "card.md").read_text().rstrip(), "", "sentences and their checks:"]
        L += [f"  what-{i}: {s['checks']}" for i, s in enumerate(draft["what"], 1)]
        L += [f"mechanism: {draft['mechanism']}", "ruled out: " + " | ".join(draft.get("ruled_out") or [])]
    elif draft.get("disproof"):
        L.append(f"disproof: {draft['disproof']['text']}  {draft['disproof'].get('checks')}")
    if draft.get("questions"):
        L += ["questions:"] + [f"  ? {q}" for q in draft["questions"]]
    L.append("checks:")
    for ck in draft.get("checks") or []:
        res = results.get(ck["id"], {})
        spec = {k: v for k, v in ck.items() if k not in ("id", "says")}
        L.append(f"  [{res.get('status', '?')}] {ck['id']}: {ck.get('says')} :: {json.dumps(spec)[:210]} -> {str(res.get('found'))[:150]}")
    if not (out / "refute.json").exists():
        return "\n".join(L + ["(not refuted yet)"])
    ref = json.loads((out / "refute.json").read_text())
    rres = {x["id"]: x for x in json.loads((out / "refute_results.json").read_text())} if (out / "refute_results.json").exists() else {}
    L.append(f"--- REFUTER: {ref.get('verdict')}")
    for q, a in (ref.get("cold_read") or {}).items():
        L.append(f"  cold read, {q}: {a}")
    for p in ref.get("parts") or []:
        if p.get("holds") is False:
            L.append(f"  PART FAILS {p.get('part')}: {p.get('why')}")
    for k, a in (ref.get("attempts") or {}).items():
        if a.get("result") != "does-not-apply":
            L.append(f"  attempt {k}: {a.get('result')}: {a.get('note')} {a.get('checks') or ''}")
    L += [f"  OBJECTION: {o}" for o in ref.get("objections") or []]
    for ck in ref.get("checks") or []:
        res = rres.get(ck["id"], {})
        L.append(f"  [{res.get('status', '?')}] {ck['id']}: {ck.get('says')} :: {json.dumps({k: v for k, v in ck.items() if k not in ('id', 'says')})[:200]} -> {str(res.get('found'))[:140]}")
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("show")
    s.add_argument("keys", nargs="+")
    ls = sub.add_parser("list")
    ls.add_argument("--state")
    ls.add_argument("--who")
    st = sub.add_parser("settle")
    st.add_argument("key")
    st.add_argument("--as", dest="outcome", required=True, choices=OUTCOMES)
    st.add_argument("--who", required=True)
    st.add_argument("--note", default="")
    st.add_argument("--by", help="covered: the row whose card carries this row's issue")
    ro = sub.add_parser("reopen")
    ro.add_argument("key")
    ro.add_argument("--who", required=True)
    ro.add_argument("--note", required=True)
    args = ap.parse_args()
    if args.cmd == "reopen":
        return print(reopen(args.key, args.who, args.note))
    if args.cmd == "show":
        print("\n\n".join(sheet(k) for k in args.keys))
    elif args.cmd == "list":
        q, params = "SELECT key, state, who, outcome FROM rows WHERE state != 'todo'", []
        for col in ("state", "who"):
            if getattr(args, col):
                q += f" AND {col} = ?"
                params.append(getattr(args, col))
        for line in R.db().execute(q + " ORDER BY ord", params):
            print("\t".join(str(x) for x in line))
    else:
        out = out_dir(args.key)
        if args.outcome == "redo":
            ref = json.loads((out / "refute.json").read_text()) if (out / "refute.json").exists() else {}
            (out / "feedback.md").write_text(
                "# Sent back by the final reader\n\n" + args.note + "\n\n# The refuter's objections\n\n"
                + ("\n".join(f"- {o}" for o in ref.get("objections") or []) or "(none)") + "\n\n# Parts the refuter says do not hold\n\n"
                + ("\n".join(f"- {p['part']}: {p.get('why')}" for p in ref.get("parts") or [] if p.get("holds") is False) or "(none)") + "\n")
            R.advance(args.key, "taken", args.who, "reader", "redo", args.note)
            return print("back to the author")
        if args.outcome == "unused":
            # the owner's rule: an address that held nothing and that nothing called has no finding; no agent is spent on it. Not for a
            # first-study row (its money often sits in another contract: a verifier) nor for a change that breaks the contract by itself
            # (fixed gas, a re-checked signature), which is rated whatever it holds
            d = dossier(args.key)
            calls = ((d.get("use") or {}).get("calls_in_90_days") or {}).get("transactions")
            if args.key.startswith(("first/", "fixed-gas-recovery|", "signature-rechecked|")) or not (
                    d["facts"].get("value_usd") == 0 and not d["row"].get("value_usd") and calls == 0 and (d["row"].get("copies") or 1) == 1):
                sys.exit("unused needs a row for one address that holds nothing (facts.value_usd 0) and that nothing called in the 90 days"
                         " before the block (use.calls_in_90_days.transactions 0), outside the first study, fixed-gas-recovery and"
                         " signature-rechecked; review it instead")
            R.advance(args.key, "settled", args.who, "reader", "unused", args.note or "holds nothing and nothing called it in the 90 days before the block")
            return print("settled as unused")
        if args.outcome == "covered":
            # another row of the same address carries a card for this row's fault: moved to this row's issue by its
            # author, or the same fault under the issue that fits it (the note says why)
            by = out_dir(args.by) / "draft.json" if args.by else None
            issue, address = args.key.split("|")
            if not (by and by.exists() and args.by.split("|")[1] == address and json.loads(by.read_text()).get("verdict") == "finding" and args.note):
                sys.exit("--by must name a row of the same address whose draft is a finding, with --note saying why it covers this row")
            R.advance(args.key, "settled", args.who, "reader", "covered", f"by {args.by}. {args.note}")
            return print("settled as covered")
        if args.outcome == "trusted":
            # the owner's rule for the first study's findings: they are taken as valid; the card is the author's accepted
            # draft, its checks re-run by review.submit, and no refuter is sent
            if not args.key.startswith("first/"):
                sys.exit("trusted is only for first-study rows (first/…)")
            if not ((out / "finding.md").exists() and json.loads((out / "draft.json").read_text()).get("verdict") == "finding" and args.note):
                sys.exit("trusted needs an accepted finding (review.submit printed ACCEPTED) and --note")
            R.advance(args.key, "settled", args.who, "reader", "trusted", args.note)
            return print("settled as trusted")
        answer = next((p for p in (out / "refute.json", out / "refute-before-edit.json") if p.exists()), None)
        if answer is None or (answer.name != "refute.json" and not args.note):
            sys.exit("not refuted yet: a row is settled only after the author, the refuter and your own reading"
                     " (a card you corrected after its refuter answered is settled with --note)")
        draft, ref = json.loads((out / "draft.json").read_text()), json.loads(answer.read_text())
        if args.outcome == "removed" and not (draft["verdict"] == "not-affected" and (ref.get("verdict") == "agree" or args.note)):
            sys.exit("a removal needs the author's disproof, and the refuter's agreement or --note saying how each objection was resolved")
        if args.outcome in ("kept", "re-rated", "moved") and not (draft["verdict"] == "finding" and (out / "finding.md").exists()):
            sys.exit("no accepted finding file for this row")
        if args.outcome in ("kept", "re-rated", "moved") and ref.get("verdict") != "agree" and not args.note:
            sys.exit("the refuter does not agree: settle with --note saying how each objection was resolved, or send it back with --as redo")
        R.advance(args.key, "settled", args.who, "reader", args.outcome, args.note)
        print(f"settled as {args.outcome}")


if __name__ == "__main__":
    main()
