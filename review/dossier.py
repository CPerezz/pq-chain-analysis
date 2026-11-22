"""Everything an author or a refuter needs about one row, prepared once, so that agents fetch nothing themselves.

    ... -m review.dossier KEY [KEY ...]        writes work/dossier/<address>-<issue>/ and prints the folder

dossier.json    row        what was claimed before (UNTRUSTED: the old finding, triage row or removal)
                facts      what tools/new_finding.py reads at the pinned block: code, proxy, upgradeable, admin, name,
                           verified, value. These go into the finding's header as they are.
                implementation   the same facts for the code behind a proxy, clone or delegation
                scan       LEADS from the study's tables, never verdicts: the scanner's counts for the code, real
                           recoveries in the two-week trace window, replays on the fork engine, proxies that point
                           here, the family's size and value
                signers    the addresses recovered in real transactions, with their code at the pinned block
                use        LEADS about this address's own use before the block: transactions that called it in the
                           90 days before it, the recoveries it made in its latest transactions, and the recoveries a
                           public table holds up to block 24.7M (March 2026), with the addresses recovered
                copies     other addresses that run the same code (up to 25, richest and busiest first); their state
                           can differ from this address's
                dependents addresses whose code holds this address as a constant or calls it: they may rely on it
                notes      where the tool and the study's tables disagree, and what to settle first
source/<address>/…   verified source (Sourcify, else Blockscout) of the address and of the code it runs
decompiled.sol       a decompiler's reading of unverified code (a lead: it can be wrong)

The dossiers of the rows open at the hand-over were built from the study's tables and are in data/dossiers.jsonl.gz,
with the decompiled code in data/decompiled.jsonl.gz. A row added in review gets a dossier read from the node alone
(no study leads). Sources are fetched on first use and kept in work/sources/.
"""

import gzip
import json
import os
import sys
from pathlib import Path

from . import DATA, GATEWAY, H, WORK, key_dir
from .rows import row

os.environ.setdefault("ETH_RPC_URL", f"{GATEWAY}/dossier")
import new_finding as nf  # noqa: E402
import verify  # noqa: E402

_SHIPPED: dict = {}


def shipped(name: str) -> dict:
    if name not in _SHIPPED:
        with gzip.open(DATA / f"{name}.jsonl.gz", "rt") as f:
            _SHIPPED[name] = {x["key"]: x["value"] for x in map(json.loads, f)}
    return _SHIPPED[name]


def write_sources(folder: Path, address: str) -> list[str]:
    files = verify.sources_of(address, WORK / "sources")
    for name, text in files.items():
        p = folder / "source" / address / name.lstrip("/").replace("..", "_")
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)
    return sorted(files)


def fresh(key: str) -> dict:
    """A dossier read from the node alone, for a row added in review."""
    r = row(key)
    a = r["address"]
    facts, log = nf.read_facts(a, H, names=True, valuer=nf.Value(hex(H), nf.block_time(H)[1]))
    d = {"key": key, "block": H, "row": r, "facts": facts, "facts_log": log, "implementation": None, "sources": {}, "decompiled": None,
         "scan": {}, "signers": [], "use": {}, "copies": [], "dependents": [],
         "notes": ["a row added in review: no leads from the study's tables (scan, use, copies); read the code and the chain"]}
    target = facts["proxy_of"] or facts["delegation"]
    if target:
        ifacts, ilog = nf.read_facts(target, H, names=True)
        d["implementation"] = {"address": target, "facts": ifacts, "facts_log": ilog}
    return d


def ensure(key: str) -> Path:
    folder = WORK / "dossier" / key_dir(key)
    path = folder / "dossier.json"
    if not path.exists():
        folder.mkdir(parents=True, exist_ok=True)
        d = shipped("dossiers").get(key) or fresh(key)
        path.write_text(json.dumps(d, indent=1))
    d = json.loads(path.read_text())
    runs = (d.get("implementation") or {}).get("address") or d["row"]["address"]
    for a in {d["row"]["address"], runs}:
        if not (folder / "source" / a).exists() and (d["sources"].get(a) or a not in d["sources"]):
            d["sources"][a] = write_sources(folder, a)
            path.write_text(json.dumps(d, indent=1))
    code_hash = ((d.get("implementation") or {}).get("facts") or d["facts"]).get("code_hash")
    text = shipped("decompiled").get(code_hash) if not d["sources"].get(runs) and code_hash else None
    if text and not (folder / "decompiled.sol").exists():
        (folder / "decompiled.sol").write_text(text)
    return folder


def main():
    for k in sys.argv[1:]:
        try:
            print(ensure(k.strip()), flush=True)
        except Exception as e:
            print(f"FAILED {k}: {type(e).__name__}: {str(e)[:200]}", flush=True)


if __name__ == "__main__":
    main()
