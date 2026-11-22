"""The queue: the open rows, who holds which, and every step taken on them.

    ... -m review.rows status                          counts by old rating and state, and who holds what
    ... -m review.rows take --who NAME [--n 5] [--wave N]   claim the next rows: CRITICAL first, then HIGH, MEDIUM, LOW
    ... -m review.rows take --who NAME --keys KEY,KEY  claim these rows
    ... -m review.rows release KEY --who NAME          give back a claimed row that has no draft yet
    ... -m review.rows requeue KEY[,KEY] --who NAME --note TEXT   a settled row back to todo for a full review; its
                                                       filed card stays until the review files the row again
    ... -m review.rows show KEY                        the row (its old claim), its state and its steps
    ... -m review.rows add KEY --note TEXT [--from KEY] a row found in review: a copy in use, or another issue of an address
    ... -m review.rows save                            write queue.tsv and ledger.tsv (run before every commit)

A row is one contract under one root issue; its key is <issue>|<address> (for a first-study row, first/<finding id>).
The rows are in data/rows.jsonl.gz (the open rows when the review was handed over) and added.jsonl (rows added since).
The working database is work/state.db. It is built from those files, queue.tsv and ledger.tsv when it is missing, so
that a fresh clone continues where the last commit left off: commit queue.tsv and ledger.tsv with every filing.
A claim runs in one database transaction, so a row is never handed to two reviewers.
"""

import argparse
import gzip
import json
import re
import shutil
import sqlite3
import sys
from datetime import datetime, timezone

from . import DATA, HERE, ISSUES, WORK, key_dir

STATES = ("todo", "taken", "authored", "refuted", "settled")
RANK = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3}
SCHEMA = """CREATE TABLE IF NOT EXISTS rows (key TEXT PRIMARY KEY, src TEXT, issue TEXT, address TEXT, wave INT, ord INT,
    state TEXT DEFAULT 'todo', who TEXT, taken_at TEXT, settled_at TEXT, outcome TEXT, reason TEXT, rank INT);
CREATE TABLE IF NOT EXISTS ledger (key TEXT, at TEXT, who TEXT, step TEXT, outcome TEXT, detail TEXT);
CREATE INDEX IF NOT EXISTS ledger_key ON ledger (key);"""
QUEUE, LEDGER, ADDED, HELD = HERE / "queue.tsv", HERE / "ledger.tsv", HERE / "added.jsonl", HERE / "held"
_ROWS: dict = {}


def now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def num(v) -> float:
    try:
        return float(v or 0)
    except (TypeError, ValueError):
        return 0.0


def rows() -> dict[str, dict]:
    """Every row's data (its old claim, untrusted), by key."""
    if not _ROWS:
        with gzip.open(DATA / "rows.jsonl.gz", "rt") as f:
            _ROWS.update((r["key"], r) for r in map(json.loads, f))
        if ADDED.exists():
            _ROWS.update((r["key"], r) for r in map(json.loads, filter(str.strip, ADDED.read_text().splitlines())))
    return _ROWS


def row(key: str) -> dict:
    r = rows().get(key)
    if r is None:
        sys.exit(f"no row {key}")
    return r


def flat(v) -> str:
    return re.sub(r"[\t\r\n]+", " ", str(v)) if v is not None else ""


def load(c: sqlite3.Connection) -> None:
    """A new database: every row as todo, then the state and the steps of the last commit."""
    c.execute("BEGIN IMMEDIATE")
    c.executemany("INSERT INTO rows (key, src, issue, address, wave, ord, rank) VALUES (?, ?, ?, ?, ?, ?, ?)",
                  [(r["key"], r["src"], r["issue"], r["address"], r["wave"], r["ord"], RANK.get(r.get("old_sev"), 4)) for r in rows().values()])
    if HELD.exists():  # rows settled and not yet filed (a CRITICAL or HIGH card waiting for sign-off): their work comes back
        for folder in HELD.iterdir():
            for sub in ("out", "refute1"):
                if (folder / sub).exists() and not (WORK / sub / folder.name).exists():
                    shutil.copytree(folder / sub, WORK / sub / folder.name)
    if QUEUE.exists():
        lines = QUEUE.read_text().splitlines()[1:]
        for key, wave, ord_, state, who, outcome, settled_at, reason in (x.split("\t") for x in lines if x):
            if state in ("taken", "authored", "refuted") and not (WORK / "out" / key_dir(key) / "draft.json").exists():
                state, who = "todo", ""  # its agents' work is not in this clone: the row starts again
            c.execute("UPDATE rows SET wave = ?, ord = ?, state = ?, who = ?, outcome = ?, settled_at = ?, reason = ? WHERE key = ?",
                      (int(wave), int(ord_), state, who or None, outcome or None, settled_at or None, reason or None, key))
    if LEDGER.exists():
        c.executemany("INSERT INTO ledger VALUES (?, ?, ?, ?, ?, ?)",
                      [(k, at, who, step, outcome or None, detail or None) for at, k, who, step, outcome, detail in
                       (x.split("\t") for x in LEDGER.read_text().splitlines()[1:] if x)])
    c.execute("COMMIT")


