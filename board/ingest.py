#!/usr/bin/env python3
"""Copy the reviewed findings of a pq-chain-analysis checkout into SQLite, for the outreach board.

  python3 ingest.py REPO DB [VALUES]             rebuild DB from REPO/findings/ (VALUES: value.py's values.db)
  python3 ingest.py --current REPO DB [VALUES]   exit 0 if DB was built from what REPO holds now, else 1

Only format 2 findings are copied: the cards review has filed (REPO/AGENTS.md). Format 1 files are the bulk
rows review has not reached; each one arrives here when review files its card. The checkout is read with the
registry's own checker, REPO/tools/build.py, so a field means here what it means there, and the problems it reports
are kept per finding. A finding is one card: one contract, what a reader sees, and what the card keeps but never shows
(`admin`, `activity.last`, `primitive`, `checks`, the Reviewer notes), which the board never sends. With VALUES
(value.py's output) a finding also gets what its address holds now, in ETH and every priced token, beside the card's
own figure, and for a card with copies what its whole code family holds.

The new DB is written beside the old one and checked against the files before it replaces it: the same cards, each
with the SHA-256 of its file. A mismatch stops the import and the old DB stays, so DB is always some commit's cards
exactly. The board's own data (data/outreach.db) is never touched here.
"""

from __future__ import annotations

import datetime as dt
import hashlib
import json
import os
import re
import sqlite3
import subprocess
import sys
from contextlib import closing
from pathlib import Path

# Data the outreach board needs and a card lacks. One flag per finding and gap; the page filters by them.
GAPS = {
    "team-unknown": "No project, explorer tag or contract name: nothing says whose it is",
    "value-floor": "value.py never saw the address, or the card has more copies than value.py could single out: a figure is a floor",
    "invalid": "tools/build.py reports problems with this file",
}
GENERIC_CHANGE = "the change"  # a category name's <change> when the study names none (patterns.md, Categories)
DERIVED = ("patterns", "contracts")  # what build.load_finding2 adds to a card's header, for its duplicate check
# What a DB is built from in REPO besides this file and VALUES (see inputs()).
SOURCES = ("findings", "tools", "patterns.md", "studies", "code")
CARD = re.compile(rb"^format:\s*2\s*$", re.M)  # in a header: the file is a card

SCHEMA = """
CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT);
CREATE TABLE pattern (id TEXT PRIMARY KEY, title TEXT, category TEXT, words TEXT);
CREATE TABLE study (id TEXT PRIMARY KEY, title TEXT);
CREATE TABLE finding (                    -- one card (AGENTS.md, format 2): one contract, one root issue
    id TEXT PRIMARY KEY,
    source_sha TEXT NOT NULL,             -- SHA-256 of findings/<id>.md: verify() compares it with the file
    title TEXT NOT NULL,
    level TEXT NOT NULL,                  -- the card's `status`: candidate, confirmed, reproduced, duplicate
    severity TEXT NOT NULL,               -- CRITICAL ... INFORMATIONAL; UNRATED for a candidate without one
    sev_rank INTEGER NOT NULL,            -- position in build.SEVERITY
    justification TEXT,
    category TEXT, category_name TEXT,    -- the pattern's category; the name a card shows, <change> filled in
    pattern TEXT, pattern_words TEXT,     -- PQ-n; its "In words" line, which a card shows instead of the id
    study TEXT,                           -- the study that flagged it
    as_of TEXT, block INTEGER,            -- every state read is at `block`; every figure on the card is as of its date
    address TEXT NOT NULL, name TEXT, project TEXT, label TEXT,
    code TEXT, code_url TEXT,             -- where a reader sees the code: verified, decompiled or bytecode, and the page
    proxy_of TEXT, copies INTEGER, family TEXT,
    upgradeable TEXT,                     -- yes, no, config-only; a card shows yes or no
    value_usd INTEGER, value_whose TEXT, value_basis TEXT,  -- the card's figure: ETH and tools/tokens.json at `block`
    txs_90d INTEGER, impact TEXT, action TEXT, evidence_level TEXT,
    what_happens TEXT, evidence TEXT,     -- the card's sections; Evidence as Markdown bullets
    admin TEXT, last_active TEXT, primitive TEXT,  -- on the card but "not shown": the board never sends them
    who TEXT,                             -- what to call it: project, else explorer tag, else contract name, else address
    held_now REAL, holdings TEXT,         -- value.py: ETH and every priced token now, at the address alone;
    held_at TEXT,                         -- JSON [[symbol, amount, usd], ...] the largest five; the date
    family_held REAL, family_addresses INTEGER,  -- a card with copies: what its whole code family holds now, and its addresses
    deployer TEXT, factory TEXT,          -- who sent the creating transaction; the contract that created it, if not the sender
    studies TEXT, reported TEXT, related TEXT, duplicate_of TEXT,
    gaps TEXT, problems TEXT              -- space-separated GAPS keys; build.py's messages, one per line
);
CREATE INDEX finding_address ON finding(address);
CREATE TABLE finding_text (               -- never sent to the page
    finding_id TEXT PRIMARY KEY,
    notes TEXT,                           -- the Reviewer notes
    header TEXT NOT NULL                  -- the whole YAML header as JSON, `checks` included
);
CREATE TABLE tag (finding_id TEXT NOT NULL, kind TEXT NOT NULL, value TEXT NOT NULL);  -- study, gap
CREATE INDEX tag_kind ON tag(kind, value);
CREATE VIRTUAL TABLE fts USING fts5(text, content='');  -- rowid = finding.rowid
"""


