"""File settled rows into the registry: format-2 findings in, the old entries out.

    ... -m review.file --who NAME [--batch 100] [--dry]
    ... -m review.file --rerender KEY [KEY ...]     rewrite only the row folder's finding.md and card.md (a header
                                                   the renderer changed); no check re-run, no state change
    ... -m review.file --link KEY FINDING_ID        a filed card and another finding name each other in `related`
                                                   (two issues on one address under one pattern: the checker asks
                                                   for it); the row's draft keeps the link for a later re-file
Takes settled rows that are not filed since they were last settled, in settle order, up to --batch:
- kept, re-rated, moved or trusted: the card is rendered again from its draft (no check is re-run, the row's state does not
  change), validated, and written to findings/<id>.md;
- removed: nothing new is written.
A row waits when it is not ready: any card but a trusted one needs its refuter's results; a removal whose refuter agreed needs a second
refuter's answer (work/refute1/ holds the first). Questions are never filed.

Then the old entry goes: a triage row's line leaves its triage file; an old finding file is deleted once every row
that came from it is filed (a first-study file shared by several contracts waits for its last row). Then every
`related` entry that names a deleted old finding is pointed at the cards filed from its rows (dropped when none
was), and queue.tsv and ledger.tsv are written. Writes only findings/, triage/, code/ and those two files.
Run tools/build.py afterwards.
"""

import argparse
import json
import re
import sys
from pathlib import Path

import yaml

from . import REGISTRY, WORK, key_dir
from . import rows as R
from . import submit as S

RATED = ("CRITICAL", "HIGH", "MEDIUM", "LOW")


def due(c) -> list[tuple[str, str]]:
    """(key, outcome) of settled rows whose last ledger line is not a filing, oldest settle first.
    One query, read at once: a cursor left open over 30,000 rows held the database's read lock for minutes and stalled every agent's submit."""
    return c.execute("""
        WITH last AS (SELECT key, step, row_number() OVER (PARTITION BY key ORDER BY at DESC, rowid DESC) AS n FROM ledger)
        SELECT r.key, r.outcome FROM rows r JOIN last l ON l.key = r.key AND l.n = 1
        WHERE r.state = 'settled' AND r.outcome IN ('kept', 're-rated', 'moved', 'trusted', 'removed', 'covered', 'unused') AND l.step != 'file'
        ORDER BY r.settled_at""").fetchall()


def ready(key: str, outcome: str, head: dict | None, now: set = frozenset()) -> str | None:
    """Why this row waits, or None."""
    out = WORK / "out" / key_dir(key)
    if outcome == "unused":  # the reader's own settlement under the owner's rule: no agent to wait for
        return None
    if outcome == "covered":  # its card is another row's (sheet settle --by); it goes once that row is filed, this run included
        by = R.db().execute("SELECT reason FROM rows WHERE key = ?", (key,)).fetchone()[0].split(". ", 1)[0].removeprefix("by ")
        return None if by in now or R.db().execute("SELECT 1 FROM ledger WHERE key = ? AND step = 'file'", (by,)).fetchone() else "waits for its covering row"
    if outcome != "trusted" and not any((out / f).exists() for f in ("refute_results.json", "refute-before-edit.json")):
        return "no refuter's results"
    if (outcome == "removed" and not (WORK / "refute1" / key_dir(key) / "refute.json").exists()
            and (out / "refute.json").exists() and json.loads((out / "refute.json").read_text()).get("verdict") == "agree"):
        return "waits for its second refuter"
    return None


def rerender(key: str) -> str:
    out = WORK / "out" / key_dir(key)
    draft, d = json.loads((out / "draft.json").read_text()), S.dossier(key)
    problems, backs = S.shape(draft)
    fid, text, head = S.render(draft, d, backs)
    problems += S.validate(fid, text, d, draft)
    if problems:
        return f"{key}: not rewritten: {'; '.join(problems)[:200]}"
    (out / "finding.md").write_text(text)
    (out / "card.md").write_text(S.card(head, text))
    ri = out / "refuter_input.md"
    if ri.exists() and "# Sentences of What happens" in ri.read_text():
        rest = ri.read_text().split("# Sentences of What happens", 1)[1]
        ri.write_text("# The card, as a reader sees it\n\n" + S.card(head, text) + "\n# Sentences of What happens" + rest)
    return f"{key}: rewritten ({(head.get('value') or {}).get('basis')}: {(head.get('value') or {}).get('usd')})"


