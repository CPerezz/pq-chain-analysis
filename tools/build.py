#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = ["pyyaml>=6"]
# ///
"""Check studies/, triage/, findings/, outreach/ and patterns.md, and build generated/.

  uv run tools/build.py             check, then write generated/
  uv run tools/build.py --check     check only
  uv run tools/build.py --selftest  also prove that the rules reject what they should

Field references: studies/README.md, findings/README.md, outreach/README.md. templates/examples/ is checked on every run.
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import io
import re
import shutil
import sys
import tempfile
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
GENERATED = ROOT / "generated"
EXAMPLES = ROOT / "templates" / "examples"

LEVELS = ("reproduced", "confirmed", "candidate")  # live findings, strongest first
STATUS = LEVELS + ("not-affected", "duplicate", "discarded")  # discarded: only in triage/
SEVERITY = ("CRITICAL", "HIGH", "MEDIUM", "LOW", "NONE", "UNRATED")
IMPACT = ("funds-loss", "funds-locked", "liveness", "none", "unknown")
UPGRADEABLE = ("yes", "no", "config-only", "unknown")
VALUE_BASIS = ("held", "market-cap", "escrow")
FIX_LAYER = ("contract-upgrade", "onchain-config", "new-deployment", "account-migration", "offchain", "protocol", "none",
             "unknown")
EVIDENCE = ("onchain-read", "source-read", "bytecode", "trace", "executed")
SOURCE_BY = ("ai-assisted", "project-team", "other")
VERDICT = ("reported", "confirmed", "refuted")
REVIEW_VERDICT = ("confirmed", "refuted")
BODY_HEADINGS = ("Summary", "Mechanism", "Evidence", "Impact and exposure", "Remediation", "History")
# required only for findings whose first pattern is in class `exposure`
PRIMITIVES = ("ecrecover", "bn254", "kzg", "bls12381", "p256", "sw_p256", "sw_secp256k1", "sw_bn254", "sw_ed25519",
              "sw_bls12381", "rsa")
TRIGGER = ("user-key", "operator-key", "committee-keys", "trusted-setup", "owner-keys", "issuer-key", "none")
ALTERNATIVE = ("sole", "key-rotation-only", "alternative-exists", "configurable-verifier")
ROLE = ("core", "auxiliary")
PROTOCOL_CHANGE = ("required", "helps", "not-needed")

STUDY_STATUS = ("planned", "running", "published")
STUDY_SECTIONS = ("Goal", "Setup", "Procedure", "Reproduce", "Results", "Limits")
OUTREACH = ("not-contacted", "contacted", "acknowledged", "fix-planned", "fixed", "unresponsive", "declined")

SLUG = re.compile(r"^[a-z0-9][a-z0-9-]*$")
ADDRESS = re.compile(r"^0x[0-9a-f]{40}$")
TX = re.compile(r"^0x[0-9a-f]{64}$")
COMMIT = re.compile(r"[0-9a-f]{40}")
CLASS_ITEM = re.compile(r"^- \*\*([a-z][a-z-]*)\*\*:", re.M)
PATTERN_HEADING = re.compile(r"^## (PQ-\d+): (.+)$", re.M)
CLASS_LINE = re.compile(r"^\*\*Class:\*\* *([a-z-]+)", re.M)
DATED = re.compile(r"^- \d{4}-\d{2}-\d{2}", re.M)


class Loader(yaml.SafeLoader):
    """No implicit booleans (yes/no are enum values here); dates stay dates."""


Loader.yaml_implicit_resolvers = {
    k: [(tag, rx) for tag, rx in v if tag != "tag:yaml.org,2002:bool"] for k, v in yaml.SafeLoader.yaml_implicit_resolvers.items()
}


class Problems(list):
    def add(self, where: str, msg: str) -> None:
        self.append(f"{where}: {msg}")


def split(path: Path, p: Problems):
    """(header mapping, body) of a Markdown file with a YAML header."""
    text = path.read_text(encoding="utf-8")
    end = text.find("\n---\n", 4)
    if not text.startswith("---\n") or end < 0:
        p.add(path.name, "no YAML header")
        return None, ""
    try:
        head = yaml.load(text[4:end], Loader=Loader)
    except yaml.YAMLError as e:
        p.add(path.name, f"YAML: {e}")
        return None, ""
    if not isinstance(head, dict):
        p.add(path.name, "the YAML header is not a mapping")
        return None, ""
    return head, text[end + 5:]


def sections(body: str) -> list[str]:
    """The `## ` headings of the record itself. Appended documents start at the first `# ` line and are skipped."""
    return re.findall(r"^## (.+)$", re.split(r"^# ", body, maxsplit=1, flags=re.M)[0], re.M)


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


def pinned(url) -> bool:
    return isinstance(url, str) and url.startswith("http") and bool(COMMIT.search(url))


def load_patterns(p: Problems, path: Path = ROOT / "patterns.md") -> tuple[list[str], dict[str, dict]]:
    """Classes in file order, and pattern id -> {title, class}."""
    text = path.read_text(encoding="utf-8")
    parts = PATTERN_HEADING.split(text)
    classes = CLASS_ITEM.findall(parts[0])
    patterns = {}
    for pid, title, body in zip(parts[1::3], parts[2::3], parts[3::3]):
        m = CLASS_LINE.search(body)
        if not m or m.group(1) not in classes:
            p.add("patterns.md", f"{pid} needs a `**Class:**` line naming one of {classes}")
        patterns[pid] = {"title": title, "class": m.group(1) if m else None}
    return classes, patterns


def load_study(path: Path, p: Problems):
    head, body = split(path, p)
    if head is None:
        return None
    w, s = f"studies/{path.parent.name}", dict(head)
    if s.get("id") != path.parent.name or not SLUG.match(str(s.get("id"))):
        p.add(w, f"id {s.get('id')!r} must be a slug equal to the folder name")
    if not isinstance(s.get("title"), str) or len(s["title"]) < 10:
        p.add(w, "title missing")
    if not isinstance(s.get("authors"), list) or not s["authors"] or not all(isinstance(a, str) for a in s["authors"]):
        p.add(w, "authors must be a list of names")
    enum(p, w, s, "status", STUDY_STATUS)
    date(p, w, s, "started")
    date(p, w, s, "published")
    if not SLUG.match(str(s.get("topic"))):
        p.add(w, "topic must be a slug")
    code = s.get("code")
    if code != "none":
        if not isinstance(code, list) or not code:
            p.add(w, "code must be `none` or a list of links")
        else:
            for url in code:
                if not pinned(url):
                    p.add(w, f"code link {url!r} must carry a full commit hash or gist revision")
    spec = s.get("spec")
    if re.fullmatch(r"eip-\d+", str(s.get("topic"))) and spec is None:
        p.add(w, "a study of an EIP needs `spec` (repo, path, commit)")
    if spec is not None and not (isinstance(spec, dict) and isinstance(spec.get("repo"), str) and isinstance(spec.get("path"), str)
                                 and COMMIT.fullmatch(str(spec.get("commit")))):
        p.add(w, "spec needs repo, path and a full commit hash")
    if tuple(sections(body)) != STUDY_SECTIONS:
        p.add(w, f"sections must be {list(STUDY_SECTIONS)} in that order, found {sections(body)}")
    s["authors"] = s.get("authors") if isinstance(s.get("authors"), list) else []
    return s


def load_finding(path: Path, patterns: dict[str, dict], studies: dict[str, dict], p: Problems, pool: str = "findings"):
    head, body = split(path, p)
    if head is None:
        return None
    w, f = (path.name if pool == "findings" else f"{pool}/{path.name}"), dict(head)
    if f.get("id") != path.stem or not SLUG.match(str(f.get("id"))):
        p.add(w, f"id {f.get('id')!r} must be a slug equal to the file name {path.stem!r}")
        f["id"] = path.stem
    if not isinstance(f.get("title"), str) or len(f["title"]) < 10:
        p.add(w, "title missing")
        f["title"] = str(f.get("title"))
    status = enum(p, w, f, "status", STATUS)
    light = status in ("candidate", "discarded")  # a candidate needs a title, a pattern, a place, an explanation and a reporter
    pats = f.get("patterns") if isinstance(f.get("patterns"), list) else []
    for pid in pats:
        if pid not in patterns:
            p.add(w, f"unknown pattern {pid}")
    if not pats and status in LEVELS:
        p.add(w, "patterns empty")
    f["patterns"] = pats
    f["_class"] = patterns.get(pats[0], {}).get("class") if pats else None
    exposure_class = f["_class"] == "exposure"
    sev = enum(p, w, f, "severity", SEVERITY, required=not light) or "UNRATED"
    f["severity"] = sev if sev in SEVERITY else "UNRATED"
    if status in ("confirmed", "reproduced") and sev == "UNRATED":
        p.add(w, f"{status} findings need a rating")
    if status == "not-affected" and sev != "NONE":
        p.add(w, "not-affected needs severity NONE")
    if status == "duplicate" and not f.get("duplicate_of"):
        p.add(w, "duplicate needs duplicate_of")

    contracts = f.get("contracts") if isinstance(f.get("contracts"), list) else []
    families = f.get("families") if isinstance(f.get("families"), list) else []
    f["contracts"], f["families"] = contracts, families
    if not contracts and not families and not f.get("offchain") and f["_class"] != "spec-issue":
        p.add(w, "no place: needs a contract, a family or an `offchain` entry")
    for i, c in enumerate(contracts):
        cw = f"{w} contracts[{i}]"
        addr(p, cw, c.get("address"), "address")
        addr(p, cw, c.get("implementation"), "implementation", optional=True)
        enum(p, cw, c, "upgradeable", UPGRADEABLE, required=not light)
        enum(p, cw, c, "value_basis", VALUE_BASIS, required=False)
        for k in ("value_usd", "txs_30d"):
            number(p, cw, c, k)
        if c.get("value_usd") is not None and (c.get("value_basis") is None or c.get("value_as_of") is None):
            p.add(cw, "value_usd needs value_basis and value_as_of")
        date(p, cw, c, "value_as_of")
        date(p, cw, c, "last_active")
        if c.get("project") is not None and not SLUG.match(str(c["project"])):
            p.add(cw, "project must be a slug")
        if c.get("copies") is not None and (not isinstance(c["copies"], int) or c["copies"] < 1):
            p.add(cw, "copies must be an integer >= 1")
        enum(p, cw, c, "rating", SEVERITY, required=False)
        number(p, cw, c, "recoveries_14d")
        for k in ("family", "label", "note", "name"):
            if c.get(k) is not None and not isinstance(c[k], str):
                p.add(cw, f"{k} must be text")
    rated = [c.get("rating") for c in contracts if c.get("rating") in SEVERITY]
    if rated and status in LEVELS and f["severity"] != min(rated, key=SEVERITY.index):
        p.add(w, f"severity {f['severity']} must be the worst row rating, {min(rated, key=SEVERITY.index)}")
    for i, fam in enumerate(families):
        cw = f"{w} families[{i}]"
        addr(p, cw, fam.get("code"), "code")
        enum(p, cw, fam, "upgradeable", UPGRADEABLE, required=not light)
        if not isinstance(fam.get("instances"), int) or fam["instances"] < 2:
            p.add(cw, "instances must be an integer >= 2")
        number(p, cw, fam, "value_usd")
    if f.get("project") is not None and not SLUG.match(str(f["project"])):
        p.add(w, "project must be a slug")
    if pool == "triage" and isinstance(f.get("project"), str) and not f["id"].startswith(f["project"] + "-"):
        p.add(w, f"id must be <project>-<mechanism>: start it with {f['project']}-")
    f["_projects"] = sorted({x for x in [f.get("project")] + [c.get("project") for c in contracts] if isinstance(x, str)})
    if pool == "triage" and any(x.startswith("unidentified") for x in f["_projects"]):
        p.add(w, "no `unidentified-*` project: leave `project` out and give the row a `label` where one is known")

    fix = f.get("fix") if isinstance(f.get("fix"), dict) else {}
    ev = f.get("evidence") if isinstance(f.get("evidence"), dict) else {}
    f["fix"], f["evidence"] = fix, ev
    if "links" in ev:
        p.add(w, "evidence.links is gone: a finding has no side files (quote in the text, or link with evidence.raw)")
    if not light:
        enum(p, w, f, "impact", IMPACT)
        enum(p, w + " fix", fix, "layer", FIX_LAYER)
        if not fix.get("who_acts"):
            p.add(w, "fix.who_acts missing")
        enum(p, w + " evidence", ev, "level", EVIDENCE)
        if exposure_class:
            for key, allowed in (("trigger", TRIGGER), ("alternative", ALTERNATIVE), ("role", ROLE)):
                enum(p, w, f, key, allowed)
            enum(p, w + " fix", fix, "protocol_change", PROTOCOL_CHANGE)
            for prim in f.get("primitives") or []:
                if prim not in PRIMITIVES:
                    p.add(w, f"unknown primitive {prim}")
    if status in ("confirmed", "reproduced") and not isinstance(ev.get("block"), int):
        p.add(w, "evidence.block is required from confirmed up: the block at which state was read")
    if status == "reproduced":
        r = f.get("repro") if isinstance(f.get("repro"), dict) else {}
        if not pinned(r.get("code")):
            p.add(w, "repro.code must be a link that carries a full commit hash or gist revision")
        if not isinstance(r.get("command"), str) or not r["command"].strip():
            p.add(w, "repro.command missing")
        inputs = r.get("inputs") if isinstance(r.get("inputs"), dict) else {}
        if not isinstance(inputs.get("block"), int) and inputs.get("tx") is None:
            p.add(w, "repro.inputs needs a block or a tx")
        if inputs.get("tx") is not None and not TX.match(str(inputs["tx"])):
            p.add(w, "repro.inputs.tx is not a transaction hash")
        if not r.get("expect"):
            p.add(w, "repro.expect missing: the result the command must give")

    sources = f.get("sources") if isinstance(f.get("sources"), list) else []
    f["sources"] = sources
    if not sources:
        p.add(w, "no sources: who reports it, from which study, when")
    for i, s in enumerate(sources):
        sw = f"{w} sources[{i}]"
        if s.get("study") not in studies:
            p.add(sw, f"study {s.get('study')!r} is not a folder in studies/")
        if not s.get("who"):
            p.add(sw, "who missing")
        date(p, sw, s, "date", required=True)
        enum(p, sw, s, "by", SOURCE_BY, required=not light)
        enum(p, sw, s, "verdict", VERDICT, required=not light)
    if status in ("confirmed", "reproduced") and sources and all(s.get("verdict") == "refuted" for s in sources):
        p.add(w, f"{status} needs a source that is not refuted")
    f["_studies"] = list(dict.fromkeys(s.get("study") for s in sources if s.get("verdict") != "refuted" and s.get("study")))

    reviews = f.get("reviews") if isinstance(f.get("reviews"), list) else []
    f["reviews"], f["_pool"] = reviews, pool
    for i, r in enumerate(reviews):
        rw = f"{w} reviews[{i}]"
        if not isinstance(r, dict) or not r.get("who"):
            p.add(rw, "who missing")
            continue
        date(p, rw, r, "date", required=True)
        enum(p, rw, r, "by", SOURCE_BY)
        enum(p, rw, r, "verdict", REVIEW_VERDICT)
        if r.get("rating") not in (None, "", *SEVERITY):
            p.add(rw, f"rating={r['rating']!r} not in {list(SEVERITY)}")
    if status == "discarded":
        if pool != "triage":
            p.add(w, "discarded entries stay in triage/")
        if not any(isinstance(r, dict) and r.get("verdict") == "refuted" for r in reviews):
            p.add(w, "discarded needs a review with verdict refuted: who, when and why")

    heads = sections(body)
    missing = [h for h in (("Summary",) if light else BODY_HEADINGS) if h not in heads]
    if missing:
        p.add(w, f"body is missing sections {missing}")
    if not light and not DATED.search(body.split("## History", 1)[-1]):
        p.add(w, "History needs at least one dated entry")
    return f


def load_outreach(path: Path, projects: set[str], p: Problems):
    head, body = split(path, p)
    if head is None:
        return None
    w, o = f"outreach/{path.name}", dict(head)
    if o.get("project") != path.stem:
        p.add(w, f"project {o.get('project')!r} must equal the file name")
    if path.stem not in projects:
        p.add(w, "no finding names this project")
    status = enum(p, w, o, "status", OUTREACH)
    date(p, w, o, "fix_eta")
    if "Log" not in sections(body):
        p.add(w, "body needs a `## Log` section")
    if status not in (None, "not-contacted") and not DATED.search(body.split("## Log", 1)[-1]):
        p.add(w, f"status {status} needs at least one dated line in the log")
    return o


def cross_check(findings: list[dict], p: Problems) -> None:
    """`findings` holds both pools: an issue is filed once, in triage/ or in findings/."""
    by_id: dict[str, dict] = {}
    for f in findings:
        if f["id"] in by_id:
            p.add(f["id"], "is in findings/ and in triage/: move the file, do not copy it")
        by_id.setdefault(f["id"], f)
    owner: dict[tuple[str, str], str] = {}
    for f in findings:
        for r in f.get("related") or []:
            if r not in by_id:
                p.add(f["id"], f"related {r} does not exist")
        if f.get("duplicate_of") and f["duplicate_of"] not in by_id:
            p.add(f["id"], f"duplicate_of {f['duplicate_of']} does not exist")
        if f.get("status") in ("duplicate", "discarded"):
            continue
        for key in {(c.get("address"), pid) for c in f["contracts"] for pid in f["patterns"] if c.get("address")}:
            first = owner.setdefault(key, f["id"])
            if first != f["id"] and not (f["id"] in (by_id[first].get("related") or []) and first in (f.get("related") or [])):
                p.add(f["id"], f"{key[0]} is already under {key[1]} in {first}: that is a duplicate. Merge them, or if "
                               "they are different issues name each other in `related`")


def load_tree(root: Path, patterns: dict[str, dict], p: Problems) -> tuple[dict[str, dict], list[dict], dict[str, dict], list[dict]]:
    """Studies, findings, outreach files and triage entries under `root` (the repo, or templates/examples)."""
    studies = {s["id"]: s for path in sorted(root.glob("studies/*/README.md")) if (s := load_study(path, p)) is not None}
    findings = [f for path in sorted(root.glob("findings/*.md")) if path.name != "README.md"
                if (f := load_finding(path, patterns, studies, p)) is not None]
    triage = [f for path in sorted(root.glob("triage/*.md")) if path.name != "README.md"
              if (f := load_finding(path, patterns, studies, p, pool="triage")) is not None]
    cross_check(findings + triage, p)
    projects = {x for f in findings + triage for x in f["_projects"]}
    outreach = {o["project"]: o for path in sorted(root.glob("outreach/*.md")) if path.name != "README.md"
                if (o := load_outreach(path, projects, p)) is not None}
    return studies, findings, outreach, triage


# ---- views -----------------------------------------------------------------------------------------------------

def money(v) -> str:
    if v is None:
        return ""
    v = float(v)
    return f"${v / 1e9:.1f}B" if v >= 1e9 else f"${v / 1e6:.1f}M" if v >= 1e6 else f"${v / 1e3:.0f}k" if v >= 1e3 else f"${v:.0f}"


def exposure(f) -> tuple[float | None, str]:
    """The finding's measured exposure: summed held/escrow value, else the largest market cap."""
    held = [c.get("value_usd") for c in f["contracts"] + f["families"]
            if c.get("value_usd") is not None and c.get("value_basis") in ("held", "escrow")]
    caps = [c.get("value_usd") for c in f["contracts"] if c.get("value_usd") is not None and c.get("value_basis") == "market-cap"]
    if held:
        return float(sum(held)), "held"
    if caps:
        return float(max(caps)), "market cap"
    return None, ""