def git(repo: Path, *args: str) -> str:
    return subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True, check=True).stdout.strip()


def text(v):
    """Dates and other YAML scalars as stored text; empty as NULL."""
    return None if v in (None, "", []) else v if isinstance(v, (int, float)) else str(v)


class Values:
    """data/values.db from value.py: what every address behind a finding holds now (ETH and every priced token)."""

    def __init__(self, path: Path):
        self.con = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
        self.meta = dict(self.con.execute("SELECT key, value FROM meta").fetchall())
        self.family = {r[0]: r[1:] for r in self.con.execute("SELECT family, usd, addresses, top FROM family_value")}
        self.deployer = {r[0]: r[1:] for r in self.con.execute("SELECT address, deployer, factory FROM deployer")}
        self.valued = {r[0] for r in self.con.execute("SELECT address FROM valued")}  # absent from address_value = held nothing

    def of(self, address: str, family: str | None, copies: int) -> tuple[float, str | None, float | None, int | None, bool]:
        """What the address holds and its largest five holdings; for a card with copies, what its code family holds
        and the family's addresses; and whether a figure is only a floor (value.py never saw the address, or the card
        has more copies than value.py knows). A card that covers part of its family (Ambire's 1 of 172,118) gets no
        family figure: the other copies are not its."""
        usd, top = self.con.execute("SELECT usd, top FROM address_value WHERE address = ?", (address.lower(),)).fetchone() or (0.0, None)
        whole = self.family.get(family) if family and copies > 1 else None
        whole = whole if whole and whole[1] <= copies else None
        floor = address.lower() not in self.valued or (copies > 1 and (not whole or whole[1] < copies))
        top5 = sorted(([s, round(float(a), 6), round(float(u))] for s, a, u in json.loads(top or "[]")), key=lambda x: -x[2])[:5]
        return usd, json.dumps(top5) if top5 else None, whole[0] if whole else None, whole[1] if whole else None, floor


