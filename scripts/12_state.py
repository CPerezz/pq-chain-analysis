"""On-chain state of every hand-classified contract at one block -> data/state/state.json.

Run on the remote box (network-bound). Per address:
  code size, proxy kind and implementation (EIP-1967 / beacon / ZeppelinOS / Safe singleton / EIP-1167 / EIP-7702),
  proxy admin and its owner, owner() of the contract, Safe threshold and owner count where the contract or its
  admin is a Safe, ETH balance, and ERC-20 holdings (Blockscout, first 50 tokens, priced).
"""

import json
import os
import sys
import time
from concurrent.futures import ThreadPoolExecutor

import pandas as pd
import requests

sys.path.insert(0, "scripts")
import rpc  # noqa: E402

OUT = "data/state"
SEL = {"owner": "0x8da5cb5b", "threshold": "0xe75235b8", "owners": "0xa0e67e2b", "impl": "0x5c60da1b"}
MAX_SINGLE = 3e10


def call(to, data, block):
    """eth_call; None on revert or missing function (a revert is an answer, not a failure: no retry)."""
    body = {"jsonrpc": "2.0", "id": 1, "method": "eth_call", "params": [{"to": to, "data": data}, block]}
    for attempt in range(6):
        try:
            j = rpc.session.post(rpc.RPCS[0], json=body, timeout=60).json()
        except (requests.RequestException, ValueError):
            time.sleep(1 + attempt)
            continue
        if "result" in j:
            return j["result"]
        err = j.get("error") or {}
        if err.get("code") in (3, -32000, -32015) or "revert" in str(err.get("message", "")).lower():
            return None
        time.sleep(1 + attempt)
    return None


def word_addr(w):
    if not w or len(w) < 42:
        return None
    v = int(w[-64:] if len(w) >= 66 else w[2:], 16)
    return None if v == 0 or v >> 160 else "0x" + w[-40:].lower()


def safe_info(a, block):
    t = call(a, SEL["threshold"], block)
    o = call(a, SEL["owners"], block)
    if not t or t == "0x" or not o or len(o) < 130:
        return None
    try:
        n = int(o[2 + 64:2 + 128], 16)
        owners = ["0x" + o[2 + 128 + 64 * i + 24:2 + 128 + 64 * (i + 1)] for i in range(n)]
        return {"threshold": int(t, 16), "owners": owners}
    except ValueError:
        return None


def holdings(a):
    url = f"https://eth.blockscout.com/api/v2/addresses/{a}/tokens?type=ERC-20"
    for attempt in range(6):
        try:
            r = requests.get(url, timeout=60)
            if r.status_code == 404:
                return 0.0, []
            if r.ok:
                total, top = 0.0, []
                for it in r.json().get("items", []):
                    t = it.get("token") or {}
                    if t.get("reputation") not in (None, "ok") or not t.get("exchange_rate") or t.get("decimals") is None:
                        continue
                    v = int(it["value"]) / 10 ** int(t["decimals"]) * float(t["exchange_rate"])
                    mcap = float(t.get("circulating_market_cap") or 0)
                    if (mcap and v > mcap * 1.05) or v > MAX_SINGLE:
                        continue
                    total += v
                    top.append((t.get("symbol"), round(v)))
                return total, sorted(top, key=lambda x: -x[1])[:5]
        except requests.RequestException:
            pass
        time.sleep(2 + 3 * attempt)
    return None, []


def main():
    targets = sorted(pd.read_csv("data/report/curated_contracts.csv").address.str.lower().unique())
    head = rpc.block_number()
    block = hex(head)
    print("targets", len(targets), "block", head, flush=True)
    slots = rpc.read_slots(targets, block=block)
    codes = rpc.get_codes(targets, block=block)

    st = {}
    for a in targets:
        s, code = slots[a], codes[a]
        h = code.hex()
        d = {"code_size": len(code), "kind": "none", "implementation": None, "admin": None}
        if h.startswith("ef0100") and len(code) == 23:
            d["kind"], d["implementation"] = "eip7702", "0x" + h[6:46]
        elif h.startswith("363d3d373d3d3d363d73"):
            d["kind"], d["implementation"] = "eip1167", "0x" + h[20:60]
        elif word_addr(s["eip1967_impl"]):
            d["kind"], d["implementation"] = "eip1967", word_addr(s["eip1967_impl"])
        elif word_addr(s["eip1967_beacon"]):
            d["kind"], d["beacon"] = "beacon", word_addr(s["eip1967_beacon"])
            d["implementation"] = word_addr(call(d["beacon"], SEL["impl"], block))
        elif word_addr(s["zos_impl"]):
            d["kind"], d["implementation"] = "zos", word_addr(s["zos_impl"])
        elif 0 < len(code) < 1500 and "a619486e" in h and word_addr(s["slot0"]):
            d["kind"], d["implementation"] = "safe_proxy", word_addr(s["slot0"])
        elif len(code) == 0:
            d["kind"] = "no_code"
        d["admin"] = word_addr(s["eip1967_admin"]) or word_addr(s["zos_admin"])
        st[a] = d

    def enrich(a):
        d = st[a]
        d["owner"] = word_addr(call(a, SEL["owner"], block))
        d["safe"] = safe_info(a, block) if d["kind"] == "safe_proxy" else None
        if d["admin"]:
            d["admin_owner"] = word_addr(call(d["admin"], SEL["owner"], block))
        for k in ("admin_owner", "owner", "admin"):
            if d.get(k):
                info = safe_info(d[k], block)
                if info:
                    d["controller_safe"] = {"address": d[k], **info}
                    break
        bal = rpc._rpc("eth_getBalance", [a, block])
        d["eth"] = int(bal, 16) / 1e18
        d["tokens_usd"], d["top_tokens"] = holdings(a)
        return a

    with ThreadPoolExecutor(6) as ex:
        for i, _ in enumerate(ex.map(enrich, targets)):
            if i % 50 == 0:
                print("enriched", i, flush=True)

    eth_usd = requests.get("https://coins.llama.fi/prices/current/coingecko:ethereum", timeout=30).json()["coins"]["coingecko:ethereum"]["price"]
    for d in st.values():
        d["held_usd"] = None if d["tokens_usd"] is None else round(d["tokens_usd"] + d["eth"] * eth_usd)
    os.makedirs(OUT, exist_ok=True)
    meta = {"block": head, "eth_usd": eth_usd, "time": int(time.time())}
    json.dump({"meta": meta, "contracts": st}, open(f"{OUT}/state.json", "w"), indent=0)
    print("done", len(st), "proxies", sum(d["kind"] != "none" for d in st.values()))


if __name__ == "__main__":
    main()