def host_code(key: str, head: dict) -> list[str]:
    """A card that links decompiled code needs the file in the registry's code/ (code/README.md)."""
    url = (head.get("contract") or {}).get("code_url") or ""
    if not url.startswith("code/"):
        return []
    dst, src = REGISTRY / url, WORK / "dossier" / key_dir(key) / "decompiled.sol"
    if dst.exists():
        return []
    if not src.exists():
        return [f"{key}: links {url} but its dossier has no decompiled.sol"]
    dst.parent.mkdir(exist_ok=True)
    dst.write_text(src.read_text())
    return []


def drop_from_old(path, address: str) -> list[str]:
    """Take one contract out of an old multi-contract finding (block or flow style), leaving the rest pending."""
    lines = path.read_text().split("\n")
    end = lines.index("---", 1) if "---" in lines[1:] else len(lines)
    at = [i for i in range(1, end) if lines[i].startswith("- ") and f'address: "{address}"' in lines[i]]
    if len(at) != 1:
        return [f"{path.name}: {len(at)} entries for {address} (expected 1); left as it is"]
    i = j = at[0]
    j += 1
    while j < end and lines[j].startswith("  "):
        j += 1
    path.write_text("\n".join(lines[:i] + lines[j:]))
    return []


def relink(c, rows: dict) -> int:
    """Point `related` entries naming a deleted old finding at the cards filed from its rows; files changed."""
    from_old = {}
    for r in rows.values():
        if (r.get("old_path") or "").startswith("findings/"):
            from_old.setdefault(Path(r["old_path"]).stem, []).append(r["key"])
    new = {}
    for old_id, keys in from_old.items():
        if not (REGISTRY / "findings" / f"{old_id}.md").exists():
            done = [c.execute("SELECT detail FROM ledger WHERE key = ? AND step = 'file' ORDER BY at DESC", (k,)).fetchone() for k in keys]
            new[old_id] = [Path(x[0]).stem for x in done if x and x[0] and x[0].startswith("findings/") and x[0] != f"findings/{old_id}.md"]
    for key, detail in c.execute("SELECT DISTINCT key, detail FROM ledger WHERE step = 'file' AND detail LIKE 'findings/%'").fetchall():
        if not (REGISTRY / detail).exists():  # a card filed and later removed or reopened (entries naming it go), or filed again under another name
            last = c.execute("SELECT detail FROM ledger WHERE key = ? AND step = 'file' ORDER BY at DESC, rowid DESC", (key,)).fetchone()
            again = last and last[0] != detail and last[0].startswith("findings/") and (REGISTRY / last[0]).exists()
            new.setdefault(Path(detail).stem, [Path(last[0]).stem] if again else [])
    changed = 0
    for p in sorted((REGISTRY / "findings").glob("*.md")) + sorted((REGISTRY / "triage").glob("*.md")):
        text = p.read_text()
        m = re.search(r"^related: (\[.*\])$", text, re.M)
        rel = yaml.safe_load(m.group(1)) if m else []
        if not any(x in new for x in rel):
            continue
        out = []
        for x in rel:
            out += [y for y in new.get(x, [x]) if y != p.stem and y not in out]
        flat = json.dumps(out) if '"' in m.group(1) else "[" + ", ".join(out) + "]"
        p.write_text(text[:m.start(1)] + flat + text[m.end(1):])
        changed += 1
    return changed


def set_related(fid: str, add: list) -> None:
    """Add ids to a finding's `related` line. Every finding has it on one line, and it stays on one line."""
    p = REGISTRY / "findings" / f"{fid}.md"
    text = p.read_text() if p.exists() else ""
    m = re.search(r"^related: (\[.*\])$", text, re.M)
    if not m:
        return
    rel = yaml.safe_load(m.group(1))
    new = rel + [x for x in add if x not in rel and x != fid]
    if new != rel:
        p.write_text(text[:m.start(1)] + (json.dumps(new) if '"' in m.group(1) else "[" + ", ".join(new) + "]") + text[m.end(1):])


