#!/usr/bin/env python3
"""The board's check: build a small registry from REPO's filled examples, import it, serve it, and use the API the way
the page does.

  python3 check.py REPO      REPO = the registry (this repository's root); needs PyYAML, like REPO/tools/build.py

Runs in CI on every push and pull request, and on the server before a new commit is deployed. It uses the cards in
REPO/templates/examples/findings/ (tools/build.py keeps them valid), never live findings, so it passes whatever
findings/ holds. Covers: only cards imported (a format 1 file waits for review), the database checked against the files
(a broken card stops the import and the old database stays), login, filters, search (cards and comments), counts, a
card without its Reviewer notes or the fields no page shows, value.py's holdings joined to cards (a whole code family,
a single address, a family it does not know), outreach writes and their log (assignees with an account, a change
someone made meanwhile refused), filters by assignee and comments, what a cross-site form cannot do, outreach records
surviving a re-import and a finding leaving the registry, and the backup.
"""

import base64
import json
import os
import re
import secrets
import shutil
import sqlite3
import subprocess
import sys
import tempfile
import threading
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ED = "etherdelta-8d12a197-order-signature"            # one address, a project, verified code, an admin
FAMILY = "bridge-5427fefa-rotate-signer-before-migrating"  # copies of one code family
FLOOR = "contract-6880f6fd-fixed-gas-recovery"        # made here: two copies of a family value.py does not know, and a
                                                      # `related` id that does not exist
FORMAT1 = """---
id: legacy-format-one
title: A finding in format 1, waiting for review
status: candidate
severity: LOW
patterns: [PQ-1]
contracts:
- address: "0x3333333333333333333333333333333333333333"
sources:
- study: eip-8151-impact
  who: check
  date: 2026-11-20
  by: ai-assisted
  verdict: reported
---

## Summary

Waiting for review.
"""


def git(repo: Path, *args: str) -> None:
    subprocess.run(["git", "-C", str(repo), "-c", "user.name=check", "-c", "user.email=check@localhost", *args],
                   check=True, capture_output=True)