def activity(f) -> int:
    return sum(c.get("txs_30d") or 0 for c in f["contracts"])


def upgradeable(f) -> str:
    vals = {c.get("upgradeable") for c in f["contracts"] + f["families"]}
    return "/".join(v for v in UPGRADEABLE if v in vals)


def order(f):
    return (STATUS.index(f["status"]), SEVERITY.index(f["severity"]), -(exposure(f)[0] or 0), f["id"])


def outreach_of(projects: list[str], outreach: dict[str, dict]) -> str:
    seen = {outreach.get(x, {}).get("status") or "not-contacted" for x in projects}
    return "/".join(s for s in OUTREACH if s in seen)


def found_by(f) -> str:
    n = len(f["_studies"])
    return (f"**found by {n}:** " if n > 1 else "") + ", ".join(f["_studies"])


def project_cell(f) -> str:
    return ", ".join(f["_projects"][:3]) + (f" +{len(f['_projects']) - 3}" if len(f["_projects"]) > 3 else "")


def link(f, up="../") -> str:
    return f"[{f['id']}]({up}{f.get('_pool', 'findings')}/{f['id']}.md)"


def table(header: list[str], rows: list[list]) -> list[str]:
    return ["| " + " | ".join(header) + " |", "|" + "---|" * len(header)] + ["| " + " | ".join(str(c) for c in r) + " |" for r in rows] + [""]


