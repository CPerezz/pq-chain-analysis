import json, sys, collections, requests

RPC = "https://ethereum-rpc.publicnode.com"
INBOX = "0x6f21c543a4af5189ebdb0723827577e1ef57ef1f"
PROVED = "0xa274dcaff3629ec7d69d144038e97732516ff306fcbf8a2bc9423d106779a2f0"
FROM, TO = int(sys.argv[1]), int(sys.argv[2])
S = requests.Session()


def rpc(batch):
    for _ in range(5):
        try:
            r = S.post(RPC, json=batch, timeout=120)
            return r.json()
        except Exception as e:  # noqa
            print("retry", e, file=sys.stderr)
    raise SystemExit("rpc failed")


logs = []
b = FROM
while b <= TO:
    for _ in range(5):
        try:
            r = S.get("https://eth.blockscout.com/api", params={
                "module": "logs", "action": "getLogs", "address": INBOX, "topic0": PROVED,
                "fromBlock": b, "toBlock": TO}, timeout=180).json()
            break
        except Exception as e:  # noqa
            print("retry", e, file=sys.stderr)
    res = r.get("result") or []
    logs += res
    if len(res) < 1000:
        break
    b = int(res[-1]["blockNumber"], 16)  # re-read the last block; duplicates removed below
hashes = sorted({l["transactionHash"] for l in logs})


def w(x, i):
    return int.from_bytes(x[i:i + 32], "big")


def dyn(x, off):
    n = w(x, off)
    return x[off + 32:off + 32 + n]


def subs(inp):
    a = inp[4:]
    proof = dyn(a, w(a, 32))
    base = w(proof, 0)
    n = w(proof, base)
    arr = base + 32
    out = []
    for k in range(n):
        t = arr + w(proof, arr + 32 * k)
        out.append((w(proof, t), dyn(proof, t + w(proof, t + 32))))
    return out


combos = collections.Counter()
per_id = collections.Counter()
senders = collections.Counter()
blocks = []
lastb = {}
for i in range(0, len(hashes), 50):
    batch = [{"jsonrpc": "2.0", "id": j, "method": "eth_getTransactionByHash", "params": [h]}
             for j, h in enumerate(hashes[i:i + 50])]
    for r in rpc(batch):
        tx = r["result"]
        blocks.append(int(tx["blockNumber"], 16))
        senders[tx["from"]] += 1
        key = []
        for vid, p in subs(bytes.fromhex(tx["input"][2:])):
            per_id[vid] += 1
            if vid == 6:
                key.append(f"SP1_RETH:{p[64:68].hex()}")
            elif vid == 5:
                key.append(f"RISC0_RETH:{dyn(p, w(p, 0))[:4].hex()}")
            else:
                key.append({1: "SGX_GETH", 4: "SGX_RETH"}.get(vid, str(vid)))
        combos["+".join(key)] += 1
        lastb["+".join(key)] = max(lastb.get("+".join(key), 0), int(tx["blockNumber"], 16))
print(json.dumps({"from_block": FROM, "to_block": TO, "prove_txs": len(hashes),
                  "first_block": min(blocks) if blocks else None, "last_block": max(blocks) if blocks else None,
                  "combinations": combos, "sub_proofs_by_verifier_id": {str(k): v for k, v in per_id.items()},
                  "senders": senders, "last_block_by_combination": lastb}, indent=1))