def db() -> sqlite3.Connection:
    WORK.mkdir(parents=True, exist_ok=True)
    new = not (WORK / "state.db").exists()
    c = sqlite3.connect(WORK / "state.db", timeout=60, isolation_level=None)
    c.executescript(SCHEMA)
    if new:
        load(c)
    return c


def save() -> str:
    """queue.tsv, ledger.tsv, and in held/ the files a settled row needs to be filed from another clone."""
    c = db()
    with open(QUEUE, "w") as f:
        f.write("key\twave\tord\tstate\twho\toutcome\tsettled_at\treason\n")
        for r in c.execute("SELECT key, wave, ord, state, who, outcome, settled_at, reason FROM rows WHERE state != 'todo' ORDER BY ord"):
            f.write("\t".join(flat(x) for x in r) + "\n")
    with open(LEDGER, "w") as f:
        f.write("at\tkey\twho\tstep\toutcome\tdetail\n")
        for r in c.execute("SELECT at, key, who, step, outcome, detail FROM ledger ORDER BY at, rowid"):
            f.write("\t".join(flat(x) for x in r) + "\n")
    shutil.rmtree(HELD, ignore_errors=True)
    waiting = [k for (k,) in c.execute("""
        WITH last AS (SELECT key, step, row_number() OVER (PARTITION BY key ORDER BY at DESC, rowid DESC) AS n FROM ledger)
        SELECT r.key FROM rows r JOIN last l ON l.key = r.key AND l.n = 1 WHERE r.state = 'settled' AND l.step != 'file'""")]
    for k in waiting:
        for sub in ("out", "refute1"):
            src = WORK / sub / key_dir(k)
            if src.exists():
                shutil.copytree(src, HELD / key_dir(k) / sub, ignore=shutil.ignore_patterns("*.reopened-*"))
    return f"wrote {QUEUE.name} and {LEDGER.name}; {len(waiting)} settled row(s) not filed yet kept in {HELD.name}/"


def log(c: sqlite3.Connection, key: str, who: str, step: str, outcome: str | None = None, detail: str | None = None) -> None:
    c.execute("INSERT INTO ledger VALUES (?, ?, ?, ?, ?, ?)", (key, now(), who, step, outcome, detail))


def advance(key: str, state: str, who: str, step: str, outcome: str | None = None, detail: str | None = None) -> None:
    """Move a row forward and write its step. Called by the submit, refute and sheet tools."""
    c = db()
    c.execute("BEGIN IMMEDIATE")
    c.execute("UPDATE rows SET state = ?, outcome = COALESCE(?, outcome), reason = COALESCE(?, reason), settled_at = ? WHERE key = ?",
              (state, outcome if state == "settled" else None, detail if state == "settled" else None, now() if state == "settled" else None, key))
    log(c, key, who, step, outcome, detail)
    c.execute("COMMIT")


def cmd_status(_):
    c = db()
    names = {v: k for k, v in RANK.items()} | {4: "other"}
    print("old rating  " + "  ".join(f"{s:>8}" for s in STATES))
    for (rk,) in c.execute("SELECT DISTINCT rank FROM rows ORDER BY rank"):
        n = dict(c.execute("SELECT state, count(*) FROM rows WHERE rank = ? GROUP BY state", (rk,)).fetchall())
        print(f"{names[rk]:>10}  " + "  ".join(f"{n.get(s, 0):>8,}" for s in STATES))
    for who, state, n in c.execute("SELECT who, state, count(*) FROM rows WHERE who IS NOT NULL AND state != 'settled' GROUP BY 1, 2 ORDER BY 1, 2"):
        print(f"  {who}: {n:,} {state}")
    for outcome, n in c.execute("SELECT outcome, count(*) FROM rows WHERE state = 'settled' GROUP BY 1 ORDER BY 2 DESC"):
        print(f"  settled as {outcome}: {n:,}")


