"""Trace-free probe for answer-keeping contracts (area S, check S1 generalised).

For a contract and its ABI: call every function that takes an address, with that address set to 0x01 and any bytes
argument set to a valid ecrecover input for a key we hold. The call runs on mainnet state (debug_traceCall, nothing
is sent). A tracer records whether 0x01 was reached with our input, and whether the recovered address then shows up
in storage, logs or the returned data. "stored" or "logged" means the contract keeps an answer that EIP-8151 makes
depend on account code: a candidate for reading. No transaction in history is needed.

    uv run --with coincurve --with pycryptodome python probe.py ADDRESS ABI.json    # one contract
    import probe; probe.run(address, abi)                                            # from other scripts
"""
import json
import os
import sys

import coincurve
from Crypto.Hash import keccak

sys.path.insert(0, os.path.dirname(__file__))
import rpc  # noqa: E402

ONE = "0x" + "00" * 19 + "01"
SENDER = "0x" + "00" * 19 + "aa"
TRACER = """{
  ec: [], st: [], lg: [],
  enter: function(f) { if (toHex(f.getTo()) == '%s') this.ec.push(toHex(f.getInput())); },
  exit: function(r) {},
  step: function(log, db) {
    var op = log.op.toString();
    if (op == 'SSTORE') this.st.push(log.stack.peek(1).toString(16));
    else if (op.indexOf('LOG') == 0) {
      var off = log.stack.peek(0).valueOf(), len = log.stack.peek(1).valueOf();
      this.lg.push(toHex(log.memory.slice(off, off + Math.min(len, 4096))));
    }
  },
  fault: function(log, db) {},
  result: function(ctx, db) { return {ec: this.ec, st: this.st, lg: this.lg, out: toHex(ctx.output), err: ctx.error ? '' + ctx.error : ''}; }
}""" % ONE


def _k(b):
    h = keccak.new(digest_bits=256)
    h.update(b)
    return h.digest()


PRIV = coincurve.PrivateKey(_k(b"pq-chain-analysis area-s probe key"))
SIGNER = _k(PRIV.public_key.format(compressed=False)[1:])[12:].hex()
DIGEST = _k(b"an L2 transaction recovers this")
_sig = PRIV.sign_recoverable(DIGEST, hasher=None)
INPUT = DIGEST + (27 + _sig[64]).to_bytes(32, "big") + _sig[:32] + _sig[32:64]


def _word(x):
    return int(x).to_bytes(32, "big")


def _encode(types, values):
    """Minimal ABI encoding for the argument kinds the probe fills: static words, bytes, and empty arrays."""
    head, tail = [], b""
    base = 32 * len(types)
    for t, v in zip(types, values):
        if t == "bytes" or t == "string" or t.endswith("[]"):
            head.append(_word(base + len(tail)))
            if t.endswith("[]"):
                tail += _word(0)
            else:
                tail += _word(len(v)) + v + b"\0" * (-len(v) % 32)
        else:
            head.append(v)
    return b"".join(head) + tail


def _fill(inp, aim):
    t, name = inp["type"], (inp.get("name") or "").lower()
    if t == "address":
        return bytes(12) + bytes.fromhex((ONE if aim else SENDER)[2:])
    if t in ("bytes", "string"):
        return INPUT
    if t == "bytes32":
        return DIGEST
    if t.startswith("uint") or t.startswith("int"):
        return _word(3000 if "gas" in name else 0)
    if t == "bool":
        return _word(0)
    if t.endswith("[]"):
        return b""
    if t.startswith("bytes"):
        return DIGEST[: int(t[5:])].ljust(32, b"\0")
    return None  # tuples and fixed arrays: not filled


def _parse(line):
    """'function f(uint256 a, address b) view returns (bytes)' → an ABI entry; None for tuples and non-functions."""
    if not line.startswith("function ") or "(" not in line:
        return None
    name, rest = line[9:].split("(", 1)
    params = rest.split(")", 1)[0]
    if "(" in params:
        return None
    ins = [{"type": p.split()[0], "name": (p.split()[-1] if len(p.split()) > 1 else "")} for p in params.split(",") if p.strip()]
    return {"type": "function", "name": name.strip(), "inputs": ins}


def calls(abi):
    """(signature, calldata) for every state-changing or view function with an address argument, one per address
    argument aimed at 0x01."""
    for f in abi:
        if isinstance(f, str):  # L2BEAT discovery keeps ABIs as human-readable strings
            f = _parse(f)
        if not f or f.get("type") != "function":
            continue
        ins = f.get("inputs") or []
        types = [i["type"] for i in ins]
        sig = f"{f['name']}({','.join(types)})"
        for j, i in enumerate(ins):
            if i["type"] != "address":
                continue
            vals = [_fill(x, k == j) for k, x in enumerate(ins)]
            if any(v is None for v in vals):
                break
            yield sig, "0x" + _k(sig.encode())[:4].hex() + _encode(types, vals).hex()


def run(address, abi, block="latest"):
    """One row per probe call: whether 0x01 got our input, and where the recovered address went."""
    out = []
    for sig, data in calls(abi):
        try:
            r = rpc.call("debug_traceCall", [{"from": SENDER, "to": address, "data": data, "gas": hex(5_000_000)}, block,
                                             {"tracer": TRACER, "timeout": "20s"}])
        except RuntimeError as e:
            out.append({"address": address, "function": sig, "error": str(e)[:120]})
            continue
        reached = any(INPUT.hex() in x for x in r["ec"])
        hit = lambda s: SIGNER[:22] in s or SIGNER[18:] in s  # 11 leading or trailing bytes of the address
        out.append({"address": address, "function": sig, "reached": reached,
                    "stored": reached and any(hit(v.rjust(64, "0")) for v in r["st"]),
                    "logged": reached and any(hit(x) for x in r["lg"]),
                    "returned": reached and hit(r["out"]), "reverted": bool(r["err"])})
    return out


if __name__ == "__main__":
    abi = json.load(open(sys.argv[2]))
    for row in run(sys.argv[1].lower(), abi):
        print(json.dumps(row))