def link(key: str, other: str) -> str:
    got = R.db().execute("SELECT detail FROM ledger WHERE key = ? AND step = 'file' ORDER BY at DESC, rowid DESC", (key,)).fetchone()
    if not got or not (REGISTRY / got[0]).exists() or not (REGISTRY / "findings" / f"{other}.md").exists():
        sys.exit(f"{key} is not filed as a card, or findings/{other}.md does not exist")
    mine, dp = Path(got[0]).stem, WORK / "out" / key_dir(key) / "draft.json"
    draft = json.loads(dp.read_text())
    draft["related"] = sorted(set(draft.get("related") or []) | {other})
    dp.write_text(json.dumps(draft, indent=1))
    set_related(mine, [other])
    set_related(other, [mine])
    return f"{mine} <-> {other}"


def sweep_triage() -> list[str]:
    """Triage entries with nothing left to hold (every row filed or removed) go, as an emptied old finding does."""
    gone = []
    for p in sorted((REGISTRY / "triage").glob("*.md")):
        text = p.read_text()
        end = text.find("\n---\n", 4)
        head = (yaml.safe_load(text[4:end]) or {}) if text.startswith("---\n") and end > 0 else {}
        if "id" in head and not (head.get("contracts") or head.get("families") or head.get("offchain")):
            p.unlink()
            gone.append(p.name)
    return gone


def sweep_code() -> list[str]:
    """Decompiled code that no finding or triage entry links any more (its card was removed) goes."""
    linked = {m for p in list((REGISTRY / "findings").glob("*.md")) + list((REGISTRY / "triage").glob("*.md"))
              for m in re.findall(r"code/(0x[0-9a-f]{64}\.sol)", p.read_text())}
    gone = [p.name for p in (REGISTRY / "code").glob("0x*.sol") if p.name not in linked]
    for name in gone:
        (REGISTRY / "code" / name).unlink()
    return gone


