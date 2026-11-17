# /// script
# requires-python = ">=3.10"
# dependencies = ["pandas>=2"]
# ///
"""Bundle the studies' result tables and generated/*.csv into docs/data.json for the site.

  uv run tools/site_data.py [OUTPUT]    run from the repo root, after tools/build.py; OUTPUT defaults to docs/data.json
"""

import json
import math
import sys
from pathlib import Path

import pandas as pd


def table(name: str) -> Path:
    """A result table by file name, wherever its study keeps it."""
    return next(Path("studies").glob(f"*/results/{name}"))


TABLES = [
    "t1_categories", "t1_meta", "t2_roles_mutability", "t3_value_by_role", "eth_held_by_role",
    "curated_coverage", "curated_by_function", "curated_by_reliance", "curated_by_upgradeability",
    "curated_by_ecdsa_order", "curated_by_signer", "curated_by_crypto_role", "curated_reliance_x_upgradeability",
    "permit_tokens_market_cap", "lattice_contracts", "l2_tvs_by_state_validation",
]
CONTRACT_COLS = ["address", "protocol", "contract_name", "is_account", "function", "signer", "reliance", "ecdsa_order",
                 "upgradeability", "crypto_role", "admin", "pq_replacement", "evidence", "confidence", "cats",
                 "txs_y1", "usd_tx_y1", "usd_held_now"]


def clean(v):
    if isinstance(v, float) and (math.isnan(v) or math.isinf(v)):
        return None
    return v


def records(df):
    return [{k: clean(v) for k, v in r.items()} for r in df.to_dict("records")]


def main():
    out = {t: records(pd.read_csv(table(t + ".csv"))) for t in TABLES}
    out["chain_tx_estimate"] = json.load(open(table("chain_tx_estimate.json")))
    cc = pd.read_csv(table("curated_contracts.csv"))[CONTRACT_COLS]
    cc["is_account"] = cc.is_account.astype(str).str.lower() == "true"
    out["contracts"] = records(cc.sort_values("txs_y1", ascending=False, na_position="last"))
    fi = pd.read_csv("generated/findings.csv")
    out["findings"] = {r.id: {"severity": r.severity, "status": r.status, "title": r.title, "project": r.project}
                       for r in fi.itertuples(index=False)}
    fc = pd.read_csv("generated/contracts.csv")
    out["finding_of"] = {r.address: r.finding for r in fc.itertuples(index=False)}
    with open(sys.argv[1] if len(sys.argv) > 1 else "docs/data.json", "w") as f:
        json.dump(out, f, separators=(",", ":"))
    print("tables", len(TABLES), "contracts", len(cc))


if __name__ == "__main__":
    main()