def cmd_take(args):
    c = db()
    c.execute("BEGIN IMMEDIATE")
    if args.keys:
        keys = [k for k in args.keys.split(",") if c.execute("SELECT 1 FROM rows WHERE key = ? AND state = 'todo'", (k,)).fetchone()]
    else:
        q = "SELECT key FROM rows WHERE state = 'todo'" + (" AND wave = ?" if args.wave else "") + " ORDER BY rank, ord LIMIT ?"
        keys = [k for (k,) in c.execute(q, ((args.wave,) if args.wave else ()) + (args.n,))]
    for k in keys:
        c.execute("UPDATE rows SET state = 'taken', who = ?, taken_at = ? WHERE key = ?", (args.who, now(), k))
        log(c, k, args.who, "take")
    c.execute("COMMIT")
    print("\n".join(keys))


def cmd_release(args):
    if (WORK / "out" / key_dir(args.key) / "draft.json").exists():
        sys.exit("it has a draft: settle it, or send it back with sheet settle --as redo")
    c = db()
    c.execute("UPDATE rows SET state = 'todo', who = NULL, taken_at = NULL WHERE key = ? AND state = 'taken'", (args.key,))
    log(c, args.key, args.who, "release")
    print(f"released {args.key}")

def cmd_requeue(args):
    c = db()
    for key in args.keys.split(","):
        n = c.execute("UPDATE rows SET state = 'todo', who = NULL, taken_at = NULL, outcome = NULL, reason = NULL, settled_at = NULL"
                      " WHERE key = ? AND state = 'settled'", (key,)).rowcount
        if not n:
            sys.exit(f"{key} is not a settled row")
        log(c, key, args.who, "requeue", None, args.note[:500])
        print(f"requeued {key}")



def cmd_show(args):
    print(json.dumps(row(args.key), indent=1))
    c = db()
    print(c.execute("SELECT state, who, taken_at, outcome, reason FROM rows WHERE key = ?", (args.key,)).fetchone())
    for line in c.execute("SELECT at, who, step, outcome, detail FROM ledger WHERE key = ? ORDER BY at", (args.key,)):
        print("  ", line)


def cmd_add(args):
    """A row found in review: a copy of a row's code in use at another address, or another issue of an address."""
    issue, address = args.key.split("|")
    if not (issue in ISSUES or issue.startswith("first/")) or not re.fullmatch(r"0x[0-9a-f]{40}", address):
        sys.exit("KEY is <root issue>|<lowercase address>, with a root issue of review/__init__.py ISSUES or first/<finding id>")
    c = db()
    if c.execute("SELECT 1 FROM rows WHERE key = ?", (args.key,)).fetchone():
        sys.exit(f"{args.key} is already a row")
    parent = row(args.src) if args.src else {}
    copy = issue == parent.get("issue")  # a copy keeps its parent's study and finders; a new issue is the EIP-8151 study's
    last = c.execute("SELECT COALESCE(MAX(ord), 0) FROM rows").fetchone()[0]
    r = {"key": args.key, "src": "review", "issue": issue, "pattern": ISSUES.get(issue) or parent.get("pattern"), "address": address,
         "study": (parent.get("study") if copy else None) or "eip-8151-impact", "family": parent.get("family") if copy else None,
         "copies": 1, "old_sev": parent.get("old_sev"), "sources": parent.get("sources") if copy else None, "old_note": f"Added in review: {args.note}",
         "wave": parent.get("wave") or 1, "ord": last + 1}
    c.execute("INSERT INTO rows (key, src, issue, address, wave, ord, rank) VALUES (?, ?, ?, ?, ?, ?, ?)",
              (args.key, "review", issue, address, r["wave"], last + 1, RANK.get(r["old_sev"], 4)))
    log(c, args.key, args.who, "add", None, args.note[:500])
    with open(ADDED, "a") as f:
        f.write(json.dumps(r) + "\n")
    _ROWS.clear()
    print(f"added {args.key}")


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("status")
    t = sub.add_parser("take")
    t.add_argument("--who", required=True)
    t.add_argument("--n", type=int, default=5)
    t.add_argument("--wave", type=int)
    t.add_argument("--keys")
    r = sub.add_parser("release")
    r.add_argument("key")
    r.add_argument("--who", required=True)
    q = sub.add_parser("requeue")
    q.add_argument("keys")
    q.add_argument("--who", required=True)
    q.add_argument("--note", required=True)
    s = sub.add_parser("show")
    s.add_argument("key")
    a = sub.add_parser("add")
    a.add_argument("key")
    a.add_argument("--note", required=True)
    a.add_argument("--from", dest="src")
    a.add_argument("--who", default="reader")
    sub.add_parser("save")
    args = ap.parse_args()
    if args.cmd == "save":
        return print(save())
    {"status": cmd_status, "take": cmd_take, "release": cmd_release, "requeue": cmd_requeue, "show": cmd_show, "add": cmd_add}[args.cmd](args)


if __name__ == "__main__":
    main()