def row_of(f: dict, body: str, problems: list[str], build, values: Values | None, names: dict[str, str],
           change: dict[str, str], patterns: dict[str, dict]) -> tuple[dict, str | None]:
    """The finding's columns, and its Reviewer notes."""
    c = f["contract"] if isinstance(f.get("contract"), dict) else {}
    v = f["value"] if isinstance(f.get("value"), dict) else {}
    a = f["activity"] if isinstance(f.get("activity"), dict) else {}
    texts = {h: t.strip() for h, t in build.section_texts(body)[1]}
    name = names.get(f.get("category"))
    address = str(c.get("address") or "")
    copies = c["copies"] if isinstance(c.get("copies"), int) else 1
    gaps = [] if c.get("project") or c.get("label") or c.get("name") else ["team-unknown"]
    held = dict.fromkeys(("held_now", "holdings", "held_at", "family_held", "family_addresses", "deployer", "factory"))
    if values and address:
        usd, top, family_usd, family_n, floor = values.of(address, c.get("family"), copies)
        held.update(held_now=usd, holdings=top, held_at=values.meta["at"][:10], family_held=family_usd, family_addresses=family_n)
        held["deployer"], held["factory"] = values.deployer.get(address.lower()) or (None, None)
        if floor:
            gaps.append("value-floor")
    if problems:
        gaps.append("invalid")
    row = {
        "id": f["id"], "title": f["title"], "level": f["status"], "severity": f["severity"],
        "sev_rank": build.SEVERITY.index(f["severity"]), "justification": text(f.get("justification")),
        "category": text(f.get("category")),
        # <change> is the change a study of the card examines: the flagging one, else one in its sources
        "category_name": name.replace("<change>", next((change[s] for s in f["_studies"] if s in change), GENERIC_CHANGE)) if name else None,
        "pattern": text(f.get("pattern")), "pattern_words": patterns.get(f.get("pattern"), {}).get("words") or None,
        "study": text(f.get("study")), "as_of": text(f.get("as_of")), "block": text(f.get("block")),
        "address": address, **{k: text(c.get(k)) for k in ("name", "project", "label", "code", "code_url", "proxy_of")},
        "copies": copies, "family": text(c.get("family")), "upgradeable": text(c.get("upgradeable")),
        "value_usd": text(v.get("usd")), "value_whose": text(v.get("whose")), "value_basis": text(v.get("basis")),
        "txs_90d": text(a.get("txs_90d")), "impact": text(f.get("impact")), "action": text(f.get("action")),
        "evidence_level": text(f.get("evidence_level")),
        "what_happens": texts.get("What happens") or None, "evidence": texts.get("Evidence") or None,
        "admin": text(c.get("admin")), "last_active": text(a.get("last")), "primitive": text(f.get("primitive")),
        "who": c.get("project") or c.get("label") or c.get("name") or address, **held,
        "studies": " ".join(f["_studies"]) or None,
        "reported": min((str(s["date"]) for s in f["sources"] if isinstance(s, dict) and s.get("date")), default=None),
        "related": " ".join(f.get("related") or []) or None, "duplicate_of": text(f.get("duplicate_of")),
        "gaps": " ".join(gaps) or None, "problems": "\n".join(problems) or None,
    }
    return row, texts.get("Reviewer notes") or None


def inputs(repo: Path, values_path: Path | None) -> str:
    """What a DB is built from: the git trees of SOURCES at HEAD (a commit that changes none of them changes nothing
    here), this importer's text, and the values file's modification time."""
    trees = git(repo, "ls-tree", "HEAD", "--", *SOURCES)
    stamp = values_path.stat().st_mtime_ns if values_path and values_path.exists() else None
    return json.dumps([trees, hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), stamp])


def current(repo: Path, db: Path, values_path: Path | None) -> bool:
    """Whether DB was built from what REPO holds now, by this importer, with this values file."""
    try:
        with closing(sqlite3.connect(f"file:{db}?mode=ro", uri=True)) as con:
            built = con.execute("SELECT value FROM meta WHERE key = 'inputs'").fetchone()
    except sqlite3.Error:
        return False
    return bool(built) and built[0] == inputs(repo, values_path)


def cards_on_disk(repo: Path) -> dict[str, str]:
    """Every card in REPO/findings/: its id (the file name) and the SHA-256 of the file."""
    out = {}
    for path in sorted((repo / "findings").glob("*.md")):
        data = path.read_bytes()
        if CARD.search(data.split(b"\n---", 1)[0]):
            out[path.stem] = hashlib.sha256(data).hexdigest()
    return out


def verify(repo: Path, db: Path) -> list[str]:
    """Where DB and the cards in REPO/findings/ differ: cards missing from DB, rows with no card, cards changed since.
    Empty when they agree."""
    disk = cards_on_disk(repo)
    with closing(sqlite3.connect(f"file:{db}?mode=ro", uri=True)) as con:
        rows = dict(con.execute("SELECT id, source_sha FROM finding").fetchall())
    return ([f"missing from the database: findings/{i}.md" for i in sorted(disk.keys() - rows.keys())] +
            [f"in the database but not in findings/: {i}" for i in sorted(rows.keys() - disk.keys())] +
            [f"changed since the import: findings/{i}.md" for i in sorted(disk.keys() & rows.keys()) if disk[i] != rows[i]])