def main(repo: Path) -> None:
    tmp = Path(tempfile.mkdtemp())
    os.environ["BOARD_DATA"] = str(tmp / "data")
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import ingest
    import server
    from http.server import ThreadingHTTPServer

    try:
        small = tmp / "registry"
        for rel in ("tools/build.py", "patterns.md"):
            (small / rel).parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(repo / rel, small / rel)
        for rel in ("studies", "code"):
            shutil.copytree(repo / rel, small / rel)
        shutil.copytree(repo / "templates" / "examples" / "findings", small / "findings")
        floor = small / "findings" / f"{FLOOR}.md"
        text = floor.read_text(encoding="utf-8")
        for old, new in (("copies: 1", "copies: 2"), ("  family:\n", "  family: " + "0" * 32 + "\n"), ("related: []", "related: [no-such-finding]")):
            assert old in text, f"{FLOOR} changed: {old!r} is gone; update check.py"
            text = text.replace(old, new)
        floor.write_text(text, encoding="utf-8")
        (small / "findings" / "legacy-format-one.md").write_text(FORMAT1, encoding="utf-8")
        git(small, "init", "-q", "-b", "main")
        git(small, "remote", "add", "origin", "git@github.com:kevaundray/pq-chain-analysis.git")
        git(small, "add", "-A")
        git(small, "commit", "-q", "-m", "examples")
        db = tmp / "data" / "registry.db"
        db.parent.mkdir()
        ingest.main(small, db)
        n = len(ingest.cards_on_disk(small))
        assert n == 3 and ingest.verify(small, db) == [], "the database holds the cards, and only them"
        server.orphans()  # as sync.sh runs it before the board has ever started: no outreach.db yet

        password, salt = secrets.token_urlsafe(9), secrets.token_bytes(16)
        with server.board() as con:
            con.execute("INSERT INTO user VALUES ('checker', ?, ?)", (salt, server.scrypt(password, salt)))
        httpd = ThreadingHTTPServer(("127.0.0.1", 0), server.Handler)
        threading.Thread(target=httpd.serve_forever, daemon=True).start()
        base = f"http://127.0.0.1:{httpd.server_address[1]}"
        auth = "Basic " + base64.b64encode(f"checker:{password}".encode()).decode()

        def call(path, body=None, ctype="application/json", login=True):
            req = urllib.request.Request(base + path, method="PATCH" if body is not None else "GET",
                                         data=None if body is None else (body if isinstance(body, bytes) else json.dumps(body).encode()))
            if login:
                req.add_header("Authorization", auth)
            if body is not None:
                req.add_header("Content-Type", ctype)
            try:
                with urllib.request.urlopen(req) as r:
                    return r.status, json.loads(r.read()) if path.startswith("/api") else r.headers
            except urllib.error.HTTPError as e:
                return e.code, e.read()

        def ids(query: str) -> list[str]:
            return [r["id"] for r in call(f"/api/findings?level=all&limit=500&{query}")[1]["rows"]]

        def found(q: str) -> list[str]:
            return ids(f"q={urllib.parse.quote(q)}")

        assert call("/api/meta", login=False)[0] == 401
        meta = call("/api/meta")[1]
        assert meta["findings"] == str(n), "a format 1 file is not imported: it waits for review"
        status, page = call("/")
        assert status == 200 and "frame-ancestors 'none'" in page["Content-Security-Policy"]

        live = call("/api/findings?limit=500")[1]
        ranks = [server.SEVERITIES.index(r["severity"]) for r in live["rows"]]
        assert live["total"] == len(live["rows"]) and ranks == sorted(ranks), "default order is by severity"
        assert call("/api/findings?level=all&limit=500")[1]["total"] == n >= live["total"]
        assert found("0x8d12a197") == [ED], "address prefix search"
        assert call("/api/findings?q=%22%20OR%20NEAR(")[0] == 200, "search text is never FTS syntax"
        stats = call("/api/stats")[1]
        assert sum(r["n"] for r in stats["status"]) == live["total"], "every live finding has one status"
        bad = call(f"/api/finding/{FLOOR}")[1]
        assert "invalid" in bad["gaps"] and "related" in bad["problems"], "build.py's problems flag the card"

        card = call(f"/api/finding/{ED}")[1]
        assert (card["project"], card["category_name"], card["code"]) == ("etherdelta", meta["categories"]["quantum-exposure"], "verified")
        assert card["justification"] and card["what_happens"] and card["evidence"].startswith("- ") and card["pattern_words"]
        assert card["sources"] and not {"admin", "last_active", "primitive", "notes", "header", "checks"} & set(card), \
            "nothing the card does not show"
        text = (small / "findings" / f"{ED}.md").read_text(encoding="utf-8")
        shown = " ".join(str(card[k]) for k in ("id", "title", "justification", "action", "what_happens", "evidence", "address",
                                                 "proxy_of", "name", "label", "project", "family")).lower()
        tokens = set(re.findall(r"[a-z0-9]+", shown))
        notes = {w.lower() for w in re.findall(r"[A-Za-z]{8,}", text.split("## Reviewer notes", 1)[1])}
        notes = [w for w in notes if not any(t.startswith(w) for t in tokens)]  # search matches prefixes
        assert ED in found(max(re.findall(r"[A-Za-z]{8,}", card["what_happens"]), key=len)), "search sees the card"
        assert ED not in found(max(notes, key=len)), "never the Reviewer notes"
        admin = re.search(r"admin: ['\"]?(0x[0-9a-f]{40})", text).group(1)
        assert admin not in shown and ED not in found(admin[:12]), "never the admin"

        # value.py's output: one address, a whole code family, and a family it does not know.
        vals = tmp / "data" / "values.db"
        v = sqlite3.connect(vals)
        v.executescript("""CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT);
            CREATE TABLE address_value (address TEXT PRIMARY KEY, usd REAL, usd_eth REAL, tokens INTEGER, top TEXT);
            CREATE TABLE family_value (family TEXT PRIMARY KEY, addresses INTEGER, with_value INTEGER, usd REAL, richest TEXT, richest_usd REAL, top TEXT);
            CREATE TABLE deployer (address TEXT PRIMARY KEY, deployer TEXT, factory TEXT);
            CREATE TABLE valued (address TEXT PRIMARY KEY);
            INSERT INTO meta VALUES ('at', '2026-11-20T12:00:00+00:00');""")
        ed_address = "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
        v.execute("INSERT INTO valued VALUES (?)", (ed_address,))
        v.execute("INSERT INTO address_value VALUES (?, 100, 10, 1, ?)", (ed_address, json.dumps([["ETH", "0.005", "10"], ["DAI", "90", "90"]])))
        v.execute("INSERT INTO deployer VALUES (?, '0x1111111111111111111111111111111111111111', NULL)", (ed_address,))
        family, copies = sqlite3.connect(db).execute("SELECT family, copies FROM finding WHERE id = ?", (FAMILY,)).fetchone()
        v.execute("INSERT INTO family_value VALUES (?, ?, 2, 1234, NULL, 1000, ?)", (family, copies, json.dumps([["USDC", "1234", "1234"]])))
        v.commit()
        assert not ingest.current(small, db, vals), "new values are imported"
        ingest.main(small, db, vals)
        assert ingest.current(small, db, vals) and not ingest.current(small, db, None), "the sync skips only what is built"
        e = call(f"/api/finding/{ED}")[1]
        assert (e["held_now"], e["held_addresses"], e["held_at"]) == (100, 1, "2026-11-20") and "value-floor" not in (e["gaps"] or "")
        assert json.loads(e["holdings"])[0] == ["DAI", 90, 90] and e["deployer"].startswith("0x1111")
        f = call(f"/api/finding/{FAMILY}")[1]
        assert (f["held_now"], f["held_addresses"]) == (1234, copies) and "value-floor" not in (f["gaps"] or ""), "the whole family"
        assert "value-floor" in call(f"/api/finding/{FLOOR}")[1]["gaps"], "copies value.py cannot single out make a floor"
        assert ids("min_value=1000") == [FAMILY]

        assert call("/api/meta")[1]["users"] == ["checker"]
        assert call("/api/outreach", b"ids=" + ED.encode(), ctype="application/x-www-form-urlencoded")[0] == 415
        assert call("/api/outreach", {"ids": [ED], "status": "bogus"})[0] == 400
        assert call("/api/outreach", {"ids": ["no-such-finding"], "status": "contacted"})[0] == 400
        assert call("/api/outreach", {"ids": [ED], "assignee": "someone-else"})[0] == 400, "an assignee needs an account"
        seen = {"status": "not-contacted", "assignee": ""}  # what the page showed
        assert call("/api/outreach", {"ids": [ED], "status": "contacted", "assignee": "checker", "expect": seen})[1] == {"changed": 1}
        assert call("/api/outreach", {"ids": [ED], "status": "fixed", "expect": seen})[0] == 409, "changed since the page read it"
        comment = "mailed security@ about it, thread https://example.org/zebracorn"
        assert call("/api/outreach", {"ids": [ED], "comment": comment})[1] == {"changed": 1}
        assert call("/api/outreach", {"ids": [ED], "status": "contacted"})[1] == {"changed": 0}, "no change, no log line"
        log = call(f"/api/finding/{ED}")[1]["log"]
        assert [(x["field"], x["new"], x["who"]) for x in log] == \
            [("status", "contacted", "checker"), ("assignee", "checker", "checker"), ("comment", comment, "checker")], "oldest first"
        rows = call("/api/findings?status=contacted")[1]["rows"]
        assert [r["id"] for r in rows] == [ED] and (rows[0]["comments"], rows[0]["last_comment"]) == (1, comment)
        assert ids("assignee=checker") == [ED] and ED not in ids(f"assignee={server.UNASSIGNED}") and ids("comments=yes") == [ED]
        assert {r["v"]: r["n"] for r in call("/api/stats")[1]["comments"]} == {"yes": 1, "no": live["total"] - 1}
        assert found("zebracorn") == [ED], "search reads comments too"
        assert call(f"/api/finding/{ED}")[1]["same"]["project"] == 1 and ids("project=etherdelta") == [ED]

        # A card build.py cannot read stops the import: the database stays at the last good commit.
        good = sqlite3.connect(db).execute("SELECT value FROM meta WHERE key = 'commit'").fetchone()[0]
        (small / "findings" / "broken-00000000-card.md").write_text("---\nid: broken-00000000-card\nformat: 2\ntitle: [\n---\n", encoding="utf-8")
        git(small, "add", "-A")
        git(small, "commit", "-q", "-m", "a broken card")
        try:
            ingest.main(small, db)
            raise AssertionError("a card missing from the database must stop the import")
        except SystemExit as stop:
            assert "broken-00000000-card" in str(stop) and not db.with_name(db.name + ".tmp").exists()
        assert sqlite3.connect(db).execute("SELECT value FROM meta WHERE key = 'commit'").fetchone()[0] == good
        git(small, "rm", "-q", "findings/broken-00000000-card.md")
        git(small, "commit", "-q", "-m", "the broken card removed")

        ingest.main(small, db)  # a re-import replaces registry.db and leaves outreach.db alone
        assert call(f"/api/finding/{ED}")[1]["outreach"]["status"] == "contacted"
        git(small, "rm", "-q", f"findings/{ED}.md")
        git(small, "commit", "-q", "-m", "removed")
        assert not ingest.current(small, db, None) and ingest.verify(small, db) == [f"in the database but not in findings/: {ED}"]
        ingest.main(small, db)
        assert ED not in ids("") and call("/api/findings?status=contacted")[1]["total"] == 0 and ingest.verify(small, db) == []
        assert sqlite3.connect(tmp / "data" / "outreach.db").execute("SELECT finding_id FROM outreach").fetchall() == [(ED,)], \
            "a finding that leaves the registry keeps its outreach record"

        server.backup()
        server.backup()  # the next day's copy replaces it
        assert [p.name for p in (tmp / "data" / "backups").iterdir()] == ["outreach.db"]
        assert sqlite3.connect(tmp / "data" / "backups" / "outreach.db").execute("SELECT finding_id FROM outreach").fetchall() == [(ED,)]
        httpd.shutdown()
        print(f"OK: {n} cards imported, checked against their files, served and updated")
    finally:
        shutil.rmtree(tmp)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(Path(sys.argv[1]).resolve())