def index_md(findings, outreach, pending: int = 0) -> str:
    live = [f for f in findings if f["status"] in LEVELS]
    counts = {s: sum(1 for f in live if f["severity"] == s) for s in SEVERITY}
    lines = [
        "# Findings by severity", "",
        "Generated by `tools/build.py` from the file headers; do not edit. Severity rubric and levels: "
        "`findings/README.md`. Other views: [by class and pattern](PATTERNS.md), [by study](STUDIES.md).", "",
        "Live findings: " + ", ".join(f"{s} {counts[s]}" for s in SEVERITY if counts[s]) + ". "
        + ", ".join(f"{lvl.capitalize()} {sum(1 for f in live if f['status'] == lvl)}" for lvl in LEVELS)
        + f". Not affected {sum(1 for f in findings if f['status'] == 'not-affected')}. Contracts covered "
        f"{sum(len(f['contracts']) for f in live)}. Found by two or more studies: "
        f"{sum(1 for f in live if len(f['_studies']) > 1)}. Not yet reviewed: {pending} in the [triage pool](TRIAGE.md).", "",
    ]
    for sev in SEVERITY:
        rows = sorted((f for f in live if f["severity"] == sev), key=order)
        if not rows:
            continue
        lines += [f"## {sev}", ""]
        lines += table(
            ["Finding", "Project", "Patterns", "Trigger", "Impact", "Alternative", "Upgradeable", "Fix", "Protocol change",
             "Exposure", "30-day txs", "Level", "Found by", "Outreach"],
            [[link(f), project_cell(f), ", ".join(f["patterns"]), f.get("trigger") or "", f.get("impact") or "",
              f.get("alternative") or "", upgradeable(f), f["fix"].get("layer") or "", f["fix"].get("protocol_change") or "",
              money(exposure(f)[0]) + (" (market cap)" if exposure(f)[1] == "market cap" else ""), f"{activity(f):,}",
              f["status"], found_by(f), outreach_of(f["_projects"], outreach)] for f in rows])
    rest = sorted((f for f in findings if f["status"] not in LEVELS), key=lambda f: f["id"])
    if rest:
        lines += ["## Not affected or duplicate", ""]
        lines += table(["Finding", "Project", "Status", "Why"], [[link(f), project_cell(f), f["status"], f["title"]] for f in rest])
    return "\n".join(lines)


