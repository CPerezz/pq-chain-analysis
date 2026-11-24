#!/usr/bin/env python3
"""The outreach board: browse the registry's findings and record outreach on each one.

  python3 server.py serve [PORT]       serve web/ and the API on 127.0.0.1 (default 8090); a tunnel goes in front
  python3 server.py user NAME          add a user, or give one a new password (printed once)
  python3 server.py user NAME --delete
  python3 server.py backup             copy outreach.db to data/backups/outreach.db, over the last copy (run daily)
  python3 server.py orphans            outreach records whose finding is no longer in registry.db (kept, not shown)

BOARD_DATA (default: data/ beside this file) holds the databases. registry.db is the registry, rebuilt by ingest.py
and only read here. outreach.db belongs to the board: each finding's outreach status and assignee, the log of every
change and comment, and the users. Every request needs HTTP Basic auth; writes need a JSON body, which a cross-site
form cannot send. Restart after changing a password or deleting a user: verified logins are cached.
"""

from __future__ import annotations

import base64
import datetime as dt
import functools
import hashlib
import hmac
import json
import os
import re
import secrets
import sqlite3
import sys
import traceback
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

HERE = Path(__file__).resolve().parent
DATA = Path(os.environ.get("BOARD_DATA", HERE / "data"))
REGISTRY, BOARD = DATA / "registry.db", DATA / "outreach.db"
STATIC = {"/": ("index.html", "text/html"), "/app.js": ("app.js", "text/javascript"), "/app.css": ("app.css", "text/css")}

