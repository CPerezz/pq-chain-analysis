#!/usr/bin/env python3
"""What the findings' contracts hold: ETH plus every ERC-20 with a reliable USD price, the "ETH value" plus "token
holdings" an explorer shows, for every address behind a finding (its copies and its 7702 accounts too).

Runs on the board's server with a venv (python3 -m venv .venv && .venv/bin/pip install duckdb), step by step; each
step resumes where it stopped. It reads and writes BOARD_DATA (default: data/ beside this file) and works under
vdata/ beside it:

  .venv/bin/python value.py universe       addresses to value: every address of the flagged code families and every
                                           card's address in data/registry.db
  .venv/bin/python value.py discover       the tokens each one ever received: Xatu's erc20 transfers, every partition
  .venv/bin/python value.py prices         prices of the tokens CoinGecko lists on Ethereum: DefiLlama, confidence >= 0.9
  .venv/bin/python value.py balances       ETH and token balances at the chain head: eth_call through Multicall3
  .venv/bin/python value.py publish        data/values.db: value per address and per code family, and the blocks

Two inputs come from the EIP-8151 study's scan, which is not in this repository: vdata/flagged_addresses.parquet and
flagged_codes.parquet (every address of the code families it flagged), and, when it is there, vdata/deployers.csv
(address, deployer, factory, block_number: who sent each address's creating transaction, and the contract that
created it), which publish copies and ingest.py shows on every card.

Not counted, as on an explorer: NFTs, positions in pools and vaults, and tokens without a reliable price. A token
that reached an address without a Transfer event is missed, except WETH (deposits emit none), asked of every address.
"""

from __future__ import annotations

import concurrent.futures as cf
import http.client
import json
import os
import sqlite3
import sys
import threading
import time
import urllib.request
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = Path(os.environ.get("BOARD_DATA", HERE / "data"))  # registry.db in, values.db out
V = DATA.parent / "vdata"                                 # the steps' working files
XATU = "https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000"
RPC = os.environ.get("VALUE_RPC", "https://ethereum-rpc.publicnode.com")
LLAMA = "https://coins.llama.fi/prices/current/"
MC3 = "ca11bde05977b3631167028862be2a173976ca11"
WETH = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
MIN_CONFIDENCE = 0.9
CHUNK = 100  # partitions of 1,000 blocks per discover file


def duck(threads=16, memory_gb=24):
    import duckdb
    c = duckdb.connect()
    c.sql(f"INSTALL httpfs; LOAD httpfs; SET threads={threads}; SET memory_limit='{memory_gb}GB'; "
          f"SET temp_directory='{V}/spill'; SET preserve_insertion_order=false; SET http_retries=8")
    return c