def patterns_md(findings, classes, patterns, outreach) -> str:
    live = [f for f in findings if f["status"] in LEVELS]
    lines = ["# Findings by class and pattern", "",
             "Generated by `tools/build.py`; do not edit. Classes and patterns are defined in [`patterns.md`](../patterns.md). "
             "A finding with several patterns is listed under each.", ""]
    lines += table(["Class", "Patterns", "Findings"] + list(SEVERITY[:4]),
                   [[c, sum(1 for x in patterns.values() if x["class"] == c), sum(1 for f in live if f["_class"] == c)]
                    + [sum(1 for f in live if f["_class"] == c and f["severity"] == s) for s in SEVERITY[:4]] for c in classes])
    for c in classes:
        lines += [f"## {c}", ""]
        mine = {pid: x for pid, x in patterns.items() if x["class"] == c}
        if not mine:
            lines += ["No patterns yet.", ""]
        for pid, x in mine.items():
            rows = sorted((f for f in live if pid in f["patterns"]), key=order)
            lines += [f"### {pid}: {x['title']}", ""]
            lines += table(["Finding", "Severity", "Level", "Project", "Found by", "Outreach"],
                           [[link(f), f["severity"], f["status"], project_cell(f), found_by(f),
                             outreach_of(f["_projects"], outreach)] for f in rows]) if rows else ["No findings yet.", ""]
    return "\n".join(lines)


