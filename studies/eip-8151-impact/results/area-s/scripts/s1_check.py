"""S1, executed: OP's PreimageOracle stores what L1's 0x01 answers. Load one valid recovery three ways on mainnet
state (eth_simulateV1): today; under EIP-8151 (behaviour wrapper at 0x01) with no code at the signer; and with code
at the signer. Then read back what the oracle stored."""
import os
import sys

import coincurve
from Crypto.Hash import keccak

sys.path.insert(0, os.path.dirname(__file__))
import rpc  # noqa: E402

ONE, MOVED = "0x" + "00" * 19 + "01", "0x00000000000000000000000000000000000ec001"
WRAPPER = ("0x365f803760205f3681620ec0015afa15605c573d1560585760205f803e5f51803b805f146050576017146030575f80f3"
           "5b60175f6020833c62ef010060205160e81c146049575f80f35b5f5260205ff35b505f5260205ff35b5f80f35b5f80f3")


def k(b):
    h = keccak.new(digest_bits=256)
    h.update(b)
    return h.digest()


def sel(sig):
    return k(sig.encode())[:4].hex()


def word(x):
    return (x if isinstance(x, bytes) else int(x).to_bytes(32, "big")).rjust(32, b"\0")


priv = coincurve.PrivateKey(k(b"pq-chain-analysis area-s probe key"))
signer = "0x" + k(priv.public_key.format(compressed=False)[1:])[12:].hex()
digest = k(b"an L2 transaction recovers this")
sig = priv.sign_recoverable(digest, hasher=None)
r, s, v = sig[:32], sig[32:64], 27 + sig[64]
inp = digest + word(v) + r + s  # the 128-byte ecrecover input

block = hex(int(sys.argv[1])) if len(sys.argv) > 1 else "latest"
oracles = sys.argv[2:] or ["0x1e1d73536a081ef2f355d29794547a9770aeb1e0"]
gas = 3000
sender = "0x" + "00" * 19 + "aa"
worlds = {
    "today (no EIP-8151)": {},
    "EIP-8151, signer has no code": {ONE: {"movePrecompileToAddress": MOVED, "code": WRAPPER}},
    "EIP-8151, signer has code": {ONE: {"movePrecompileToAddress": MOVED, "code": WRAPPER}, signer: {"code": "0x60006000fd"}},
}
print(f"block {int(block, 16) if block != 'latest' else block}; signer {signer}; input 0x{inp.hex()}")
for oracle in oracles:
    code = rpc.call("eth_getCode", [oracle, block])
    four = sel("loadPrecompilePreimagePart(uint256,address,uint64,bytes)")
    if four in code:  # newer oracles: the required gas is an argument and part of the key
        load = "0x" + four + (word(0) + word(bytes.fromhex(ONE[2:])) + word(gas) + word(128) + word(len(inp)) + inp).hex()
        key = bytearray(k(bytes.fromhex(ONE[2:]) + gas.to_bytes(8, "big") + inp))
    else:  # older oracles: loadPrecompilePreimagePart(uint256,address,bytes)
        load = "0x" + sel("loadPrecompilePreimagePart(uint256,address,bytes)") + (word(0) + word(bytes.fromhex(ONE[2:])) + word(96) + word(len(inp)) + inp).hex()
        key = bytearray(k(bytes.fromhex(ONE[2:]) + inp))
    key[0] = 6
    read = "0x" + sel("readPreimage(bytes32,uint256)") + (bytes(key) + word(0)).hex()
    length = "0x" + sel("preimageLengths(bytes32)") + bytes(key).hex()
    print(f"\noracle {oracle} ({'4' if four in code else '3'}-argument load); preimage key 0x{bytes(key).hex()}")
    for name, over in worlds.items():
        calls = [{"from": sender, "to": oracle, "data": d, "gas": hex(1_000_000)} for d in (load, read, length)]
        res = rpc.call("eth_simulateV1", [{"blockStateCalls": [{"stateOverrides": over, "calls": calls}], "validation": False}, block])[0]["calls"]
        st = [c["status"] for c in res]
        part, n = res[1]["returnData"], int(res[2]["returnData"], 16) if res[2]["returnData"] not in ("0x", "") else None
        print(f"  {name:32} load status {st[0]}; stored length {n}; part 0: {part[2:66] if len(part) >= 66 else part}")
