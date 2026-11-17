#!/usr/bin/env python3
"""Validate findings/*.md against findings/README.md and build generated/ (INDEX.md, findings.csv, contracts.csv).

  python3 tools/build.py          validate, then write generated/
  python3 tools/build.py --check  validate only (exit 1 on any problem); also fails if generated/ is stale
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import io
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
FINDINGS = ROOT / "findings"
GENERATED = ROOT / "generated"

STATUS = ("confirmed", "candidate", "not-affected", "duplicate")
SEVERITY = ("CRITICAL", "HIGH", "MEDIUM", "LOW", "NONE", "UNRATED")
PRIMITIVES = ("ecrecover", "bn254", "kzg", "bls12381", "p256", "sw_p256", "sw_secp256k1", "sw_bn254", "sw_ed25519",
              "sw_bls12381", "rsa")
TRIGGER = ("user-key", "operator-key", "committee-keys", "trusted-setup", "owner-keys", "issuer-key", "none")
IMPACT = ("funds-loss", "funds-locked", "liveness", "none", "unknown")
ALTERNATIVE = ("sole", "key-rotation-only", "alternative-exists", "configurable-verifier")
ROLE = ("core", "auxiliary")
UPGRADEABLE = ("yes", "no", "config-only", "unknown")
VALUE_BASIS = ("held", "market-cap", "escrow")
FIX_LAYER = ("contract-upgrade", "onchain-config", "new-deployment", "account-migration", "offchain", "protocol", "none",
             "unknown")
PROTOCOL_CHANGE = ("required", "helps", "not-needed")
EVIDENCE = ("onchain-read", "source-read", "bytecode", "trace")
SOURCE_BY = ("ai-assisted", "project-team", "other")
VERDICT = ("reported", "confirmed", "refuted")
BODY_HEADINGS = ("Summary", "Mechanism", "Evidence", "Impact and exposure", "Remediation", "History")

SLUG = re.compile(r"^[a-z0-9][a-z0-9-]*$")
ADDRESS = re.compile(r"^0x[0-9a-f]{40}$")
PATTERN_HEADING = re.compile(r"^## (PQ-\d+): (.+)$", re.M)


class Loader(yaml.SafeLoader):
    """No implicit booleans (yes/no are enum values here); dates stay dates."""


Loader.yaml_implicit_resolvers = {
    k: [(tag, rx) for tag, rx in v if tag != "tag:yaml.org,2002:bool"] for k, v in yaml.SafeLoader.yaml_implicit_resolvers.items()
}


class Problems(list):
    def add(self, where: str, msg: str) -> None:
        self.append(f"{where}: {msg}")


def load_patterns() -> dict[str, str]:
    return dict(PATTERN_HEADING.findall((ROOT / "patterns.md").read_text()))


def split(path: Path, p: Problems):
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        p.add(path.name, "no YAML header")
        return None, ""
    end = text.find("\n---\n", 4)
    if end < 0:
        p.add(path.name, "unterminated YAML header")
        return None, ""
    try:
        return yaml.load(text[4:end], Loader=Loader) or {}, text[end + 5:]
    except yaml.YAMLError as e:
        p.add(path.name, f"YAML: {e}")
        return None, ""


def enum(p, where, d, key, allowed, required=True):
    v = d.get(key)
    if v is None and not required:
        return None
    if v not in allowed:
        p.add(where, f"{key}={v!r} not in {list(allowed)}")
    return v


def addr(p, where, v, key, optional=False):
    if v is None and optional:
        return None
    if not isinstance(v, str) or not ADDRESS.match(v):
        p.add(where, f"{key}={v!r} is not a lowercase 0x address")
        return None
    return v


def number(p, where, d, key):
    v = d.get(key)
    if v is not None and not isinstance(v, (int, float)):
        p.add(where, f"{key}={v!r} is not a number")
    return v


def date(p, where, d, key, required=False):
    v = d.get(key)
    if v is None and not required:
        return None
    if not isinstance(v, dt.date):
        p.add(where, f"{key}={v!r} is not a YYYY-MM-DD date")
    return v


def load_finding(path: Path, patterns: dict[str, str], p: Problems):
    head, body = split(path, p)
    if head is None:
        return None
    w = path.name
    f = dict(head)
    f["_path"] = path
    if f.get("id") != path.stem:
        p.add(w, f"id {f.get('id')!r} must equal the file name {path.stem!r}")
    if not SLUG.match(str(f.get("id", ""))) or not SLUG.match(str(f.get("project", ""))):
        p.add(w, "id and project must be slugs")
    if not isinstance(f.get("title"), str) or len(f["title"]) < 10:
        p.add(w, "title missing")
    status = enum(p, w, f, "status", STATUS)
    sev = enum(p, w, f, "severity", SEVERITY)
    for key, allowed in (("trigger", TRIGGER), ("impact", IMPACT), ("alternative", ALTERNATIVE), ("role", ROLE)):
        enum(p, w, f, key, allowed)
    for pid in f.get("patterns") or []:
        if pid not in patterns:
            p.add(w, f"unknown pattern {pid}")
    if not f.get("patterns") and status in ("confirmed", "candidate"):
        p.add(w, "patterns empty")
    for prim in f.get("primitives") or []:
        if prim not in PRIMITIVES:
            p.add(w, f"unknown primitive {prim}")
    if status == "confirmed" and sev == "UNRATED":
        p.add(w, "confirmed findings need a rating")
    if status == "not-affected" and sev != "NONE":
        p.add(w, "not-affected needs severity NONE")
    if status == "duplicate" and not f.get("duplicate_of"):
        p.add(w, "duplicate needs duplicate_of")

    contracts = f.get("contracts") or []
    families = f.get("families") or []
    if not contracts and not families:
        p.add(w, "no contracts or families")
    for i, c in enumerate(contracts):
        cw = f"{w} contracts[{i}]"
        addr(p, cw, c.get("address"), "address")
        addr(p, cw, c.get("implementation"), "implementation", optional=True)
        enum(p, cw, c, "upgradeable", UPGRADEABLE)
        enum(p, cw, c, "value_basis", VALUE_BASIS, required=False)
        for k in ("value_usd", "txs_30d"):
            number(p, cw, c, k)
        if c.get("value_usd") is not None and (c.get("value_basis") is None or c.get("value_as_of") is None):
            p.add(cw, "value_usd needs value_basis and value_as_of")
        date(p, cw, c, "value_as_of")
        date(p, cw, c, "last_active")
    for i, fam in enumerate(families):
        cw = f"{w} families[{i}]"
        addr(p, cw, fam.get("code"), "code")
        enum(p, cw, fam, "upgradeable", UPGRADEABLE)
        if not isinstance(fam.get("instances"), int) or fam["instances"] < 2:
            p.add(cw, "instances must be an integer >= 2")
        number(p, cw, fam, "value_usd")

    fix = f.get("fix") or {}
    enum(p, w + " fix", fix, "layer", FIX_LAYER)
    enum(p, w + " fix", fix, "protocol_change", PROTOCOL_CHANGE)
    if not fix.get("who_acts"):
        p.add(w, "fix.who_acts missing")
    ev = f.get("evidence") or {}
    enum(p, w + " evidence", ev, "level", EVIDENCE)
    for link in ev.get("links") or []:
        if not (ROOT / link).exists():
            p.add(w, f"evidence link missing on disk: {link}")
    sources = f.get("sources") or []
    if not sources:
        p.add(w, "no sources")
    for i, s in enumerate(sources):
        sw = f"{w} sources[{i}]"
        enum(p, sw, s, "by", SOURCE_BY)
        enum(p, sw, s, "verdict", VERDICT)
        date(p, sw, s, "date", required=True)
    if status == "confirmed" and all(s.get("verdict") == "refuted" for s in sources):
        p.add(w, "confirmed needs a source that is not refuted")

    heads = re.findall(r"^## (.+)$", body, re.M)
    missing = [h for h in BODY_HEADINGS if h not in heads]
    if missing:
        p.add(w, f"body is missing sections {missing}")
    if not re.search(r"^- \d{4}-\d{2}-\d{2}", body.split("## History", 1)[-1], re.M):
        p.add(w, "History needs at least one dated entry")
    return f


def cross_check(findings: list[dict], p: Problems) -> None:
    ids = {f["id"] for f in findings}
    owner: dict[str, str] = {}
    for f in findings:
        for r in f.get("related") or []:
            if r not in ids:
                p.add(f["id"], f"related {r} does not exist")
        if f.get("duplicate_of") and f["duplicate_of"] not in ids:
            p.add(f["id"], f"duplicate_of {f['duplicate_of']} does not exist")
        if f.get("status") == "duplicate":
            continue
        for c in f.get("contracts") or []:
            a = c.get("address")
            if not a:
                continue
            if a in owner and owner[a] != f["id"]:
                other = next(x for x in findings if x["id"] == owner[a])
                if f["id"] not in (other.get("related") or []) or owner[a] not in (f.get("related") or []):
                    p.add(f["id"], f"{a} is also claimed by {owner[a]}; link them in `related` both ways or merge")
            owner.setdefault(a, f["id"])


def money(v) -> str:
    if v is None:
        return ""
    v = float(v)
    return f"${v / 1e9:.1f}B" if v >= 1e9 else f"${v / 1e6:.1f}M" if v >= 1e6 else f"${v / 1e3:.0f}k" if v >= 1e3 else f"${v:.0f}"


def exposure(f) -> tuple[float | None, str]:
    """The finding's measured exposure: summed held/escrow value, else the largest market cap."""
    held = [c.get("value_usd") for c in (f.get("contracts") or []) + (f.get("families") or [])
            if c.get("value_usd") is not None and c.get("value_basis") in ("held", "escrow")]
    caps = [c.get("value_usd") for c in f.get("contracts") or [] if c.get("value_usd") is not None and c.get("value_basis") == "market-cap"]
    if held:
        return float(sum(held)), "held"
    if caps:
        return float(max(caps)), "market cap"
    return None, ""


