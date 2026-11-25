"""Check S11, complete: every dispute game factory on mainnet and what each registered game type answers precompiles
with. Factories come from `ImplementationSet` logs (any emitter, so factories that never created a game are found)
and `DisputeGameCreated` logs. For each (factory, type): the implementation now and at block H, its `vm()`, the VM's
`oracle()`, whether that oracle can load precompile results, the number of games, and the last one. Stdlib only; run
next to the node:

    python3 consumers.py H > consumers.json
"""
import json
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor

RPC = "http://127.0.0.1:8545"
IMPL_SET = "0xff513d80e2c7fa487608f70a618dfbc0cf415699dc69588c747e8c71566c88de"
CREATED = "0x5b565efe82411da98814f356d0e7bcb8f0219b8d970307c5afb4a6903a8b2e35"
START = 18_900_000  # December 2023, before the first mainnet dispute game factory


def rpc(method, params):
    body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode()
    r = json.loads(urllib.request.urlopen(urllib.request.Request(RPC, body, {"Content-Type": "application/json"}), timeout=300).read())
    if "error" in r:
        raise RuntimeError(r["error"])
    return r["result"]


def call(to, data, block="latest"):
    try:
        return rpc("eth_call", [{"to": to, "data": data}, block]) or "0x"
    except RuntimeError:
        return "0x"


def addr(w):
    return "0x" + w[-40:] if w and len(w) >= 42 and int(w, 16) else None


def logs(topic):
    head = int(rpc("eth_blockNumber", []), 16)
    spans = [(a, min(a + 9_999, head)) for a in range(START, head + 1, 10_000)]
    with ThreadPoolExecutor(4) as ex:
        return [l for part in ex.map(lambda s: rpc("eth_getLogs", [{"fromBlock": hex(s[0]), "toBlock": hex(s[1]), "topics": [topic]}]), spans) for l in part]


def describe(impl, block):
    vm = addr(call(impl, "0x3a768463", block)) if impl else None
    oracle = addr(call(vm, "0x7dc0d1d0", block)) if vm else None
    code = rpc("eth_getCode", [oracle, block]) if oracle else ""
    return {"impl": impl, "vm": vm, "oracle": oracle, "loader": ("ea713950" in code) if oracle else None}


def main():
    h = hex(int(sys.argv[1]))
    pairs = {}
    for l in logs(IMPL_SET):
        pairs.setdefault((l["address"].lower(), int(l["topics"][2], 16)), {"set": 0, "games": 0, "last_game": None, "last_block": None})["set"] += 1
    for l in logs(CREATED):
        p = pairs.setdefault((l["address"].lower(), int(l["topics"][2], 16)), {"set": 0, "games": 0, "last_game": None, "last_block": None})
        p["games"] += 1
        p["last_game"], p["last_block"] = "0x" + l["topics"][1][-40:], int(l["blockNumber"], 16)
    out = []
    for (f, t), p in sorted(pairs.items()):
        now = describe(addr(call(f, "0x1b685b9e" + "%064x" % t)), "latest")
        then = describe(addr(call(f, "0x1b685b9e" + "%064x" % t, h)), h)
        last = describe(p["last_game"], "latest") if p["last_game"] else None
        chain = call(p["last_game"] or now["impl"] or f, "0xd6ae3cd5")
        out.append({"factory": f, "type": t, **p, "chain_id": int(chain, 16) if len(chain) == 66 else None,
                    "now": now, "at_h": then, "last": last})
    print(json.dumps(out))


if __name__ == "__main__":
    main()
