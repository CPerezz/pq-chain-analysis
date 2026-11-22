# /// script
# requires-python = ">=3.10"
# dependencies = ["pandas>=2"]
# ///
"""Build the site's data from the studies' result tables and the registry's cards.

  uv run --with pyyaml python board/ingest.py . DB    the cards in SQLite, checked against the files
  uv run tools/site_data.py DB [OUT]                  OUT/data.json and OUT/cards/<xx>.json; OUT defaults to docs

data.json holds the census tables, the hand-classified contracts and, for every card, its severity, title, level and
address, with `finding_of`: address -> card ids (the address users call, and the implementation behind a proxy).
cards/<xx>.json holds the cards themselves, by the first two hex digits of their address, with only what AGENTS.md
lets a reader see: never `admin`, `activity.last`, `primitive`, `checks` or the Reviewer notes.
"""

import json
import math
import sqlite3
import sys
from pathlib import Path

import pandas as pd

TABLES = [
    "t1_categories", "t1_meta", "t2_roles_mutability", "t3_value_by_role", "eth_held_by_role",
    "curated_coverage", "curated_by_function", "curated_by_reliance", "curated_by_upgradeability",
    "curated_by_ecdsa_order", "curated_by_signer", "curated_by_crypto_role", "curated_reliance_x_upgradeability",
    "permit_tokens_market_cap", "lattice_contracts", "l2_tvs_by_state_validation",
]
CONTRACT_COLS = ["address", "protocol", "contract_name", "is_account", "function", "signer", "reliance", "ecdsa_order",
                 "upgradeability", "crypto_role", "admin", "pq_replacement", "evidence", "confidence", "cats",
                 "txs_y1", "usd_tx_y1", "usd_held_now"]
PUBLIC = ("id", "title", "level", "severity", "justification", "category_name", "pattern_words", "study", "as_of", "address",
          "name", "project", "label", "code", "code_url", "proxy_of", "copies", "upgradeable", "value_usd", "value_whose",
          "value_basis", "txs_90d", "impact", "action", "evidence_level", "what_happens", "evidence", "related", "duplicate_of")


def table(name: str) -> Path:
    """A result table by file name, wherever its study keeps it."""
    return next(Path("studies").glob(f"*/results/{name}"))


def clean(v):
    if isinstance(v, float) and (math.isnan(v) or math.isinf(v)):
        return None
    return v


def records(df):
    return [{k: clean(v) for k, v in r.items()} for r in df.to_dict("records")]


def cards(db: str) -> list[dict]:
    con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    con.row_factory = sqlite3.Row
    studies = dict(con.execute("SELECT id, title FROM study").fetchall())
    out = []
    for r in con.execute(f"SELECT {', '.join(PUBLIC)} FROM finding ORDER BY sev_rank, id"):
        c = {k: r[k] for k in PUBLIC if r[k] not in (None, "")}
        if c.get("code") == "decompiled":  # the decompiled file is in the registry, not on the site
            c["code_url"] = f"https://etherscan.io/address/{c.get('proxy_of') or c['address']}#code"
        c["study_title"] = studies.get(c.get("study"))
        out.append(c)
    return out


def main():
    db, out = sys.argv[1], Path(sys.argv[2] if len(sys.argv) > 2 else "docs")
    data = {t: records(pd.read_csv(table(t + ".csv"))) for t in TABLES}
    data["chain_tx_estimate"] = json.load(open(table("chain_tx_estimate.json")))
    cc = pd.read_csv(table("curated_contracts.csv"))[CONTRACT_COLS]
    cc["is_account"] = cc.is_account.astype(str).str.lower() == "true"
    data["contracts"] = records(cc.sort_values("txs_y1", ascending=False, na_position="last"))
    cs = cards(db)
    data["findings"] = {c["id"]: {"severity": c["severity"], "title": c["title"], "level": c["level"], "address": c["address"],
                                  "who": c.get("project") or c.get("label") or c.get("name")} for c in cs}
    data["finding_of"] = {}
    for c in cs:
        for a in dict.fromkeys(x for x in (c["address"], c.get("proxy_of")) if x):
            data["finding_of"].setdefault(a, []).append(c["id"])
    shards: dict[str, dict] = {}
    for c in cs:
        shards.setdefault(c["address"][2:4], {})[c["id"]] = c
    (out / "cards").mkdir(parents=True, exist_ok=True)
    for k, v in shards.items():
        (out / "cards" / f"{k}.json").write_text(json.dumps(v, separators=(",", ":")))
    (out / "data.json").write_text(json.dumps(data, separators=(",", ":")))
    print(f"tables {len(TABLES)}, contracts {len(cc)}, cards {len(cs)} in {len(shards)} files")


if __name__ == "__main__":
    main()