def studies_md(findings, studies) -> str:
    mine = {sid: sorted((f for f in findings if sid in f["_studies"]), key=order) for sid in studies}
    lines = ["# Findings by study", "",
             "Generated by `tools/build.py`; do not edit. A study says how something was investigated; its folder is "
             "linked in each heading. A finding found by several studies is listed under each.", ""]
    lines += table(["Study", "Status", "Topic", "Authors", "Findings"] + [lvl.capitalize() for lvl in LEVELS],
                   [[f"[{sid}](#{sid})", s.get("status"), s.get("topic"), ", ".join(s["authors"]), len(mine[sid])]
                    + [sum(1 for f in mine[sid] if f["status"] == lvl) for lvl in LEVELS] for sid, s in studies.items()])
    for sid, s in studies.items():
        lines += [f"## {sid}", "", f"[{s.get('title')}](../studies/{sid}/README.md)", ""]
        lines += table(["Finding", "Severity", "Level", "Also found by"],
                       [[link(f), f["severity"], f["status"], ", ".join(x for x in f["_studies"] if x != sid)]
                        for f in mine[sid]]) if mine[sid] else ["No findings.", ""]
    return "\n".join(lines)


def to_csv(header, rows) -> str:
    buf = io.StringIO()
    w = csv.writer(buf, lineterminator="\n")
    w.writerow(header)
    w.writerows(rows)
    return buf.getvalue()


def findings_csv(findings, outreach) -> str:
    header = ["id", "project", "status", "severity", "patterns", "primitives", "trigger", "impact", "alternative", "role",
              "upgradeable", "fix_layer", "protocol_change", "who_acts", "exposure_usd", "exposure_basis", "txs_30d",
              "contracts", "evidence_level", "title", "class", "studies", "n_studies", "outreach"]
    rows = []
    for f in sorted(findings, key=order):
        v, basis = exposure(f)
        rows.append([f["id"], " ".join(f["_projects"]), f["status"], f["severity"], " ".join(f["patterns"]),
                     " ".join(f.get("primitives") or []), f.get("trigger") or "", f.get("impact") or "",
                     f.get("alternative") or "", f.get("role") or "", upgradeable(f), f["fix"].get("layer") or "",
                     f["fix"].get("protocol_change") or "", f["fix"].get("who_acts") or "", "" if v is None else round(v),
                     basis, activity(f), len(f["contracts"]), f["evidence"].get("level") or "", f["title"],
                     f["_class"] or "", " ".join(f["_studies"]), len(f["_studies"]), outreach_of(f["_projects"], outreach)])
    return to_csv(header, rows)


def contracts_csv(findings, outreach) -> str:
    header = ["address", "finding", "severity", "status", "name", "implementation", "upgradeable", "admin", "value_usd",
              "value_basis", "value_as_of", "last_active", "txs_30d", "project", "outreach"]
    rows = []
    for f in sorted(findings, key=order):
        for c in f["contracts"]:
            project = c.get("project") or f.get("project") or ""
            rows.append([c["address"], f["id"], f["severity"], f["status"], c.get("name") or "", c.get("implementation") or "",
                         c.get("upgradeable") or "", c.get("admin") or "", "" if c.get("value_usd") is None else round(c["value_usd"]),
                         c.get("value_basis") or "", c.get("value_as_of") or "", c.get("last_active") or "",
                         "" if c.get("txs_30d") is None else c["txs_30d"], project, outreach_of([project], outreach) if project else ""])
    return to_csv(header, rows)


def studies_csv(findings, studies) -> str:
    header = ["id", "title", "authors", "status", "topic", "started", "published", "code", "spec_commit", "findings"] + list(LEVELS)
    rows = []
    for sid, s in studies.items():
        mine = [f for f in findings if sid in f["_studies"]]
        rows.append([sid, s.get("title"), " ".join(s["authors"]), s.get("status"), s.get("topic"), s.get("started") or "",
                     s.get("published") or "", "none" if s.get("code") == "none" else " ".join(s.get("code") or []),
                     (s.get("spec") or {}).get("commit", ""), len(mine)] + [sum(1 for f in mine if f["status"] == lvl) for lvl in LEVELS])
    return to_csv(header, rows)


def proposed(f) -> str:
    """The rating a triage entry proposes: its own severity, else the first rating a source gave."""
    rated = [f["severity"]] + [s.get("rating") for s in f["sources"]]
    return next((r for r in rated if r in SEVERITY and r != "UNRATED"), "UNRATED")


def verdicts(f, v) -> list[dict]:
    return [r for r in f["reviews"] if isinstance(r, dict) and r.get("verdict") == v]


def addresses_of(f) -> int:
    """Addresses an entry covers: one per contract row, or its `copies`, plus the instances of its families."""
    return sum(c.get("copies") or 1 for c in f["contracts"]) + sum(fam.get("instances") or 0 for fam in f["families"])


def recoveries_of(f) -> int:
    return sum(c.get("recoveries_14d") or 0 for c in f["contracts"])


def rows_by_rating(f) -> str:
    """How many of an entry's rows sit at each rating, most severe first ("HIGH 12, LOW 300")."""
    n = {}
    for c in f["contracts"]:
        r = c.get("rating") or f["severity"]
        n[r] = n.get(r, 0) + 1
    return ", ".join(f"{r} {n[r]:,}" for r in SEVERITY if r in n)


