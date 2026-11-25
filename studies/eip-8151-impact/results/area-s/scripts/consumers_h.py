"""For the cards: which oracles a chain's respected dispute game used at block H, for chains that created games in the
90 days to H, with what the card needs (factory, owner, chain ID, system config, portal, ETH lockbox, standard bridge).
Reads consumers.json (consumers.py). Stdlib only; run next to the node:

    python3 consumers_h.py H consumers.json > consumers_h.json
"""
import json
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor

RPC = "http://127.0.0.1:8545"
CREATED = "0x5b565efe82411da98814f356d0e7bcb8f0219b8d970307c5afb4a6903a8b2e35"
WINDOW = 90 * 7200


def rpc(method, params):
    body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode()
    r = json.loads(urllib.request.urlopen(urllib.request.Request(RPC, body, {"Content-Type": "application/json"}), timeout=300).read())
    if "error" in r:
        raise RuntimeError(r["error"])
    return r["result"]


def call(to, data, at):
    try:
        return rpc("eth_call", [{"to": to, "data": data}, at]) or "0x"
    except RuntimeError:
        return "0x"


def addr(w):
    return "0x" + w[-40:] if w and len(w) >= 42 and int(w[:66], 16) else None


def num(w):
    return int(w[:66], 16) if w and len(w) >= 66 else None


def main():
    h = int(sys.argv[1])
    at = hex(h)
    pairs = json.load(open(sys.argv[2]))
    spans = [(a, min(a + 9_999, h)) for a in range(h - WINDOW, h + 1, 10_000)]
    with ThreadPoolExecutor(4) as ex:
        logs = [l for part in ex.map(lambda s: rpc("eth_getLogs", [{"fromBlock": hex(s[0]), "toBlock": hex(s[1]), "topics": [CREATED]}]), spans) for l in part]
    recent = {}
    for l in logs:
        k = (l["address"].lower(), int(l["topics"][2], 16))
        r = recent.setdefault(k, {"games_90d": 0, "last_game": None})
        r["games_90d"] += 1
        r["last_game"] = "0x" + l["topics"][1][-40:]
    factories = sorted({f for f, _ in recent})
    out = []
    for f in factories:
        games = {t: v for (ff, t), v in recent.items() if ff == f}
        any_game = next(iter(games.values()))["last_game"]
        asr = addr(call(any_game, "0x5c0cba33", at))
        respected = num(call(asr, "0x3c9f397c", at)) if asr else None
        sc = addr(call(asr, "0x33d7e2bd", at)) if asr else None
        portal = addr(call(sc, "0x0a49cb03", at)) if sc else None
        bridge = addr(call(sc, "0x078f29cf", at)) if sc else None
        lockbox = addr(call(portal, "0xb682c444", at)) if portal else None
        impls = {}
        for t in sorted(games):
            impl = addr(call(f, "0x1b685b9e" + "%064x" % t, at))
            # newer factories pass a game's arguments to its clone, so the implementation alone may answer nothing:
            # read them from the last game of that type created before H
            vm = addr(call(games[t]["last_game"], "0x3a768463", at)) or (addr(call(impl, "0x3a768463", at)) if impl else None)
            oracle = addr(call(vm, "0x7dc0d1d0", at)) if vm else None
            code = rpc("eth_getCode", [oracle, at]) if oracle else ""
            impls[t] = {"impl": impl, "vm": vm, "oracle": oracle, "loader": ("ea713950" in code) if oracle else None, **games[t]}
        out.append({"factory": f, "owner": addr(call(f, "0x8da5cb5b", at)), "chain_id": num(call(any_game, "0xd6ae3cd5", at)),
                    "asr": asr, "respected": respected, "system_config": sc, "portal": portal, "lockbox": lockbox,
                    "bridge": bridge, "types": impls})
    print(json.dumps(out))


if __name__ == "__main__":
    main()