def main():
    if sys.argv[1:2] == ["--rerender"]:
        for k in sys.argv[2:]:
            print(rerender(k))
        return
    if sys.argv[1:2] == ["--link"]:
        print(link(sys.argv[2], sys.argv[3]))
        return
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--batch", type=int, default=100)
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--who", required=True)
    args = ap.parse_args()
    c = R.db()
    rows = R.rows()
    by_old = {}
    for r in rows.values():
        if r.get("old_path"):
            by_old.setdefault(r["old_path"], []).append(r["key"])
    filed, waiting, problems = [], {}, []
    for key, outcome in sorted(due(c), key=lambda ko: ko[1] == "covered"):  # covered rows last: their covering card may be filed in this run
        if len(filed) >= args.batch:
            break
        head = text = None
        if outcome in ("kept", "re-rated", "moved", "trusted"):
            out = WORK / "out" / key_dir(key)
            try:
                draft, d = json.loads((out / "draft.json").read_text()), S.dossier(key)
                shape_problems, backs = S.shape(draft)
                fid, text, head = S.render(draft, d, backs)
                shape_problems += S.validate(fid, text, d, draft)
            except Exception as e:
                problems.append(f"{key}: could not render: {type(e).__name__}: {str(e)[:160]}")
                continue
            if shape_problems:
                problems.append(f"{key}: {'; '.join(shape_problems)[:300]}")
                continue
        why = ready(key, outcome, head, {f[0] for f in filed})
        if why:
            waiting[why] = waiting.get(why, 0) + 1
            continue
        r = rows[key]
        target = REGISTRY / "findings" / f"{head['id']}.md" if head else None
        taken = {f[2] for f in filed if f[2]}

        def other(t: Path) -> bool:
            """The file holds another contract's card, or another row of this run takes it."""
            if t in taken:
                return True
            if not t.exists() or f"findings/{t.name}" == r.get("old_path"):
                return False
            return not re.search(rf"^  address: ['\"]?{r['address']}['\"]?$", t.read_text(), re.M)
        if target and other(target):
            # another contract of the same name whose address starts with the same eight digits (vanity addresses): this card's id
            # takes as many as it needs, as the old registry's did (afeth-00000000fbaa-…)
            for n in (12, 16, 20, 40):
                longer = head["id"].replace(f"-{r['address'][2:10]}-", f"-{r['address'][2:2 + n]}-", 1)
                if not other(REGISTRY / "findings" / f"{longer}.md"):
                    break
            else:
                problems.append(f"{key}: findings/{target.name} exists and belongs to another row")
                continue
            text, head = text.replace(f"id: {head['id']}\n", f"id: {longer}\n", 1), dict(head, id=longer)
            target = REGISTRY / "findings" / f"{longer}.md"
        filed.append((key, outcome, target, text, head, r))
    gone = set()
    filing = {f[0] for f in filed}
    for key, outcome, target, text, head, r in filed:
        old = r.get("old_path")
        what = f"wrote findings/{target.name}" if target else outcome
        if not args.dry:
            if target:
                target.write_text(text)
                (WORK / "out" / key_dir(key) / "finding.md").write_text(text)
                (WORK / "out" / key_dir(key) / "card.md").write_text(S.card(head, text))
                problems += host_code(key, head)
                for other in json.loads((WORK / "out" / key_dir(key) / "draft.json").read_text()).get("related") or []:
                    set_related(head["id"], [other])  # links recorded with --link survive a re-file, both ways
                    set_related(other, [head["id"]])
        # the card this row was filed as before (settled again, or requeued and reviewed again) goes unless this filing rewrote it
        was = c.execute("SELECT detail FROM ledger WHERE key = ? AND step = 'file' AND outcome IN ('kept', 're-rated', 'moved', 'trusted') ORDER BY at DESC, rowid DESC", (key,)).fetchone()
        if was and was[0] != old and (not target or was[0] != f"findings/{target.name}") and (REGISTRY / was[0]).exists():
            if not args.dry:
                (REGISTRY / was[0]).unlink()
            what += f"; deleted its card {was[0]}"
        if r["src"] == "triage" and old and (REGISTRY / old).exists():
            p = REGISTRY / old
            lines = p.read_text().split("\n")
            keep = [x for x in lines if f'address: "{r["address"]}"' not in x]
            if len(keep) != len(lines) - 1:
                problems.append(f"{key}: {old} has {len(lines) - len(keep)} lines for {r['address']} (expected 1); left as it is")
            elif not args.dry:
                p.write_text("\n".join(keep))
            what += f"; its line left {old}"
        elif r["src"] == "finding" and old and (not target or f"findings/{target.name}" != old):
            sharers = by_old.get(old, [key])
            open_rows = [k for k in sharers if k != key and k not in filing and not c.execute(
                "SELECT 1 FROM ledger WHERE key = ? AND step = 'file'", (k,)).fetchone()]
            if open_rows:
                again = c.execute("SELECT 1 FROM ledger WHERE key = ? AND step = 'file'", (key,)).fetchone()
                if not args.dry and not again:  # filed before: its entry already left the old file
                    problems += drop_from_old(REGISTRY / old, r["address"])
                what += f"; left {old}, which stays for its other {len(open_rows)} row(s)"
            elif (REGISTRY / old).exists() and old not in gone:
                gone.add(old)
                if not args.dry:
                    (REGISTRY / old).unlink()
                what += f"; deleted {old}"
        if not args.dry:
            R.log(c, key, args.who, "file", outcome, f"findings/{target.name}" if target else old)
        print(f"{'would file' if args.dry else 'filed'} {key}: {what}")
    if not args.dry and filed:  # the sweeps read the whole registry: only after something changed
        for name in sweep_triage():
            print(f"triage/{name}: no row left; deleted")
        for name in sweep_code():
            print(f"code/{name}: no finding links it; deleted")
        print(f"related lists pointed at the new cards: {relink(c, rows)} file(s)")
        print(R.save())
    print(f"{len(filed)} {'to file' if args.dry else 'filed'}; waiting: {waiting or 'none'}; problems: {len(problems)}")
    for x in problems:
        print(" -", x)


if __name__ == "__main__":
    main()