def activity(f) -> int:
    return sum(c.get("txs_30d") or 0 for c in (f.get("contracts") or []))


def upgradeable(f) -> str:
    vals = {c.get("upgradeable") for c in (f.get("contracts") or []) + (f.get("families") or [])}
    return "/".join(v for v in UPGRADEABLE if v in vals)


def order(f):
    return (STATUS.index(f["status"]), SEVERITY.index(f["severity"]), -(exposure(f)[0] or 0), f["id"])


def index_md(findings: list[dict], patterns: dict[str, str]) -> str:
    live = [f for f in findings if f["status"] in ("confirmed", "candidate")]
    counts = {s: sum(1 for f in live if f["severity"] == s) for s in SEVERITY}
    lines = [
        "# Findings index", "",
        "Generated by `tools/build.py` from the file headers; do not edit. Severity rubric: `findings/README.md`.", "",
        "Live findings: " + ", ".join(f"{s} {counts[s]}" for s in SEVERITY if counts[s]) +
        f". Confirmed {sum(1 for f in live if f['status'] == 'confirmed')}, candidates "
        f"{sum(1 for f in live if f['status'] == 'candidate')}. Not affected "
        f"{sum(1 for f in findings if f['status'] == 'not-affected')}. Contracts covered "
        f"{sum(len(f.get('contracts') or []) for f in live)}.", "",
    ]
    for sev in SEVERITY:
        rows = sorted((f for f in live if f["severity"] == sev), key=order)
        if not rows:
            continue
        lines += [f"## {sev}", "",
                  "| Finding | Project | Patterns | Trigger | Impact | Alternative | Upgradeable | Fix | Protocol change | Exposure | 30-day txs | Status |",
                  "|---|---|---|---|---|---|---|---|---|---|---|---|"]
        for f in rows:
            v, basis = exposure(f)
            txs = activity(f)
            lines.append(
                f"| [{f['id']}](../findings/{f['id']}.md) | {f['project']} | {', '.join(f.get('patterns') or [])} | "
                f"{f['trigger']} | {f['impact']} | {f['alternative']} | {upgradeable(f)} | {f['fix']['layer']} | "
                f"{f['fix']['protocol_change']} | {money(v)}{' (' + basis + ')' if basis == 'market cap' else ''} | "
                f"{txs:,} | {f['status']} |")
        lines.append("")
    na = sorted((f for f in findings if f["status"] in ("not-affected", "duplicate")), key=lambda f: f["id"])
    if na:
        lines += ["## Not affected or duplicate", "", "| Finding | Project | Status | Why |", "|---|---|---|---|"]
        for f in na:
            lines.append(f"| [{f['id']}](../findings/{f['id']}.md) | {f['project']} | {f['status']} | {f['title']} |")
        lines.append("")
    by_pattern = {pid: [f for f in live if pid in (f.get("patterns") or [])] for pid in patterns}
    lines += ["## By pattern", "", "| Pattern | Findings | CRITICAL | HIGH | MEDIUM | LOW |", "|---|---|---|---|---|---|"]
    for pid, name in patterns.items():
        fs = by_pattern[pid]
        lines.append(f"| {pid}: {name} | {len(fs)} | " + " | ".join(str(sum(1 for f in fs if f['severity'] == s))
                                                                    for s in ("CRITICAL", "HIGH", "MEDIUM", "LOW")) + " |")
    return "\n".join(lines) + "\n"


