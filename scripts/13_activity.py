"""Recent activity of the hand-classified contracts and their implementations -> data/activity/.

Run on the remote box (reads ~45 GB of Xatu partitions with column projection; 60 MB/s there vs ~0.3 MB/s locally).

Windows
  recent : the last 216 Xatu partitions (216,000 blocks, about 30 days) up to the newest partition every table has.
  gap    : from block 24,700,000 (end of the precompile corpus) to the start of `recent`; scanned only for last-active.

Per target address
  txs_30d          distinct transactions in `recent` where it is the transaction `to` or the `to` of any call frame
  direct_txs_30d   transactions sent straight to it
  usd_30d          sum over those transactions of the largest ERC-20/ETH transfer that touches it (from, to or token),
                   priced with DefiLlama at run time
  last_block       newest block in recent+gap where it was called (transaction or call frame); its timestamp via RPC
Xatu traces do not include calls to precompiles, so precompile use itself stays as measured by the corpus.
"""

import json
import os
import sys
import time
from concurrent.futures import ProcessPoolExecutor

import duckdb
import pandas as pd
import requests

sys.path.insert(0, "scripts")
import rpc  # noqa: E402

BASE = "https://data.ethpandaops.io/xatu/mainnet/databases/default"
TABLES = {"tx": "canonical_execution_transaction", "tr": "canonical_execution_traces",
          "erc20": "canonical_execution_erc20_transfers", "native": "canonical_execution_native_transfers"}
OUT = "data/activity"
RAW = f"{OUT}/raw"
GAP_FROM = 24_700
RECENT = 216


def url(table, p):
    return f"{BASE}/{TABLES[table]}/1000/{p}000.parquet"


def exists(table, p):
    try:
        r = requests.get(url(table, p), headers={"Range": "bytes=0-0"}, timeout=30)
        return r.status_code == 206
    except requests.RequestException:
        return False


def head_partition():
    p = 26_400
    while all(exists(t, p + 1) for t in TABLES):
        p += 1
    return p


QUERIES = {
    "tx": """SELECT block_number, lower(decode(transaction_hash)) tx, lower(decode(to_address)) a, 'tx' kind
             FROM read_parquet('{u}') WHERE lower(decode(to_address)) IN (SELECT a FROM targets)""",
    "tr": """SELECT DISTINCT block_number, lower(decode(transaction_hash)) tx, lower(decode(action_to)) a, 'call' kind
             FROM read_parquet('{u}') WHERE lower(decode(action_to)) IN (SELECT a FROM targets)""",
    "erc20": """SELECT block_number, lower(decode(transaction_hash)) tx, lower(decode(erc20)) token,
                lower(decode(from_address)) f, lower(decode(to_address)) t, value
                FROM read_parquet('{u}')
                WHERE lower(decode(erc20)) IN (SELECT a FROM targets) OR lower(decode(from_address)) IN (SELECT a FROM targets)
                   OR lower(decode(to_address)) IN (SELECT a FROM targets)""",
    "native": """SELECT block_number, lower(decode(transaction_hash)) tx, 'eth' token,
                 lower(decode(from_address)) f, lower(decode(to_address)) t, value
                 FROM read_parquet('{u}')
                 WHERE lower(decode(from_address)) IN (SELECT a FROM targets) OR lower(decode(to_address)) IN (SELECT a FROM targets)""",
}


def work(job):
    table, p, targets = job
    dst = f"{RAW}/{table}/{p}.parquet"
    if os.path.exists(dst):
        return "skip"
    c = duckdb.connect()
    c.sql("LOAD httpfs; SET threads=2")
    c.register("targets", pd.DataFrame({"a": targets}))
    for attempt in range(5):
        try:
            c.sql(f"COPY ({QUERIES[table].format(u=url(table, p))}) TO '{dst}.tmp' (FORMAT parquet)")
            os.replace(dst + ".tmp", dst)
            return "ok"
        except duckdb.Error as e:
            if "404" in str(e):
                return "missing"
            time.sleep(3 + 5 * attempt)
    return "error"


def le_int(b):
    return int.from_bytes(bytes(b)[:32], "little") if b is not None else 0


