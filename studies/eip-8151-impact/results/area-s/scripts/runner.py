"""Sweep runner for check S12, run next to the archive node (stdlib only, resumable).

Input `jobs.jsonl.gz`: one code per line, {"h", "a", "f": [[selector, [types]], ...]}. For every function and every
address parameter, the parameter is aimed at 0x01 and every bytes parameter carries a valid ecrecover input for our
own key. The call runs with debug_traceCall at `latest` (nothing is sent), from the contract's `owner()` when it has
one, else from a plain address. A tracer reports whether 0x01 got our input and whether the recovered address then
reached storage, logs, a hash, another call or the returned data.

    python3 runner.py consts.json jobs.jsonl.gz out.jsonl      # appends; codes already in out.jsonl are skipped
"""
import gzip
import json
import os
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor

RPC = "http://127.0.0.1:8545"
K = json.load(open(sys.argv[1]))
SIG, INPUT, DIGEST, SENDER = K["signer"], K["input"], K["digest"], K["sender"]
ONE = "0" * 39 + "1"
TRACER = """{
  inp: '%s', a: '%s', b: '%s', hit: false, st: false, lg: false, hs: false, fw: false,
  has: function(s) { return s.indexOf(this.a) >= 0 || s.indexOf(this.b) >= 0; },
  enter: function(f) {
    var to = toHex(f.getTo()), i = toHex(f.getInput());
    if (to == '0x0000000000000000000000000000000000000001') { if (i.indexOf(this.inp) >= 0) this.hit = true; return; }
    if (this.hit && this.has(i)) this.fw = true;
  },
  exit: function(r) {},
  step: function(log, db) {
    if (!this.hit) return;
    var op = log.op.toNumber();
    if (op == 0x55) { if (this.has(log.stack.peek(1).toString(16))) this.st = true; }
    else if (op == 0x20 || (op >= 0xa0 && op <= 0xa4)) {
      var off = log.stack.peek(0).valueOf(), len = log.stack.peek(1).valueOf();
      if (len > 0 && len <= 8192 && this.has(toHex(log.memory.slice(off, off + len)))) { if (op == 0x20) this.hs = true; else this.lg = true; }
    }
  },
  fault: function(log, db) {},
  result: function(ctx, db) { return [this.hit, this.st, this.lg, this.hs, this.fw, this.has(toHex(ctx.output)), ctx.error ? 1 : 0]; }
}""" % (INPUT, SIG[2:22], SIG[20:40])
KEYS = ("hit", "st", "lg", "hs", "fw", "out")


def rpc(method, params):
    body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode()
    r = json.loads(urllib.request.urlopen(urllib.request.Request(RPC, body, {"Content-Type": "application/json"}), timeout=60).read())
    return r.get("result"), (r.get("error") or {}).get("message")


def word(n):
    return "%064x" % n


def encode(types, aim):
    head, tail = [], ""
    for j, t in enumerate(types):
        if t.endswith("[]") or t in ("bytes", "string"):
            head.append(None)
            continue
        if t == "address":
            head.append(ONE.rjust(64, "0") if j == aim else SENDER[2:].rjust(64, "0"))
        elif t.startswith("bytes"):
            head.append(DIGEST[: 2 * int(t[5:])].ljust(64, "0"))
        elif t == "uint64":
            head.append(word(100000))
        else:
            head.append(word(0))
    base = 32 * len(types)
    for j, t in enumerate(types):
        if head[j] is None:
            head[j] = word(base + len(tail) // 2)
            tail += word(0) if t.endswith("[]") else word(len(INPUT) // 2) + INPUT
    return "".join(head) + tail


def probe(code, frm, sel, types, aim):
    data = "0x" + sel + encode(types, aim)
    res, err = rpc("debug_traceCall", [{"from": frm, "to": code["a"], "data": data, "gas": hex(5_000_000)}, "latest",
                                       {"tracer": TRACER, "timeout": "5s"}])
    return (sel + "(" + ",".join(types) + ")@" + str(aim)), res, err


def run_code(code):
    try:
        owner, _ = rpc("eth_call", [{"to": code["a"], "data": "0x8da5cb5b"}, "latest"])
    except Exception:
        owner = None
    frm = "0x" + owner[-40:] if owner and len(owner) == 66 and int(owner, 16) and int(owner, 16) < 2 ** 160 else SENDER
    jobs = [(sel, types, j) for sel, types in code["f"] for j, t in enumerate(types) if t == "address"]
    out = {"h": code["h"], "a": code["a"], "from": frm, "calls": len(jobs), "err": 0, "rev": 0, **{k: [] for k in KEYS}}
    for sel, types, aim in jobs:
        try:
            name, res, err = probe(code, frm, sel, types, aim)
        except Exception:
            res, err = None, "exception"
        if err or not isinstance(res, list):
            out["err"] += 1
            continue
        out["rev"] += res[6]
        for k, v in zip(KEYS, res):
            if v:
                out[k].append(name)
    return out


def main():
    done = set()
    if os.path.exists(sys.argv[3]):
        done = {json.loads(l)["h"] for l in open(sys.argv[3]) if l.strip()}
    codes = (json.loads(l) for l in gzip.open(sys.argv[2], "rt"))
    todo = [c for c in codes if c["h"] not in done]
    t0, n = time.time(), 0
    with open(sys.argv[3], "a") as w, ThreadPoolExecutor(4) as ex:
        for i in range(0, len(todo), 2000):
            for out in ex.map(run_code, todo[i:i + 2000]):
                w.write(json.dumps(out) + "\n")
                n += 1
            w.flush()
            print(f"{n} of {len(todo)} codes in {time.time() - t0:.0f}s", flush=True)
    print(f"done: {n} codes in {time.time() - t0:.0f}s", flush=True)


if __name__ == "__main__":
    main()