# The outreach statuses of a finding, and what each means.
STATUS_HELP = {
    "not-contacted": "Nobody has written to the team yet.",
    "contacted": "A message was sent; no reply yet.",
    "acknowledged": "The team replied and accepts the issue.",
    "fix-planned": "The team named a fix and a date.",
    "fixed": "The fix is live; say in a comment how that was checked.",
    "unresponsive": "No reply after repeated attempts.",
    "declined": "The team disputes the issue or will not fix it; say why in a comment.",
}
STATUSES = tuple(STATUS_HELP)
SEVERITIES = ("CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "NONE", "UNRATED")  # build.SEVERITY's order
LIVE = ("reproduced", "confirmed", "candidate")
ID = re.compile(r"^[a-z0-9][a-z0-9-]*$")
USER = re.compile(r"^[A-Za-z0-9._-]{2,40}$")
UNASSIGNED = "-"  # the assignee filter's value for nobody: no user name is one character long
STATUS_RANK = "CASE COALESCE(o.status, 'not-contacted') " + " ".join(f"WHEN '{s}' THEN {i}" for i, s in enumerate(STATUSES)) + " END"
# Every finding with its outreach record, its number of comments (c.n) and its last comment (lc).
FROM = ("finding f LEFT JOIN b.outreach o ON o.finding_id = f.id "
        "LEFT JOIN (SELECT finding_id, COUNT(*) AS n, MAX(id) AS last FROM b.log WHERE field = 'comment' GROUP BY finding_id) c "
        "ON c.finding_id = f.id LEFT JOIN b.log lc ON lc.id = c.last")
COLUMNS = {"severity": "f.severity", "level": "f.level", "category": "f.category", "pattern": "f.pattern", "impact": "f.impact",
           "upgradeable": "f.upgradeable", "status": "COALESCE(o.status, 'not-contacted')",
           "assignee": f"COALESCE(o.assignee, '{UNASSIGNED}')", "comments": "CASE WHEN c.n THEN 'yes' ELSE 'no' END"}
EXACT = {"project": "f.project", "deployer": "f.deployer"}  # one value, no counts: a team's or a deployer's findings
TAGS = ("study", "gap")
SORTS = {
    "severity": "f.sev_rank {d}, f.held_now DESC NULLS LAST, f.id",
    "value": "f.held_now {d} NULLS LAST, f.sev_rank, f.id",
    "registry": "f.value_usd {d} NULLS LAST, f.sev_rank, f.id",
    "txs": "f.txs_90d {d} NULLS LAST, f.sev_rank, f.id",
    "who": "f.who {d} NULLS LAST, f.id",
    "title": "f.title {d}, f.id",
    "status": STATUS_RANK + " {d}, f.sev_rank, f.id",
    "assignee": "o.assignee {d} NULLS LAST, f.sev_rank, f.id",
    "comments": "COALESCE(c.n, 0) {d}, f.sev_rank, f.id",
    "updated": "o.updated_at {d} NULLS LAST, f.sev_rank, f.id",
}
LIST = ("f.id, f.title, f.severity, f.level, f.category, f.category_name, f.pattern, f.justification, f.who, f.project, "
        "f.label, f.name, f.address, f.copies, f.upgradeable, f.impact, f.value_usd, f.value_basis, f.held_now, f.holdings, "
        "f.held_at, f.family_held, f.family_addresses, f.txs_90d, f.gaps, "
        "COALESCE(o.status, 'not-contacted') AS status, o.assignee, o.updated_at, o.updated_by, "
        "COALESCE(c.n, 0) AS comments, lc.new AS last_comment, lc.who AS last_comment_by, lc.at AS last_comment_at")
# What the page may show of a finding: the card without the fields AGENTS.md marks "not shown" (admin,
# activity.last, primitive, checks) and without the Reviewer notes, plus what the board adds.
SHOWN = ("id, title, level, severity, justification, category, category_name, pattern, pattern_words, study, as_of, block, "
         "address, name, project, label, code, code_url, proxy_of, copies, family, upgradeable, value_usd, value_whose, "
         "value_basis, txs_90d, impact, action, evidence_level, what_happens, evidence, who, held_now, holdings, "
         "held_at, family_held, family_addresses, deployer, factory, studies, reported, related, duplicate_of, gaps, problems")
BOARD_SCHEMA = """
CREATE TABLE IF NOT EXISTS outreach (
    finding_id TEXT PRIMARY KEY, status TEXT NOT NULL, assignee TEXT, updated_by TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS log (  -- every change and comment; rows are never edited
    id INTEGER PRIMARY KEY, finding_id TEXT NOT NULL, at TEXT NOT NULL, who TEXT NOT NULL,
    field TEXT NOT NULL, old TEXT, new TEXT);  -- field: status, assignee or comment
CREATE INDEX IF NOT EXISTS log_finding ON log(finding_id, id);
CREATE TABLE IF NOT EXISTS user (name TEXT PRIMARY KEY, salt BLOB NOT NULL, hash BLOB NOT NULL);
"""
HEADERS = {
    "Content-Security-Policy": "default-src 'self'; img-src 'self' data:; frame-ancestors 'none'; base-uri 'none'; form-action 'none'",
    "X-Content-Type-Options": "nosniff", "Referrer-Policy": "no-referrer", "Cache-Control": "no-store",
}


class BadRequest(Exception):
    pass


class Conflict(Exception):
    """Someone changed the finding after the page read it."""


def board() -> sqlite3.Connection:
    DATA.mkdir(parents=True, exist_ok=True)
    con = sqlite3.connect(BOARD, timeout=10)
    con.execute("PRAGMA journal_mode=WAL")
    con.executescript(BOARD_SCHEMA)
    return con


def connect() -> sqlite3.Connection:
    con = sqlite3.connect(f"file:{REGISTRY}?mode=ro", uri=True, timeout=10)
    con.execute("ATTACH ? AS b", (str(BOARD),))
    con.row_factory = sqlite3.Row
    return con


def scrypt(password: str, salt: bytes) -> bytes:
    return hashlib.scrypt(password.encode(), salt=salt, n=2 ** 14, r=8, p=1)


@functools.lru_cache(maxsize=64)
def login(authorization: str) -> str | None:
    """The user name for an `Authorization: Basic` header, or None."""
    try:
        name, _, password = base64.b64decode(authorization.removeprefix("Basic "), validate=True).decode().partition(":")
    except ValueError:
        return None
    with sqlite3.connect(BOARD) as con:
        row = con.execute("SELECT salt, hash FROM user WHERE name = ?", (name,)).fetchone()
    return name if row and hmac.compare_digest(scrypt(password, row[0]), row[1]) else None


# ---- queries -----------------------------------------------------------------------------------------------------

def values(qs, key) -> list[str]:
    return [v for v in ",".join(qs.get(key, [])).split(",") if v]


def search(q: str) -> tuple[str, list] | None:
    """Findings whose card has every word (each a quoted FTS prefix term, so never FTS syntax), or with a comment that
    has every word."""
    words = [w for w in q.split() if re.search(r"\w", w)][:12]
    if not words:
        return None
    like = ["%" + w.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_") + "%" for w in words]
    return ("(f.rowid IN (SELECT rowid FROM fts WHERE fts MATCH ?) OR f.id IN (SELECT finding_id FROM b.log WHERE field = 'comment' AND "
            + " AND ".join(["new LIKE ? ESCAPE '\\'"] * len(words)) + "))",
            [" ".join('"' + w.replace('"', '""') + '"*' for w in words), *like])


def where(qs, skip=()) -> tuple[str, list]:
    sql, args = [], []
    for key, col in COLUMNS.items():
        vals = values(qs, key) or (list(LIVE) if key == "level" else [])
        if key not in skip and vals and vals != ["all"]:
            sql.append(f"{col} IN ({', '.join('?' * len(vals))})")
            args += vals
    for kind in TAGS:
        vals = values(qs, kind)
        if kind not in skip and vals:
            sql.append(f"f.id IN (SELECT finding_id FROM tag WHERE kind = ? AND value IN ({', '.join('?' * len(vals))}))")
            args += [kind, *vals]
    for key, col in EXACT.items():
        if v := qs.get(key, [""])[0]:
            sql.append(f"{col} = ?")
            args.append(v)
    if qs.get("min_value", [""])[0]:
        sql.append("f.held_now >= ?")
        args.append(float(qs["min_value"][0]))
    if s := search(qs.get("q", [""])[0]):
        sql.append(s[0])
        args += s[1]
    return " AND ".join(sql) or "1", args


def findings(con, qs) -> dict:
    w, args = where(qs)
    sort = qs.get("sort", ["severity"])[0]
    order = SORTS.get(sort, SORTS["severity"]).format(d="DESC" if qs.get("dir", [""])[0] == "desc" else "ASC")
    limit, offset = min(int(qs.get("limit", ["50"])[0]), 500), int(qs.get("offset", ["0"])[0])
    total = con.execute(f"SELECT COUNT(*) FROM {FROM} WHERE {w}", args).fetchone()[0]
    rows = con.execute(f"SELECT {LIST} FROM {FROM} WHERE {w} ORDER BY {order} LIMIT ? OFFSET ?", [*args, limit, offset])
    return {"total": total, "rows": [dict(r) for r in rows]}


def stats(con, qs) -> dict:
    """Counts per value of every filter, each under all the other filters."""
    out = {}
    for key, col in COLUMNS.items():
        w, args = where(qs, skip={key})
        out[key] = con.execute(f"SELECT {col} AS v, COUNT(*) AS n FROM {FROM} WHERE {w} GROUP BY v ORDER BY n DESC", args).fetchall()
    for kind in TAGS:
        w, args = where(qs, skip={kind})
        out[kind] = con.execute(f"SELECT t.value AS v, COUNT(*) AS n FROM {FROM} JOIN tag t ON t.finding_id = f.id "
                                f"WHERE t.kind = ? AND {w} GROUP BY v ORDER BY n DESC", [kind, *args]).fetchall()
    return {k: [dict(r) for r in v] for k, v in out.items()}


def detail(con, fid: str) -> dict | None:
    f = con.execute(f"SELECT {SHOWN} FROM finding WHERE id = ?", (fid,)).fetchone()
    if not f:
        return None
    d = dict(f)
    header = json.loads(con.execute("SELECT header FROM finding_text WHERE finding_id = ?", (fid,)).fetchone()[0])
    d["sources"], d["reviews"] = header.get("sources") or [], header.get("reviews") or []
    o = con.execute("SELECT status, assignee, updated_by, updated_at FROM b.outreach WHERE finding_id = ?", (fid,)).fetchone()
    d["outreach"] = dict(o) if o else {"status": "not-contacted", "assignee": None}
    d["log"] = [dict(r) for r in con.execute("SELECT at, who, field, old, new FROM b.log WHERE finding_id = ? ORDER BY id", (fid,))]
    live = ", ".join("?" * len(LIVE))
    d["same"] = {k: con.execute(f"SELECT COUNT(*) FROM finding f WHERE {col} = ? AND f.level IN ({live})", (d[k], *LIVE)).fetchone()[0]
                 for k, col in EXACT.items() if d.get(k)}
    return d


def meta(con, user: str) -> dict:
    m = dict(con.execute("SELECT key, value FROM meta").fetchall())
    return {**m, "gaps": json.loads(m["gaps"]), "categories": json.loads(m.get("categories") or "{}"),
            "user": user, "users": [r[0] for r in con.execute("SELECT name FROM b.user ORDER BY name")],
            "statuses": STATUSES, "status_help": STATUS_HELP, "unassigned": UNASSIGNED, "severities": SEVERITIES,
            "patterns": {r["id"]: {"title": r["title"], "category": r["category"]} for r in con.execute("SELECT * FROM pattern")},
            "studies": dict(con.execute("SELECT id, title FROM study").fetchall())}


def update(con, user: str, body: dict) -> dict:
    """Set status and/or assignee on findings and/or add a comment to each; log every change. With `expect` (the
    status and assignee the page showed, for one finding), refuse if someone changed them since."""
    ids, status, comment, expect = body.get("ids"), body.get("status"), (body.get("comment") or "").strip(), body.get("expect")
    if not isinstance(ids, list) or not ids or len(ids) > 50_000 or not all(isinstance(i, str) and ID.match(i) for i in ids):
        raise BadRequest("ids: a list of finding ids")
    if status is not None and status not in STATUSES:
        raise BadRequest(f"status: one of {', '.join(STATUSES)}")
    if len(comment) > 5000:
        raise BadRequest("comment: up to 5,000 characters")
    assignee = (body.get("assignee") or "").strip() or None
    if assignee and not con.execute("SELECT 1 FROM b.user WHERE name = ?", (assignee,)).fetchone():
        raise BadRequest(f"assignee: {assignee} has no account here")
    if expect is not None and not (isinstance(expect, dict) and set(expect) <= {"status", "assignee"} and len(ids) == 1):
        raise BadRequest("expect: the status and assignee of one finding")
    known = {r[0] for r in con.execute("SELECT id FROM finding WHERE id IN (SELECT value FROM json_each(?))", (json.dumps(ids),))}
    if missing := [i for i in ids if i not in known]:
        raise BadRequest(f"not in the registry: {', '.join(missing[:5])}")
    now = dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds")
    changed = 0
    con.execute("BEGIN IMMEDIATE")  # the read below and the writes are one step: no other save comes in between
    try:
        current = {r[0]: r[1:] for r in con.execute("SELECT finding_id, status, assignee, updated_by, updated_at FROM b.outreach "
                                                    "WHERE finding_id IN (SELECT value FROM json_each(?))", (json.dumps(ids),))}
        for fid in dict.fromkeys(ids):
            old_status, old_assignee, by, at = current.get(fid, ("not-contacted", None, None, None))
            if expect and (expect.get("status", old_status), expect.get("assignee", old_assignee or "")) != (old_status, old_assignee or ""):
                raise Conflict(f"{by} changed this finding at {str(at)[:16].replace('T', ' ')} UTC: it is now {old_status}, "
                               f"{'assigned to ' + old_assignee if old_assignee else 'unassigned'}. The page shows it now.")
            new = (status or old_status, assignee if "assignee" in body else old_assignee)
            log = [(k, o, n) for k, o, n in (("status", old_status, new[0]), ("assignee", old_assignee, new[1])) if o != n]
            log += [("comment", None, comment)] if comment else []
            if not log:
                continue
            con.execute("INSERT INTO b.outreach VALUES (?, ?, ?, ?, ?) ON CONFLICT (finding_id) DO UPDATE SET "
                        "status = excluded.status, assignee = excluded.assignee, updated_by = excluded.updated_by, "
                        "updated_at = excluded.updated_at", (fid, *new, user, now))
            con.executemany("INSERT INTO b.log (finding_id, at, who, field, old, new) VALUES (?, ?, ?, ?, ?, ?)",
                            [(fid, now, user, *x) for x in log])
            changed += 1
        con.commit()
    except BaseException:
        con.rollback()
        raise
    return {"changed": changed}


# ---- HTTP --------------------------------------------------------------------------------------------------------

class Handler(BaseHTTPRequestHandler):
    server_version = "pq-outreach"

    def do_GET(self):
        self.handle_any("GET")

    def do_PATCH(self):
        self.handle_any("PATCH")

    def send(self, code: int, body: bytes, ctype: str, extra: dict | None = None) -> None:
        self.send_response(code)
        for k, v in {**HEADERS, "Content-Type": ctype, "Content-Length": str(len(body)), **(extra or {})}.items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def json(self, obj, code: int = 200) -> None:
        self.send(code, json.dumps(obj, default=str).encode(), "application/json")

    def handle_any(self, method: str) -> None:
        user = login(self.headers.get("Authorization", ""))
        if not user:
            return self.send(401, b"Log in to see the board.\n", "text/plain",
                             {"WWW-Authenticate": 'Basic realm="PQ findings outreach", charset="UTF-8"'})
        url = urlsplit(self.path)
        if method == "GET" and url.path in STATIC:
            name, ctype = STATIC[url.path]
            return self.send(200, (HERE / "web" / name).read_bytes(), ctype + "; charset=utf-8")
        qs = parse_qs(url.query)
        con = connect()
        try:
            if method == "PATCH" and url.path == "/api/outreach":
                if self.headers.get("Content-Type", "").split(";")[0] != "application/json":
                    return self.send(415, b"JSON only\n", "text/plain")
                n = int(self.headers.get("Content-Length") or 0)
                if n > 4_000_000:
                    return self.send(413, b"too large\n", "text/plain")
                return self.json(update(con, user, json.loads(self.rfile.read(n))))
            if method != "GET":
                return self.send(405, b"method not allowed\n", "text/plain")
            if url.path == "/api/meta":
                return self.json(meta(con, user))
            if url.path == "/api/findings":
                return self.json(findings(con, qs))
            if url.path == "/api/ids":
                w, args = where(qs)
                return self.json([r[0] for r in con.execute(f"SELECT f.id FROM {FROM} WHERE {w}", args)])
            if url.path == "/api/stats":
                return self.json(stats(con, qs))
            if url.path.startswith("/api/finding/"):
                d = detail(con, unquote(url.path.removeprefix("/api/finding/")))
                return self.json(d) if d else self.send(404, b"no such finding\n", "text/plain")
            return self.send(404, b"not found\n", "text/plain")
        except (BadRequest, ValueError) as e:
            return self.json({"error": str(e)}, 400)
        except Conflict as e:
            return self.json({"error": str(e)}, 409)
        except sqlite3.OperationalError as e:
            if "fts5" in str(e):
                return self.json({"error": "search: " + str(e)}, 400)
            self.log_error("%s", traceback.format_exc())
            return self.json({"error": f"server error: {e}"}, 500)
        except Exception as e:  # the client gets an answer, the journal gets the traceback
            self.log_error("%s", traceback.format_exc())
            return self.json({"error": f"server error: {e.__class__.__name__}"}, 500)
        finally:
            con.close()


def serve(port: int) -> None:
    board().close()
    httpd = ThreadingHTTPServer(("127.0.0.1", port), Handler)  # ponytail: stdlib server, fine for a team; behind a tunnel
    print(f"http://127.0.0.1:{port}/", flush=True)
    httpd.serve_forever()


def user(name: str, delete: bool) -> None:
    with board() as con:
        if delete:
            con.execute("DELETE FROM user WHERE name = ?", (name,))
            return print(f"deleted {name}; restart the server to end its sessions")
        if not USER.match(name):
            sys.exit("name: 2-40 letters, digits, '.', '_' or '-'")
        password, salt = secrets.token_urlsafe(15), secrets.token_bytes(16)
        con.execute("INSERT INTO user VALUES (?, ?, ?) ON CONFLICT (name) DO UPDATE SET salt = excluded.salt, hash = excluded.hash",
                    (name, salt, scrypt(password, salt)))
    print(f"{name}  {password}")


def backup() -> None:
    """Copy outreach.db over the previous copy. The copy is written aside and renamed, so a failed run leaves the
    previous one in place."""
    out = DATA / "backups"
    out.mkdir(exist_ok=True)
    tmp = out / "outreach.db.tmp"
    tmp.unlink(missing_ok=True)
    src, dst = board(), sqlite3.connect(tmp)
    src.backup(dst)
    src.close()
    dst.close()
    os.replace(tmp, out / "outreach.db")


def orphans() -> None:
    """The outreach records of findings the registry no longer has (removed, renamed): kept in case they come back."""
    board().close()
    con = connect()
    try:
        rows = con.execute("SELECT finding_id, status, assignee FROM b.outreach WHERE finding_id NOT IN (SELECT id FROM finding) "
                           "ORDER BY finding_id").fetchall()
    finally:
        con.close()
    if rows:
        print(f"{len(rows)} outreach record{'s' * (len(rows) > 1)} without a finding in the registry: " +
              ", ".join(f"{r['finding_id']} ({r['status']}{', ' + r['assignee'] if r['assignee'] else ''})" for r in rows))


if __name__ == "__main__":
    cmd = sys.argv[1:2]
    if cmd == ["serve"]:
        serve(int(sys.argv[2]) if len(sys.argv) > 2 else 8090)
    elif cmd == ["user"] and len(sys.argv) in (3, 4):
        user(sys.argv[2], sys.argv[3:] == ["--delete"])
    elif cmd == ["backup"]:
        backup()
    elif cmd == ["orphans"]:
        orphans()
    else:
        sys.exit(__doc__)
