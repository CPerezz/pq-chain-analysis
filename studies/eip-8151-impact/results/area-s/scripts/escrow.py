"""What a false root could release, per oracle in use at block H: for every chain whose respected dispute game used
the oracle (consumers_h.json), the ETH and priced tokens held at H by its portal, its ETH lockbox and its standard
bridge, valued the way the registry values a card (tools/new_finding.py's Value). Run from the registry worktree:

    ETH_RPC_URL=… uv run --with … python escrow.py consumers_h.json H > escrow.json
"""
import json
import sys

sys.path.insert(0, "tools")
import new_finding as nf  # noqa: E402

RESPECTED_UNKNOWN_TYPE = 1  # an old anchor registry has no respectedGameType(); these factories created only type 1 games


def main():
    d = json.load(open(sys.argv[1]))
    h = int(sys.argv[2])
    v = nf.Value(hex(h), int(nf.rpc("eth_getBlockByNumber", [hex(h), False])["timestamp"], 16))
    out = {}
    for f in d:
        r = f["respected"] if f["respected"] is not None else RESPECTED_UNKNOWN_TYPE
        t = f["types"].get(str(r))
        if not t or not t["loader"]:
            continue
        held = {}
        for role in ("portal", "lockbox", "bridge"):
            a = f.get(role)
            if a:
                usd, eth, n = v.usd(a)
                held[role] = {"address": a, "usd": round(usd or 0), "eth": eth, "tokens": n}
        o = out.setdefault(t["oracle"], {"chains": []})
        o["chains"].append({"factory": f["factory"], "owner": f["owner"], "chain_id": f["chain_id"], "respected": r,
                            "respected_read": f["respected"] is not None, "game": t["last_game"], "vm": t["vm"],
                            "games_90d": t["games_90d"], "held": held, "usd": sum(x["usd"] for x in held.values())})
    for o in out.values():
        o["usd"] = sum(c["usd"] for c in o["chains"])
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