def triage_md(triage) -> str:
    live = sorted((f for f in triage if f["status"] != "discarded"),
                  key=lambda f: (SEVERITY.index(proposed(f)), -(exposure(f)[0] or 0), -recoveries_of(f), f["id"]))
    lines = ["# Triage pool", "",
             "Generated by `tools/build.py`; do not edit. Entries nobody but their reporter has checked yet; how to review "
             "them: `triage/README.md`. Each row has its own rating; an entry is sorted by its highest row, exposure, then "
             "recoveries in the study's two-week window. [triage.csv](triage.csv) has the same entries; "
             "[triage_contracts.csv](triage_contracts.csv) has every row, by value held, then by recoveries.", ""]
    lines += table(["Entry", "Patterns", "Rows by rating", "Addresses", "Exposure", "Recoveries (14 d)", "Level", "Found by",
                    "Reviews"],
                   [[link(f), ", ".join(f["patterns"]), rows_by_rating(f), f"{addresses_of(f):,}",
                     money(exposure(f)[0]), f"{recoveries_of(f):,}", f["status"], found_by(f),
                     f"{len(verdicts(f, 'confirmed'))} confirmed, {len(verdicts(f, 'refuted'))} refuted"] for f in live])
    gone = sorted((f for f in triage if f["status"] == "discarded"), key=lambda f: f["id"])
    if gone:
        lines += ["## Discarded", ""]
        lines += table(["Entry", "By", "Why"], [[link(f), ", ".join(str(r["who"]) for r in verdicts(f, "refuted")),
                                                 "; ".join(str(r.get("note") or "") for r in verdicts(f, "refuted"))] for f in gone])
    return "\n".join(lines)


def triage_csv(triage) -> str:
    header = ["id", "project", "status", "proposed_rating", "patterns", "rows", "addresses", "exposure_usd", "exposure_basis",
              "recoveries_14d", "txs_30d", "evidence_level", "title", "class", "studies", "reviews_confirmed", "reviews_refuted"]
    rows = []
    for f in sorted(triage, key=lambda f: (f["status"] == "discarded", SEVERITY.index(proposed(f)), -(exposure(f)[0] or 0), f["id"])):
        v, basis = exposure(f)
        rows.append([f["id"], " ".join(f["_projects"]), f["status"], proposed(f), " ".join(f["patterns"]), len(f["contracts"]),
                     addresses_of(f), "" if v is None else round(v), basis, recoveries_of(f), activity(f),
                     f["evidence"].get("level") or "", f["title"], f["_class"] or "", " ".join(f["_studies"]),
                     len(verdicts(f, "confirmed")), len(verdicts(f, "refuted"))])
    return to_csv(header, rows)


def triage_contracts_csv(triage) -> str:
    """Every contract row of the triage pool, by value held, then by recoveries in the window: the priority order.
    Search it for an address."""
    header = ["address", "entry", "entry_status", "rating", "patterns", "family", "copies", "name", "label", "project",
              "upgradeable", "value_usd", "value_basis", "value_as_of", "recoveries_14d", "note"]
    rows = []
    for f in triage:
        for c in f["contracts"]:
            rows.append([c.get("address"), f["id"], f["status"], c.get("rating") or f["severity"], " ".join(f["patterns"]),
                         c.get("family") or "", c.get("copies") or 1, c.get("name") or "", c.get("label") or "",
                         c.get("project") or f.get("project") or "", c.get("upgradeable") or "",
                         "" if c.get("value_usd") is None else round(c["value_usd"]), c.get("value_basis") or "",
                         c.get("value_as_of") or "", c.get("recoveries_14d") or 0, c.get("note") or ""])
    rows.sort(key=lambda r: (-(r[11] or 0), -r[14], r[0] or "", r[1]))
    return to_csv(header, rows)


def label_owner(label: str) -> str:
    """The organisation a public tag names: "Amina Deposit: 0x…" -> "Amina Deposit"; "deployed by Pimlico: Bundler 4" -> "Pimlico"."""
    return re.sub(r"^(deployed|created) by ", "", label).split(":")[0].strip()


def by_project(findings, triage) -> dict[str, dict]:
    """Every project named by a live finding or a pending triage entry: its entries, contracts and exposure."""
    out: dict[str, dict] = {}
    entries = [f for f in findings if f["status"] in LEVELS] + [f for f in triage if f["status"] != "discarded"]
    for f in entries:
        for proj in f["_projects"]:
            d = out.setdefault(proj, {"findings": [], "triage": [], "held": {}})
            d["triage" if f["_pool"] == "triage" else "findings"].append(f)
            rows = [c for c in f["contracts"] if (c.get("project") or f.get("project")) == proj]
            rows += f["families"] if f.get("project") == proj else []
            for c in rows:
                if c.get("value_usd") is not None and c.get("value_basis") in ("held", "escrow"):
                    key = c.get("address") or c.get("code")
                    d["held"][key] = max(d["held"].get(key, 0), float(c["value_usd"]))
    return out


def worst(fs, rate) -> str:
    return min((rate(f) for f in fs), key=SEVERITY.index, default="")


def projects_rows(findings, triage, outreach):
    rows = []
    for proj, d in by_project(findings, triage).items():
        rows.append([proj, outreach_of([proj], outreach), worst(d["findings"], lambda f: f["severity"]),
                     worst(d["triage"], proposed), len(d["findings"]), len(d["triage"]), round(sum(d["held"].values())),
                     " ".join(f["id"] for f in d["findings"] + d["triage"]), d])
    key = lambda r: (min(SEVERITY.index(x) for x in (r[2] or "UNRATED", r[3] or "UNRATED")), -r[6], r[0])
    return sorted(rows, key=key)


def projects_md(findings, triage, outreach) -> str:
    lines = ["# Findings by project", "",
             "Generated by `tools/build.py`; do not edit. One row per project (the team that has to act), for outreach: its "
             "reviewed findings and its entries still in triage. Exposure counts each contract once. "
             "[projects.csv](projects.csv) has the same rows.", ""]
    lines += table(["Project", "Outreach", "Worst finding", "Worst in triage", "Exposure", "Entries"],
                   [[r[0], r[1], r[2], r[3], money(r[6] or None),
                     ", ".join(link(f) for f in r[8]["findings"] + r[8]["triage"])] for r in projects_rows(findings, triage, outreach)])
    owners: dict[str, dict] = {}
    for f in [f for f in findings if f["status"] in LEVELS] + [f for f in triage if f["status"] != "discarded"]:
        for c in f["contracts"]:
            if c.get("project") or f.get("project") or not c.get("label"):
                continue
            d = owners.setdefault(label_owner(c["label"]), {"rows": 0, "worst": "UNRATED", "held": 0.0, "entries": {}})
            d["rows"] += 1
            d["worst"] = min(d["worst"], c.get("rating") or f["severity"], key=SEVERITY.index)
            d["held"] += float(c.get("value_usd") or 0) if c.get("value_basis") in ("held", "escrow") else 0
            d["entries"][f["id"]] = f
    if owners:
        lines += ["## Rows with no project, by public tag (unverified)", "",
                  "A tag from a block explorer is a lead for outreach, never a name: it can be wrong or stale.", ""]
        lines += table(["Tag owner", "Rows", "Worst rating", "Exposure", "Entries"],
                       [[k, d["rows"], d["worst"], money(d["held"] or None), ", ".join(link(f) for f in d["entries"].values())]
                        for k, d in sorted(owners.items(), key=lambda kv: (SEVERITY.index(kv[1]["worst"]), -kv[1]["held"], kv[0]))])
    return "\n".join(lines)


