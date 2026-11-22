# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""Where an address already stands in the registry: findings/ and triage/.

    uv run tools/find.py ADDRESS [ADDRESS ...]

Scans the YAML header of every findings/*.md and triage/*.md as raw text (no YAML parsing). One line per hit:
address, folder, id, status, severity (a flow row's own `rating` in a root-issue entry), pattern(s), title.
Exit 1 if an address has no hit.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FIELD = {k: re.compile(rf"^{k}:[ \t]*(.*)$", re.M) for k in ("id", "status", "severity", "title")}
PATTERNS = re.compile(r"^patterns?:[ \t]*(.*)$", re.M)
RATING = re.compile(r"\brating:\s*([A-Za-z]+)")


def field(rx: re.Pattern, head: str) -> str:
    m = rx.search(head)
    return m.group(1).strip().strip("'\"") if m else ""


def scan(addresses: list[str]) -> dict[str, list[dict]]:
    """{address: [{folder, file, id, status, severity, patterns: [..], title}]}; addresses lowercase."""
    want = [a.lower() for a in addresses]
    rx = {a: re.compile(rf'address:\s*"?{a}"?') for a in want}
    hits = {a: [] for a in want}
    for folder in ("findings", "triage"):
        for f in sorted((ROOT / folder).glob("*.md")):
            text = f.read_text(errors="replace")
            end = text.find("\n---\n", 3)  # the header: between the first and the second ---
            head = (text if end < 0 else text[:end]).lower()
            found = [a for a in want if a in head]
            if not found:
                continue
            head = text[: len(head)]  # original case for the fields
            low = head.lower()
            base = {"folder": folder, "file": f.name, "id": field(FIELD["id"], head) or f.stem, "status": field(FIELD["status"], head),
                    "severity": field(FIELD["severity"], head), "patterns": re.findall(r"PQ-\d+", field(PATTERNS, head)), "title": field(FIELD["title"], head)}
            for a in found:
                seen = set()
                for m in rx[a].finditer(low):
                    line = low[low.rfind("\n", 0, m.start()) + 1: (low.find("\n", m.end()) + 1 or len(low) + 1) - 1]
                    r = RATING.search(line) if line.lstrip().startswith("- {") else None
                    sev = r.group(1).upper() if r else base["severity"]
                    if sev not in seen:
                        seen.add(sev)
                        hits[a].append({**base, "severity": sev})
    return hits


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args or any(not re.fullmatch(r"0x[0-9a-fA-F]{40}", a) for a in args):
        sys.exit("usage: find.py 0xADDRESS [0xADDRESS ...]")
    missing = False
    for a, hs in scan(args).items():
        if not hs:
            print(f"{a}\t(no hit)")
            missing = True
        for h in hs:
            print("\t".join([a, h["folder"] + "/", h["id"], h["status"], h["severity"], ",".join(h["patterns"]), h["title"]]))
    sys.exit(1 if missing else 0)