def main():
    state = json.load(open("data/state/state.json"))["contracts"]
    targets = sorted(set(state) | {d["implementation"] for d in state.values() if d.get("implementation")})
    head = head_partition()
    recent = list(range(head - RECENT + 1, head + 1))
    gap = list(range(GAP_FROM, head - RECENT + 1))
    print("targets", len(targets), "head partition", head, "recent", recent[0], "-", recent[-1], "gap", len(gap), flush=True)
    for t in TABLES:
        os.makedirs(f"{RAW}/{t}", exist_ok=True)
    jobs = [(t, p, targets) for p in recent for t in TABLES] + [(t, p, targets) for p in gap for t in ("tx", "tr")]
    stats = {}
    with ProcessPoolExecutor(48) as ex:
        for i, r in enumerate(ex.map(work, jobs, chunksize=4)):
            stats[r] = stats.get(r, 0) + 1
            if i % 500 == 0:
                print(i, len(jobs), stats, flush=True)
    print("scan done", stats, flush=True)

    c = duckdb.connect()
    calls = c.sql(f"SELECT * FROM read_parquet(['{RAW}/tx/*.parquet', '{RAW}/tr/*.parquet'], union_by_name=true)").df()
    lo = recent[0] * 1000
    last = calls.groupby("a").block_number.max()
    rec = calls[calls.block_number >= lo]
    txs30 = rec.groupby("a").tx.nunique()
    direct30 = rec[rec.kind == "tx"].groupby("a").tx.nunique()

    tr = c.sql(f"SELECT * FROM read_parquet(['{RAW}/erc20/*.parquet', '{RAW}/native/*.parquet'], union_by_name=true)").df()
    tokens = sorted(set(tr.token) - {"eth"})
    prices = {}
    coins = ["coingecko:ethereum"] + [f"ethereum:{t}" for t in tokens]
    for i in range(0, len(coins), 80):
        r = requests.get("https://coins.llama.fi/prices/current/" + ",".join(coins[i:i + 80]), timeout=60).json()
        for k, v in r.get("coins", {}).items():
            if v.get("confidence", 1) >= 0.8:
                prices["eth" if k == "coingecko:ethereum" else k.split(":", 1)[1].lower()] = (v["price"], v.get("decimals", 18))
    tr["usd"] = [le_int(v) / 10 ** prices[t][1] * prices[t][0] if t in prices else 0.0 for v, t in zip(tr.value, tr.token)]
    tr.loc[tr.usd > 5e9, "usd"] = 0.0
    rows = []
    for col in ("f", "t", "token"):
        part = tr[tr[col].isin(targets)][["tx", col, "usd"]].rename(columns={col: "a"})
        rows.append(part)
    touch = pd.concat(rows).groupby(["a", "tx"]).usd.max().groupby("a").sum()

    blocks = sorted({int(b) for b in last.values})
    stamps = {}
    for i in range(0, len(blocks), 40):
        for b in blocks[i:i + 40]:
            stamps[b] = int(rpc._rpc("eth_getBlockByNumber", [hex(b), False])["timestamp"], 16)
    out = {}
    for a in targets:
        b = int(last[a]) if a in last.index else None
        out[a] = {"last_block": b, "last_active": time.strftime("%Y-%m-%d", time.gmtime(stamps[b])) if b else None,
                  "txs_30d": int(txs30.get(a, 0)), "direct_txs_30d": int(direct30.get(a, 0)),
                  "usd_30d": round(float(touch.get(a, 0.0)))}
    end_ts = int(rpc._rpc("eth_getBlockByNumber", [hex(head * 1000 + 999), False])["timestamp"], 16)
    start_ts = int(rpc._rpc("eth_getBlockByNumber", [hex(lo), False])["timestamp"], 16)
    meta = {"recent_blocks": [lo, head * 1000 + 999], "recent_dates": [time.strftime("%Y-%m-%d", time.gmtime(start_ts)),
            time.strftime("%Y-%m-%d", time.gmtime(end_ts))], "gap_from_block": GAP_FROM * 1000,
            "priced_tokens": len(prices), "transfers": len(tr), "scan": stats}
    json.dump({"meta": meta, "contracts": out}, open(f"{OUT}/activity.json", "w"), indent=0)
    print("done", meta)


if __name__ == "__main__":
    main()