def projects_csv(findings, triage, outreach) -> str:
    header = ["project", "outreach", "worst_finding", "worst_triage", "findings", "triage", "exposure_usd", "ids"]
    return to_csv(header, [r[:8] for r in projects_rows(findings, triage, outreach)])


# ---- self-test ---------------------------------------------------------------------------------------------------

def selftest(patterns: dict[str, dict]) -> list[str]:
    """Mutate copies of templates/examples and require the expected complaint, or none. Returns what went wrong."""
    def run(change=None, extra: dict[str, str] | None = None, pats=None):
        """Problems and findings (by id) of a mutated copy of the examples."""
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "x"
            shutil.copytree(EXAMPLES, root)
            for name, text in (extra or {}).items():
                (root / name).parent.mkdir(parents=True, exist_ok=True)
                (root / name).write_text(text, encoding="utf-8")
            if change:
                path, old, new = change
                text = (root / path).read_text(encoding="utf-8")
                assert old in text, f"selftest is out of date: {old!r} not in {path}"
                (root / path).write_text(text.replace(old, new), encoding="utf-8")
            p = Problems()
            _, findings, _, triage = load_tree(root, pats or patterns, p)
            return p, {f["id"]: f for f in findings + triage}

    repro, conf, cand = "findings/example-reproduced.md", "findings/example-confirmed.md", "findings/example-candidate.md"
    study = "studies/example-study/README.md"
    twin = (EXAMPLES / conf).read_text(encoding="utf-8").replace("id: example-confirmed", "id: example-twin")
    orphan = (EXAMPLES / "outreach/example-project.md").read_text(encoding="utf-8").replace("project: example-project", "project: nobody")
    cases = [
        ("examples as they are", {}, None),
        ("reproduced without a command", {"change": (repro, "  command:", "  kommand:")}, "repro.command missing"),
        ("reproduced without a pinned code link", {"change": (repro, "/tree/0123456789abcdef0123456789abcdef01234567", "/tree/main")}, "repro.code"),
        ("reproduced without an expected result", {"change": (repro, "  expect:", "  expekt:")}, "repro.expect missing"),
        ("reproduced without inputs", {"change": (repro, "  inputs:", "  inputz:")}, "repro.inputs needs a block or a tx"),
        ("confirmed without a block", {"change": (conf, "  block:", "  blok:")}, "evidence.block is required"),
        ("a source naming an unknown study", {"change": (conf, "study: example-study", "study: nowhere")}, "is not a folder in studies/"),
        ("same contract and same pattern in two findings", {"extra": {"findings/example-twin.md": twin}}, "that is a duplicate"),
        ("same contract under another pattern", {"extra": {"findings/example-twin.md": twin.replace("patterns: [PQ-4]", "patterns: [PQ-5]")}}, None),
        ("two issues of one pattern on one contract, naming each other",
         {"change": (conf, "related: []", "related: [example-twin]"),
          "extra": {"findings/example-twin.md": twin.replace("related: []", "related: [example-confirmed]")}}, None),
        ("one situation across projects, a project on every contract row", {"extra": {"findings/example-situation.md": SITUATION}}, None),
        ("a candidate with only the minimum", {"extra": {"findings/example-minimal.md": MINIMAL}}, None),
        ("a candidate without a reporter", {"extra": {"findings/example-minimal.md": MINIMAL.replace("  who: someone\n", "")}}, "who missing"),
        ("a triage entry with only the minimum", {"extra": {"triage/example-project-pending.md": PENDING}}, None),
        ("a triage entry whose id does not start with its project",
         {"extra": {"triage/example-pending.md": PENDING.replace("id: example-project-pending", "id: example-pending")}},
         "id must be <project>-<mechanism>"),
        ("a triage entry that repeats a finding", {"extra": {"triage/example-twin.md": twin}}, "that is a duplicate"),
        ("the same id in findings/ and triage/", {"extra": {"triage/example-confirmed.md": (EXAMPLES / conf).read_text(encoding="utf-8")}},
         "move the file, do not copy it"),
        ("discarded without a refuting review", {"extra": {"triage/example-project-pending.md": PENDING.replace("status: candidate", "status: discarded")}},
         "discarded needs a review"),
        ("discarded with a refuting review", {"extra": {"triage/example-project-pending.md": DISCARDED}}, None),
        ("discarded in findings/", {"extra": {"findings/example-minimal.md": MINIMAL.replace("status: candidate", "status: discarded")}},
         "discarded entries stay in triage/"),
        ("a root-issue entry whose rows have no project", {"extra": {"triage/example-root-issue.md": ROOT_ISSUE}}, None),
        ("a root-issue entry rated below its worst row",
         {"extra": {"triage/example-root-issue.md": ROOT_ISSUE.replace("severity: CRITICAL", "severity: HIGH")}}, "must be the worst row rating"),
        ("a row with a rating that does not exist",
         {"extra": {"triage/example-root-issue.md": ROOT_ISSUE.replace("rating: LOW", "rating: SEVERE")}}, "rating='SEVERE' not in"),
        ("an unidentified project in triage",
         {"extra": {"triage/example-root-issue.md": ROOT_ISSUE.replace('label: "Some Exchange: Deposit"', "project: unidentified-1234")}},
         "no `unidentified-*` project"),
        ("outreach for a project no finding names", {"extra": {"outreach/nobody.md": orphan}}, "no finding names this project"),
        ("outreach status without a log line", {"change": ("outreach/example-project.md", "- 2026-", "- undated ")}, "needs at least one dated line"),
        ("a study without Limits", {"change": (study, "## Limits", "## Caveats")}, "sections must be"),
        ("a study whose code link has no commit", {"change": (study, "/tree/0123456789abcdef0123456789abcdef01234567", "/tree/main")}, "full commit hash"),
        ("a finding with side files", {"change": (cand, "sources:", "evidence:\n  links: [x.json]\nsources:")}, "evidence.links is gone"),
    ]
    wrong = []
    for name, kw, expect in cases:
        got, _ = run(**kw)
        if expect is None and got:
            wrong.append(f"{name}: expected no problem, got {got}")
        if expect is not None and not any(expect in g for g in got):
            wrong.append(f"{name}: expected a problem containing {expect!r}, got {got}")

    # a finding that two studies found is marked
    second = (EXAMPLES / study).read_text(encoding="utf-8").replace("id: example-study", "id: example-second")
    one = "sources:\n- by: other\n  study: example-study"
    two = "sources:\n- by: other\n  study: example-second\n  who: someone-else\n  date: 2026-11-12\n  verdict: confirmed\n" + one[9:]
    got, found = run(change=(conf, one, two), extra={"studies/example-second/README.md": second})
    if got or not found_by(found["example-confirmed"]).startswith("**found by 2:**"):
        wrong.append(f"found by two studies: {got or found_by(found['example-confirmed'])}")

    # a pull request can add a class and a pattern together with the finding that needs them
    with tempfile.TemporaryDirectory() as tmp:
        extended, p = Path(tmp) / "patterns.md", Problems()
        text = (ROOT / "patterns.md").read_text(encoding="utf-8")
        extended.write_text(text.replace("\n## PQ-1:", "\n- **example-class**: added with its finding.\n\n## PQ-1:", 1)
                            + "\n## PQ-999: A pattern added with its finding\n\n**Class:** example-class\n", encoding="utf-8")
        classes2, patterns2 = load_patterns(p, extended)
    got, found = run(extra={"findings/example-minimal.md": MINIMAL.replace("PQ-4", "PQ-999")}, pats=patterns2)
    if p or got or "example-class" not in classes2 or found["example-minimal"]["_class"] != "example-class":
        wrong.append(f"a new class and pattern: {list(p) + list(got)}")
    return wrong