def main(repo: Path, db: Path, values_path: Path | None = None) -> None:
    repo, db = repo.resolve(), db.resolve()
    values = Values(values_path) if values_path and values_path.exists() else None
    sys.path.insert(0, str(repo / "tools"))
    import build

    bodies: dict[Path, str] = {}
    split = build.split

    def keep_body(path, p):
        head, body = split(path, p)
        bodies[path] = body
        return head, body

    build.split = keep_body
    p = build.Problems()
    _, patterns = build.load_patterns(p, repo / "patterns.md")
    studies, findings, _ = build.load_tree(repo, patterns, p)
    cards = [f for f in findings if f.get("format") == 2]
    ids = {f["id"] for f in cards}
    problems: dict[str, list[str]] = {}
    for msg in p:
        key = msg.split(":", 1)[0].split(" ", 1)[0].removesuffix(".md")
        if key in ids:
            problems.setdefault(key, []).append(msg)

    tmp = db.with_name(db.name + ".tmp")
    tmp.unlink(missing_ok=True)
    con = sqlite3.connect(tmp)
    con.executescript(SCHEMA)
    con.executemany("INSERT INTO pattern VALUES (?, ?, ?, ?)",
                    [(k, v["title"], v.get("category"), v.get("words")) for k, v in patterns.items()])
    con.executemany("INSERT INTO study VALUES (?, ?)", [(k, s.get("title")) for k, s in studies.items()])
    names = build.categories(repo / "patterns.md")
    change = {k: f"EIP-{m.group(1)}" for k, s in studies.items() if (m := re.fullmatch(r"eip-(\d+)", str(s.get("topic"))))}
    for f in cards:
        path = repo / "findings" / f"{f['id']}.md"
        r, notes = row_of(f, bodies[path], problems.get(f["id"], []), build, values, names, change, patterns)
        r["source_sha"] = hashlib.sha256(path.read_bytes()).hexdigest()
        rowid = con.execute(f"INSERT INTO finding ({', '.join(r)}) VALUES ({', '.join('?' * len(r))})", list(r.values())).lastrowid
        con.execute("INSERT INTO finding_text VALUES (?, ?, ?)", (f["id"], notes,
                    json.dumps({k: v for k, v in f.items() if not k.startswith("_") and k not in DERIVED}, default=str)))
        tags = {("study", x) for x in f["_studies"]} | {("gap", g) for g in (r["gaps"] or "").split()}
        con.executemany("INSERT INTO tag VALUES (?, ?, ?)", [(f["id"], k, v) for k, v in tags])
        # Search sees what readers see: the card, never the Reviewer notes or the fields it does not show.
        searchable = (f["id"], r["title"], r["justification"], r["action"], r["what_happens"], r["evidence"], r["address"],
                      r["proxy_of"], r["name"], r["label"], r["project"], r["family"])
        con.execute("INSERT INTO fts (rowid, text) VALUES (?, ?)", (rowid, "\n".join(x for x in searchable if x)))
    remote = git(repo, "remote", "get-url", "origin")
    meta = {
        "commit": git(repo, "rev-parse", "HEAD"), "branch": git(repo, "rev-parse", "--abbrev-ref", "HEAD"),
        "committed_at": git(repo, "log", "-1", "--format=%cI"),
        "repo_url": re.sub(r"^git@github\.com:", "https://github.com/", remote).removesuffix(".git"),
        "imported_at": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"), "inputs": inputs(repo, values_path),
        "findings": str(len(cards)), "problems": str(sum(map(len, problems.values()))), "gaps": json.dumps(GAPS),
        "categories": json.dumps({k: v.replace("<change>", GENERIC_CHANGE) for k, v in names.items()}),
    }
    con.executemany("INSERT INTO meta VALUES (?, ?)", meta.items())
    con.commit()
    con.close()
    if wrong := verify(repo, tmp):
        tmp.unlink()
        sys.exit(f"{db.name} not replaced: {len(wrong)} differences with findings/ at {meta['commit'][:7]}\n" + "\n".join(wrong[:20]))
    os.replace(tmp, db)
    print(f"{db.name}: {len(cards)} cards at {meta['commit'][:7]} ({meta['branch']}), {meta['problems']} problems; "
          f"{len(findings) - len(cards)} format 1 files left for review")


if __name__ == "__main__":
    args = sys.argv[1:]
    query = args[:1] == ["--current"]
    args = args[query:]
    if len(args) not in (2, 3):
        sys.exit(__doc__)
    repo_, db_, values_ = Path(args[0]).resolve(), Path(args[1]).resolve(), Path(args[2]) if len(args) == 3 else None
    if query:
        sys.exit(0 if current(repo_, db_, values_) else 1)
    main(repo_, db_, values_)