def get(url: str, body: bytes | None = None, tries: int = 8):
    for i in range(tries):
        try:
            req = urllib.request.Request(url, data=body, headers={"User-Agent": "curl/8", "Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=60) as r:
                return json.loads(r.read())
        except Exception as e:  # rate limits and resets: back off and retry
            if i == tries - 1:
                raise
            print(f"  retry {i + 1} ({str(e)[:80]})", flush=True)
            time.sleep(min(60, 2 ** i))


# ---- steps -------------------------------------------------------------------------------------------------------

def universe() -> None:
    c = duck()
    rows = sqlite3.connect(DATA / "registry.db").execute("SELECT DISTINCT lower(address) FROM finding").fetchall()
    c.execute("CREATE TABLE rows (address VARCHAR)")
    c.executemany("INSERT INTO rows VALUES (?)", rows)
    c.sql(f"""COPY (
        SELECT DISTINCT '0x' || lower(hex(a.address)) address, k.family
        FROM read_parquet('{V}/flagged_addresses.parquet') a JOIN read_parquet('{V}/flagged_codes.parquet') k ON k.h = a.f
        UNION SELECT address, NULL FROM rows) TO '{V}/universe.parquet' (FORMAT parquet)""")
    print(c.sql(f"SELECT COUNT(*), COUNT(DISTINCT address), COUNT(DISTINCT family) FROM read_parquet('{V}/universe.parquet')").fetchall())


def last_partition() -> int:
    """The newest erc20 transfers file Xatu has published."""
    head = int(get(RPC, json.dumps({"jsonrpc": "2.0", "id": 1, "method": "eth_blockNumber", "params": []}).encode())["result"], 16)
    p = head // 1000 * 1000
    while p > 0:
        try:
            urllib.request.urlopen(urllib.request.Request(f"{XATU}/{p}.parquet", method="HEAD", headers={"User-Agent": "curl/8"}), timeout=30)
            return p
        except Exception:
            p -= 1000
    raise SystemExit("no partition found")


def discover() -> None:
    out = V / "pairs"
    out.mkdir(exist_ok=True)
    last = last_partition()
    (V / "discover_last.txt").write_text(str(last))
    c = duck()
    c.sql(f"CREATE TABLE u AS SELECT DISTINCT address FROM read_parquet('{V}/universe.parquet')")
    starts = range(0, last + 1, CHUNK * 1000)
    for n, start in enumerate(starts):
        dst = out / f"{start}.parquet"
        if dst.exists():
            continue
        urls = [f"{XATU}/{p}.parquet" for p in range(start, min(start + CHUNK * 1000, last + 1), 1000)]
        t = time.time()
        pick = "SELECT DISTINCT CAST(to_address AS VARCHAR) address, CAST(erc20 AS VARCHAR) token FROM read_parquet({}) " \
               "WHERE CAST(to_address AS VARCHAR) IN (SELECT address FROM u)"
        try:
            c.sql(f"COPY ({pick.format(urls)}) TO '{dst}.tmp' (FORMAT parquet)")
        except Exception as e:  # one unreadable file: read the chunk file by file and name what was skipped
            print(f"  chunk {start:,}: {str(e)[:120]}; file by file", flush=True)
            c.sql("CREATE OR REPLACE TABLE part (address VARCHAR, token VARCHAR)")
            for url in urls:
                try:
                    c.sql(f"INSERT INTO part {pick.format([url])}")
                except Exception as e2:
                    with (V / "discover_skipped.txt").open("a") as f:
                        f.write(f"{url}\t{str(e2)[:200]}\n")
            c.sql(f"COPY (SELECT DISTINCT * FROM part) TO '{dst}.tmp' (FORMAT parquet)")
        os.replace(f"{dst}.tmp", dst)
        print(f"{n + 1}/{len(starts)} partitions {start:,}+ in {time.time() - t:.0f} s", flush=True)
    print(c.sql(f"SELECT COUNT(*), COUNT(DISTINCT token), COUNT(DISTINCT address) FROM read_parquet('{out}/*.parquet')").fetchall())


def prices() -> None:
    """Priced tokens are the ones CoinGecko lists on Ethereum, the scope of an explorer's token values: DefiLlama
    alone also prices LP, vault and debt tokens, some absurdly (an LP token at $9e13 with confidence 0.92, a debt
    token below zero). Everything else counts as zero, as on Etherscan."""
    c = duck()
    listed = V / "coingecko_list.json"
    if not listed.exists():
        with urllib.request.urlopen(urllib.request.Request("https://api.coingecko.com/api/v3/coins/list?include_platform=true",
                                                           headers={"User-Agent": "curl/8"}), timeout=120) as r:
            listed.write_bytes(r.read())
    on_cg = {p.lower() for coin in json.loads(listed.read_text()) for k, p in (coin.get("platforms") or {}).items() if k == "ethereum" and p}
    core = [t["address"].lower() for t in json.loads((V / "core_tokens.json").read_text())["tokens"]]
    seen = {r[0] for r in c.sql(f"SELECT DISTINCT token FROM read_parquet('{V}/pairs/*.parquet')").fetchall()}
    tokens = sorted((seen & on_cg) | set(core))
    path = V / "prices.jsonl"
    done = {json.loads(line)["token"] for line in path.open()} if path.exists() else set()
    todo = [t for t in tokens if t not in done]
    print(f"{len(seen):,} tokens received, {len(tokens):,} listed on CoinGecko, {len(todo):,} to price", flush=True)
    with path.open("a") as f:
        for i in range(0, len(todo), 80):  # one request a second: DefiLlama answers 429 to bursts
            batch = todo[i:i + 80]
            coins = {k.lower(): v for k, v in get(LLAMA + ",".join(f"ethereum:{t}" for t in batch) + "?searchWidth=12h").get("coins", {}).items()}
            f.writelines(json.dumps({"token": t, **{k: coins.get(f"ethereum:{t}", {}).get(k) for k in ("symbol", "decimals", "price", "confidence")}}) + "\n"
                         for t in batch)
            time.sleep(1)
    if not (V / "eth_usd.txt").exists():  # once: the balances are valued at this price
        (V / "eth_usd.txt").write_text(str(get(LLAMA + "coingecko:ethereum")["coins"]["coingecko:ethereum"]["price"]))
    eth = float((V / "eth_usd.txt").read_text())
    rows = [json.loads(line) for line in path.open()]
    good = [r for r in rows if (r.get("price") or 0) > 0 and (r.get("confidence") or 0) >= MIN_CONFIDENCE]
    print(f"priced: {len(good):,} of {len(rows):,} (confidence >= {MIN_CONFIDENCE}); ETH ${eth:,.2f}")
    markets(good, on_cg_ids={p.lower(): coin["id"] for coin in json.loads(listed.read_text())
                             for k, p in (coin.get("platforms") or {}).items() if k == "ethereum" and p})


def markets(good: list[dict], on_cg_ids: dict[str, str]) -> None:
    """CoinGecko's market cap, fully diluted value and price of every priced token, for publish's sanity check:
    a thin market can price an airdropped token far above anything it could be sold for."""
    path = V / "markets.json"
    have = json.loads(path.read_text()) if path.exists() else {}
    ids = sorted({on_cg_ids[r["token"]] for r in good if r["token"] in on_cg_ids} - set(have))
    for i in range(0, len(ids), 250):  # CoinGecko's free API: a request every few seconds, 429 when faster
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&ids=" + ",".join(ids[i:i + 250])
        for coin in get(url):
            have[coin["id"]] = {k: coin.get(k) for k in ("current_price", "market_cap", "fully_diluted_valuation", "total_volume")}
        path.write_text(json.dumps(have))
        time.sleep(8)
    by_token = {t: have.get(i) for t, i in on_cg_ids.items() if i in have}
    (V / "markets_by_token.json").write_text(json.dumps(by_token))
    print(f"markets: {len(have):,} coins, {len(by_token):,} tokens")


def aggregate3(calls: list[tuple[str, bytes]]) -> str:
    """Multicall3.aggregate3 calldata, every call allowed to fail. calls: (target without 0x, calldata)."""
    n = len(calls)
    elems = [bytes(12) + bytes.fromhex(t) + (1).to_bytes(32, "big") + (96).to_bytes(32, "big") + len(d).to_bytes(32, "big")
             + d + bytes(-len(d) % 32) for t, d in calls]
    offsets, pos = [], 32 * n
    for e in elems:
        offsets.append(pos.to_bytes(32, "big"))
        pos += len(e)
    return "0x" + (bytes.fromhex("82ad56cb") + (32).to_bytes(32, "big") + n.to_bytes(32, "big") + b"".join(offsets) + b"".join(elems)).hex()


def results(hexdata: str) -> list[bytes | None]:
    """The (success, returnData)[] of aggregate3: the data, or None for a call that failed."""
    b = bytes.fromhex(hexdata[2:])
    word = lambda i: int.from_bytes(b[i:i + 32], "big")
    base = word(0)
    out = []
    for k in range(word(base)):
        t = base + 32 + word(base + 32 + 32 * k)
        d = t + word(t + 32)
        out.append(b[d + 32:d + 32 + word(d)] if word(t) == 1 else None)
    return out


_conn = threading.local()


def eth_call(data: str, tries: int = 8) -> str:
    """One eth_call at the head, over a kept-alive connection per thread."""
    host = RPC.split("//")[1].split("/")[0]
    body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": "eth_call", "params": [{"to": "0x" + MC3, "data": data}, "latest"]})
    for i in range(tries):
        try:
            if getattr(_conn, "c", None) is None:
                _conn.c = http.client.HTTPSConnection(host, timeout=90)
            _conn.c.request("POST", "/" + RPC.split("//")[1].partition("/")[2], body, {"Content-Type": "application/json", "User-Agent": "curl/8"})
            r = _conn.c.getresponse()
            raw = r.read()
            if r.status != 200:
                raise RuntimeError(f"HTTP {r.status}")
            out = json.loads(raw)
            if "result" not in out:
                raise RuntimeError(str(out.get("error"))[:120])
            return out["result"]
        except Exception as e:
            _conn.c = None
            if i == tries - 1:
                raise
            time.sleep(min(60, 2 ** i))


def head() -> int:
    return int(get(RPC, json.dumps({"jsonrpc": "2.0", "id": 1, "method": "eth_blockNumber", "params": []}).encode())["result"], 16)


def balances() -> None:
    """Work list in a fixed order: ETH of every address, then WETH of every address, then each priced pair."""
    c = duck()
    good = [r["token"] for r in map(json.loads, (V / "prices.jsonl").open()) if (r.get("price") or 0) > 0 and (r.get("confidence") or 0) >= MIN_CONFIDENCE]
    c.execute("CREATE TABLE good (token VARCHAR)")
    c.executemany("INSERT INTO good VALUES (?)", [(t,) for t in good])
    c.sql(f"""CREATE TABLE work AS SELECT row_number() OVER (ORDER BY token, address) - 1 i, token, address FROM (
        SELECT 'eth' token, address FROM (SELECT DISTINCT address FROM read_parquet('{V}/universe.parquet'))
        UNION ALL SELECT '{WETH}', address FROM (SELECT DISTINCT address FROM read_parquet('{V}/universe.parquet'))
        UNION ALL SELECT DISTINCT p.token, p.address FROM read_parquet('{V}/pairs/*.parquet') p JOIN good g USING (token)
                  WHERE p.token != '{WETH}')""")
    total = c.sql("SELECT COUNT(*) FROM work").fetchall()[0][0]
    out = V / "balances"
    out.mkdir(exist_ok=True)
    step = 400
    pages = range(0, total, 200_000)
    blocks = [head()]
    print(f"{total:,} balances to read, head {blocks[0]:,}", flush=True)

    def read(batch) -> list[bytes | None]:
        """One multicall; a call that fails whole is split in two. A gas-hungry balanceOf can starve the calls after
        it, so in a big batch the ones that failed are asked again in batches of 20."""
        calls = [(MC3, bytes.fromhex("4d2301cc") + bytes(12) + bytes.fromhex(a[2:])) if t == "eth"
                 else (t[2:], bytes.fromhex("70a08231") + bytes(12) + bytes.fromhex(a[2:])) for t, a in batch]
        try:
            res = results(eth_call(aggregate3(calls), tries=4))
        except Exception:
            if len(batch) == 1:
                return [None]
            return read(batch[:len(batch) // 2]) + read(batch[len(batch) // 2:])
        failed = [i for i, r in enumerate(res) if r is None]
        if failed and len(batch) > 20:
            again = [x for k in range(0, len(failed), 20) for x in read([batch[i] for i in failed[k:k + 20]])]
            for i, r in zip(failed, again):
                res[i] = r
        return res

    def one(batch):
        return [(t, a, str(int.from_bytes(r[:32], "big"))) for (t, a), r in zip(batch, read(batch)) if r is not None and len(r) >= 32 and any(r[:32])]

    with cf.ThreadPoolExecutor(8) as pool:
        for start in pages:
            dst = out / f"{start:09d}.csv"
            if dst.exists():
                continue
            work = c.sql(f"SELECT token, address FROM work WHERE i >= {start} AND i < {start + 200_000} ORDER BY i").fetchall()
            t0 = time.time()
            found = [x for part in pool.map(one, [work[i:i + step] for i in range(0, len(work), step)]) for x in part]
            with open(f"{dst}.tmp", "w") as f:
                f.writelines(f"{t},{a},{raw}\n" for t, a, raw in found)
            os.replace(f"{dst}.tmp", dst)
            print(f"  {start + len(work):,}/{total:,}: {len(found):,} non-zero, {time.time() - t0:.0f} s", flush=True)
    blocks.append(head())
    (V / "balances_blocks.txt").write_text(f"{blocks[0]} {blocks[1]}")


def publish() -> None:
    c = duck()
    eth_usd = float((V / "eth_usd.txt").read_text())
    first, last = map(int, (V / "balances_blocks.txt").read_text().split())
    c.sql(f"""CREATE TABLE price AS SELECT token, symbol, decimals, price FROM read_json('{V}/prices.jsonl')
              WHERE price > 0 AND confidence >= {MIN_CONFIDENCE}""")
    c.sql(f"CREATE TABLE bal AS SELECT * FROM read_csv('{V}/balances/*.csv', header=false, "
          f"columns={{'token': 'VARCHAR', 'address': 'VARCHAR', 'raw': 'VARCHAR'}})")
    c.sql(f"""CREATE TABLE pos AS
        SELECT b.address, 'eth' token, 'ETH' symbol, CAST(b.raw AS DOUBLE) / 1e18 amount, CAST(b.raw AS DOUBLE) / 1e18 * {eth_usd} usd
        FROM bal b WHERE b.token = 'eth'
        UNION ALL
        SELECT b.address, b.token, coalesce(p.symbol, substr(b.token, 1, 10)), CAST(b.raw AS DOUBLE) / pow(10, coalesce(p.decimals, 18)),
               CAST(b.raw AS DOUBLE) / pow(10, coalesce(p.decimals, 18)) * p.price
        FROM bal b JOIN price p USING (token)""")
    c.sql("DELETE FROM pos WHERE usd < 0.01")
    # Broken data, measured on the first run, is not counted (CoinGecko's market data in vdata/markets_by_token.json):
    #  * a position worth more than ten times all of its token, or over $100B: a balanceOf or decimals that is
    #    broken (NYM at $2e69 in one address);
    #  * a token CoinGecko gives no market cap and trades for less than 0.1 % of what these addresses hold of it in a
    #    day: a thin market priced an airdrop (DHN at $456: $7.2B in 38 accounts; MVT: $4.7B in 21);
    #  * a token whose CoinGecko price is off DefiLlama's by more than half.
    # Exclusions are listed in values.db's meta and on the board's Data quality tab.
    mk = json.loads((V / "markets_by_token.json").read_text())
    c.execute("CREATE TABLE mk (token VARCHAR, cap DOUBLE, fdv DOUBLE, vol DOUBLE, cg_price DOUBLE)")
    c.executemany("INSERT INTO mk VALUES (?, ?, ?, ?, ?)", [(t, m.get("market_cap") or 0, m.get("fully_diluted_valuation") or 0,
                                                           m.get("total_volume") or 0, m.get("current_price")) for t, m in mk.items() if m])
    c.sql("""CREATE TABLE dropped AS SELECT p.address, p.token, p.symbol, p.usd FROM pos p LEFT JOIN mk USING (token)
             WHERE p.usd > 1e11 OR (greatest(coalesce(mk.cap, 0), coalesce(mk.fdv, 0)) > 0 AND p.usd > 10 * greatest(mk.cap, mk.fdv))""")
    c.sql("DELETE FROM pos WHERE (address, token) IN (SELECT address, token FROM dropped)")
    c.sql("""CREATE TABLE excluded AS
        SELECT t.token, t.symbol, t.usd held_usd, mk.cap market_cap, mk.vol volume_24h, mk.cg_price, p.price llama_price,
               CASE WHEN mk.cg_price > 0 AND abs(p.price - mk.cg_price) / mk.cg_price > 0.5 THEN 'prices disagree' ELSE 'thin market' END why
        FROM (SELECT token, any_value(symbol) symbol, SUM(usd) usd FROM pos WHERE token != 'eth' GROUP BY 1) t
        JOIN price p USING (token) LEFT JOIN mk USING (token)
        WHERE (coalesce(mk.cap, 0) = 0 AND mk.vol > 0 AND mk.vol < 0.001 * t.usd)
           OR (mk.cg_price > 0 AND abs(p.price - mk.cg_price) / mk.cg_price > 0.5)""")
    c.sql("DELETE FROM pos WHERE token IN (SELECT token FROM excluded)")
    c.sql("""CREATE TABLE addr AS SELECT address, SUM(usd) usd, SUM(usd) FILTER (symbol = 'ETH') usd_eth, COUNT(*) FILTER (symbol != 'ETH') tokens,
                    to_json(list([symbol, round(amount, 6)::VARCHAR, round(usd)::VARCHAR] ORDER BY usd DESC)[1:5]) top
             FROM pos GROUP BY 1""")
    c.sql(f"""CREATE TABLE fam AS
        WITH u AS (SELECT DISTINCT address, family FROM read_parquet('{V}/universe.parquet') WHERE family IS NOT NULL),
             t AS (SELECT u.family, p.symbol, SUM(p.amount) amount, SUM(p.usd) usd FROM u JOIN pos p USING (address) GROUP BY 1, 2),
             tops AS (SELECT family, to_json(list([symbol, round(amount, 6)::VARCHAR, round(usd)::VARCHAR] ORDER BY usd DESC)[1:5]) top
                      FROM t GROUP BY 1),
             agg AS (SELECT u.family, COUNT(*) addresses, COUNT(a.address) with_value, COALESCE(SUM(a.usd), 0) usd,
                            arg_max(u.address, COALESCE(a.usd, 0)) richest, MAX(COALESCE(a.usd, 0)) richest_usd
                     FROM u LEFT JOIN addr a USING (address) GROUP BY 1)
        SELECT agg.*, tops.top FROM agg LEFT JOIN tops USING (family)""")
    dst = DATA / "values.db"
    tmp = Path(f"{dst}.tmp")
    tmp.unlink(missing_ok=True)
    s = sqlite3.connect(tmp)
    s.executescript("""CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT);
        CREATE TABLE address_value (address TEXT PRIMARY KEY, usd REAL, usd_eth REAL, tokens INTEGER, top TEXT);
        CREATE TABLE family_value (family TEXT PRIMARY KEY, addresses INTEGER, with_value INTEGER, usd REAL, richest TEXT, richest_usd REAL, top TEXT);
        CREATE TABLE deployer (address TEXT PRIMARY KEY, deployer TEXT, factory TEXT);
        CREATE TABLE valued (address TEXT PRIMARY KEY);  -- the registry rows' own addresses that were valued""")
    s.executemany("INSERT OR IGNORE INTO valued VALUES (?)", c.sql(f"SELECT DISTINCT address FROM read_parquet('{V}/universe.parquet') WHERE family IS NULL").fetchall())
    s.executemany("INSERT INTO address_value VALUES (?, ?, ?, ?, ?)", c.sql("SELECT address, usd, usd_eth, tokens, top FROM addr").fetchall())
    s.executemany("INSERT INTO family_value VALUES (?, ?, ?, ?, ?, ?, ?)", c.sql("SELECT family, addresses, with_value, usd, richest, richest_usd, top FROM fam").fetchall())
    if (V / "deployers.csv").exists():  # optional: see the module docstring
        s.executemany("INSERT OR IGNORE INTO deployer VALUES (?, ?, ?)", c.sql(
            f"SELECT address, deployer, CASE WHEN factory = deployer THEN NULL ELSE factory END FROM read_csv('{V}/deployers.csv', header=true)").fetchall())
    import datetime as dt
    meta = {"block_first": first, "block_last": last, "eth_usd": eth_usd, "min_confidence": MIN_CONFIDENCE,
            "priced_tokens": c.sql("SELECT COUNT(*) FROM price").fetchall()[0][0],
            "addresses": c.sql(f"SELECT COUNT(DISTINCT address) FROM read_parquet('{V}/universe.parquet')").fetchall()[0][0],
            "erc20_partitions_to": (V / "discover_last.txt").read_text().strip(),
            "excluded_tokens": json.dumps(c.sql("SELECT symbol, token, round(held_usd), why, round(market_cap), round(volume_24h), cg_price, llama_price "
                                               "FROM excluded ORDER BY held_usd DESC").fetchall()),
            "dropped_positions": json.dumps(c.sql("SELECT symbol, token, COUNT(*), SUM(usd) FROM dropped GROUP BY 1, 2 ORDER BY 4 DESC").fetchall()),
            "largest_tokens": json.dumps(c.sql("SELECT symbol, token, round(SUM(usd)), COUNT(*) FROM pos GROUP BY 1, 2 ORDER BY 3 DESC LIMIT 30").fetchall()),
            "at": dt.datetime.fromtimestamp((V / "balances_blocks.txt").stat().st_mtime, dt.timezone.utc).isoformat(timespec="seconds")}
    s.executemany("INSERT INTO meta VALUES (?, ?)", [(k, str(v)) for k, v in meta.items()])
    s.commit()
    s.close()
    os.replace(tmp, dst)
    print(meta, c.sql("SELECT COUNT(*), SUM(usd) FROM addr").fetchall())


if __name__ == "__main__":
    steps = {"universe": universe, "discover": discover, "prices": prices, "balances": balances, "publish": publish}
    if len(sys.argv) != 2 or sys.argv[1] not in steps:
        sys.exit(__doc__)
    V.mkdir(exist_ok=True)
    steps[sys.argv[1]]()