def to_csv(header, rows) -> str:
    buf = io.StringIO()
    w = csv.writer(buf, lineterminator="\n")
    w.writerow(header)
    w.writerows(rows)
    return buf.getvalue()


def findings_csv(findings) -> str:
    header = ["id", "project", "status", "severity", "patterns", "primitives", "trigger", "impact", "alternative", "role",
              "upgradeable", "fix_layer", "protocol_change", "who_acts", "exposure_usd", "exposure_basis", "txs_30d",
              "contracts", "evidence_level", "title"]
    rows = []
    for f in sorted(findings, key=order):
        v, basis = exposure(f)
        txs = activity(f)
        rows.append([f["id"], f["project"], f["status"], f["severity"], " ".join(f.get("patterns") or []),
                     " ".join(f.get("primitives") or []), f["trigger"], f["impact"], f["alternative"], f["role"],
                     upgradeable(f), f["fix"]["layer"], f["fix"]["protocol_change"], f["fix"]["who_acts"],
                     "" if v is None else round(v), basis, txs, len(f.get("contracts") or []),
                     f["evidence"]["level"], f["title"]])
    return to_csv(header, rows)


def contracts_csv(findings) -> str:
    header = ["address", "finding", "severity", "status", "name", "implementation", "upgradeable", "admin", "value_usd",
              "value_basis", "value_as_of", "last_active", "txs_30d"]
    rows = []
    for f in sorted(findings, key=order):
        for c in f.get("contracts") or []:
            rows.append([c["address"], f["id"], f["severity"], f["status"], c.get("name") or "", c.get("implementation") or "",
                         c.get("upgradeable"), c.get("admin") or "", "" if c.get("value_usd") is None else round(c["value_usd"]),
                         c.get("value_basis") or "", c.get("value_as_of") or "", c.get("last_active") or "",
                         "" if c.get("txs_30d") is None else c["txs_30d"]])
    return to_csv(header, rows)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true", help="validate only; fail if generated/ is stale")
    args = ap.parse_args()
    p = Problems()
    patterns = load_patterns()
    findings = [f for path in sorted(FINDINGS.glob("*.md")) if path.name != "README.md"
                if (f := load_finding(path, patterns, p)) is not None]
    cross_check(findings, p)
    if p:
        print("\n".join(p))
        print(f"{len(p)} problem(s)")
        return 1
    out = {"INDEX.md": index_md(findings, patterns), "findings.csv": findings_csv(findings),
           "contracts.csv": contracts_csv(findings)}
    if args.check:
        stale = [n for n, t in out.items() if not (GENERATED / n).exists() or (GENERATED / n).read_text() != t]
        if stale:
            print("generated/ is stale: " + ", ".join(stale) + " (run tools/build.py)")
            return 1
    else:
        GENERATED.mkdir(exist_ok=True)
        for n, t in out.items():
            (GENERATED / n).write_text(t)
    print(f"OK: {len(findings)} findings")
    return 0


if __name__ == "__main__":
    sys.exit(main())