MINIMAL = """---
id: example-minimal
title: "A claim that somebody still has to check"
status: candidate
patterns: [PQ-4]
project: example-project
contracts:
- address: "0x3333333333333333333333333333333333333333"
sources:
- study: example-study
  who: someone
  date: 2026-11-17
---

## Summary

One paragraph saying what the issue is and why the reporter thinks so.
"""

SITUATION = """---
id: example-situation
title: "One situation that holds across the contracts of several projects"
status: candidate
patterns: [PQ-4]
contracts:
- address: "0x7777777777777777777777777777777777777777"
  project: example-project
- address: "0x8888888888888888888888888888888888888888"
  project: another-project
sources:
- study: example-study
  who: someone
  date: 2026-11-17
---

## Summary

The same issue in two contracts that belong to two projects.
"""

PENDING = """---
id: example-project-pending
title: "A claim in the triage pool that nobody but its reporter has checked"
status: candidate
patterns: [PQ-4]
project: example-project
contracts:
- address: "0x9999999999999999999999999999999999999999"
sources:
- study: example-study
  who: someone
  date: 2026-11-17
---

## Summary

One to three sentences: what, where, why it matters.
"""

DISCARDED = PENDING.replace("status: candidate", "status: discarded").replace("---\n\n## Summary", """reviews:
- who: someone-else
  date: 2026-11-18
  by: other
  verdict: refuted
  note: "the signer check sits behind a code-length test"
---

## Summary""")

ROOT_ISSUE = """---
id: example-root-issue
title: "One root issue across many contracts, one row per code family"
status: candidate
severity: CRITICAL
patterns: [PQ-4]
contracts:
- {address: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", family: "aa11", copies: 12, label: "Some Exchange: Deposit", rating: CRITICAL, value_usd: 1000, value_basis: held, value_as_of: 2026-11-18, recoveries_14d: 3, note: "a signer fixed in the code"}
- {address: "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", family: "bb22", rating: LOW, note: "the key can be replaced"}
sources:
- study: example-study
  who: someone
  date: 2026-11-17
---

## Summary

One sentence on the root issue; the rows say where.
"""


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true", help="check only; write nothing")
    ap.add_argument("--selftest", action="store_true", help="also prove the rules reject what they should")
    args = ap.parse_args()
    p = Problems()
    classes, patterns = load_patterns(p)
    studies, findings, outreach, triage = load_tree(ROOT, patterns, p)
    examples = Problems()
    load_tree(EXAMPLES, patterns, examples)
    p += [f"templates/examples: {x}" for x in examples]
    if args.selftest:
        p += [f"selftest: {x}" for x in selftest(patterns)]
    if p:
        print("\n".join(p))
        print(f"{len(p)} problem(s)")
        return 1
    if not args.check:
        GENERATED.mkdir(exist_ok=True)
        pending = sum(1 for f in triage if f["status"] != "discarded")
        out = {"INDEX.md": index_md(findings, outreach, pending), "PATTERNS.md": patterns_md(findings, classes, patterns, outreach),
               "STUDIES.md": studies_md(findings, studies), "findings.csv": findings_csv(findings, outreach),
               "contracts.csv": contracts_csv(findings, outreach), "studies.csv": studies_csv(findings, studies),
               "TRIAGE.md": triage_md(triage), "triage.csv": triage_csv(triage), "triage_contracts.csv": triage_contracts_csv(triage),
               "PROJECTS.md": projects_md(findings, triage, outreach), "projects.csv": projects_csv(findings, triage, outreach)}
        for name, text in out.items():
            (GENERATED / name).write_text(text, encoding="utf-8")
    print(f"OK: {len(findings)} findings, {len(triage)} in triage, {len(studies)} studies, {len(outreach)} outreach files"
          + (", selftest passed" if args.selftest else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
