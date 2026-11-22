"""The only node address review agents get: one request to the node at a time, state read only at a named block.

    python3 review/gateway.py --upstream ARCHIVE_NODE_URL [--port 8546] [--dir review/work/gateway]

Clients use http://127.0.0.1:8546/<name>; the name is only used for the log (DIR/log/<name>.jsonl).

- One request goes to the node at a time, whoever asks. A batch (at most 20) is answered item by item.
- Allowed: eth_chainId, eth_blockNumber, eth_getBlockByNumber and eth_getBlockByHash, eth_getCode, eth_getBalance,
  eth_getStorageAt, eth_getTransactionCount, eth_call, eth_getTransactionByHash, eth_getTransactionReceipt, and
  eth_getLogs for one address over at most 2,000 blocks. A client named reader-* (the reader who settles rows) may read
  one address and one event topic over at most 10,000 blocks per request (the node's own limit); a log request
  refused to an agent is still answered from the cache, so an agent re-runs the reviewer's `logs` checks without
  scanning itself.
- A state read names its block by number or hash: 'latest' and the other tags are refused, so that every read can be
  repeated.
- Everything else is refused: traces, simulations, filters, sends.
- Answers are kept (DIR/cache.db): a read at a block cannot change. Errors are never kept.

Standard library only. Started once by the reader; see review/README.md.
"""

import argparse
import json
import re
import sqlite3
import threading
import time
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

BLOCK_AT = {"eth_getCode": 1, "eth_getBalance": 1, "eth_getTransactionCount": 1, "eth_getStorageAt": 2, "eth_call": 1}
PLAIN = {"eth_chainId", "eth_blockNumber", "eth_getTransactionByHash", "eth_getTransactionReceipt", "eth_getBlockByHash"}
NUMBER = re.compile(r"^0x[0-9a-fA-F]+$")
MAX_LOG_RANGE, MAX_BATCH, TIMEOUT, REVIEWER_LOG_RANGE = 2000, 20, 60, 10_000
PINNED = hex(26438999)  # a nonce asked for by tag (cast does, before any call) is answered at the study's block
node, db = threading.Lock(), threading.Lock()


def refusal(method: str, params, client: str = "") -> str | None:
    """Why the gateway does not pass this request on, or None."""
    if not isinstance(params, list):
        return "params must be a list"
    if method in PLAIN:
        return None
    if method in BLOCK_AT:
        i = BLOCK_AT[method]
        block = params[i] if len(params) > i else None
        if isinstance(block, dict) and (block.get("blockHash") or NUMBER.match(str(block.get("blockNumber") or ""))):
            return None
        if isinstance(block, str) and NUMBER.match(block):
            return None
        return f"{method}: name the block by number (the finding's pinned block), not {block!r}"
    if method == "eth_getBlockByNumber":
        return None if params and isinstance(params[0], str) and NUMBER.match(params[0]) else "eth_getBlockByNumber: name the block by number"
    if method == "eth_getLogs":
        f = params[0] if params and isinstance(params[0], dict) else {}
        if not f.get("address") or isinstance(f.get("address"), list):
            return "eth_getLogs: one address is required"
        if f.get("blockHash"):
            return None
        a, b = str(f.get("fromBlock") or ""), str(f.get("toBlock") or "")
        span = REVIEWER_LOG_RANGE if client.startswith("reader-") and (f.get("topics") or [None])[0] else MAX_LOG_RANGE
        if not (NUMBER.match(a) and NUMBER.match(b)) or not 0 <= int(b, 16) - int(a, 16) <= span:
            return f"eth_getLogs: fromBlock and toBlock by number, at most {span:,} blocks apart"
        return None
    return f"{method} is not available through the gateway"


class Gateway(BaseHTTPRequestHandler):
    upstream, root, cache = "", Path("."), None

    def log_message(self, *_):  # the per-client log below replaces the default access log
        pass

    def answer(self, client: str, req) -> dict:
        rid = req.get("id") if isinstance(req, dict) else None
        if not isinstance(req, dict) or not isinstance(req.get("method"), str):
            return {"jsonrpc": "2.0", "id": rid, "error": {"code": -32600, "message": "not a JSON-RPC request"}}
        method, params = req["method"], req.get("params", [])
        if method == "eth_getTransactionCount" and isinstance(params, list) and len(params) == 2 and params[1] in ("latest", "pending"):
            params = [params[0], PINNED]
        t0, why = time.time(), refusal(method, params, client)
        key, hit, out = method + " " + json.dumps(params, sort_keys=True), False, None
        if why and method == "eth_getLogs":  # a read the reviewer already made is answered, never scanned again
            with db:
                row = self.cache.execute("SELECT v FROM kv WHERE k = ?", (key,)).fetchone()
            if row:
                why, hit, out = None, True, {"result": json.loads(row[0])}
        if why:
            out = {"error": {"code": -32601, "message": why}}
        elif hit:
            pass
        else:
            with db:
                row = self.cache.execute("SELECT v FROM kv WHERE k = ?", (key,)).fetchone()
            if row and method != "eth_blockNumber":
                hit, out = True, {"result": json.loads(row[0])}
            else:
                try:
                    with node:  # one request to the node at a time
                        body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode()
                        r = urllib.request.Request(self.upstream, body, {"content-type": "application/json"})
                        got = json.loads(urllib.request.urlopen(r, timeout=TIMEOUT).read())
                    out = {"error": got["error"]} if "error" in got else {"result": got.get("result")}
                    if "result" in out and out["result"] is not None and method != "eth_blockNumber":
                        with db:
                            self.cache.execute("INSERT OR REPLACE INTO kv VALUES (?, ?)", (key, json.dumps(out["result"])))
                            self.cache.commit()
                except Exception as e:
                    out = {"error": {"code": -32000, "message": f"the node did not answer: {type(e).__name__}: {str(e)[:120]}"}}
        line = {"t": round(t0, 3), "method": method, "params": json.dumps(params)[:300], "cached": hit, "ms": round((time.time() - t0) * 1000),
                **({"error": out["error"].get("message", "")[:200]} if "error" in out else {})}
        with db:
            with open(self.root / "log" / f"{client}.jsonl", "a") as f:
                f.write(json.dumps(line) + "\n")
        return {"jsonrpc": "2.0", "id": rid, **out}

    def do_POST(self):
        client = re.sub(r"[^A-Za-z0-9._-]", "", self.path.strip("/").split("/")[0])[:48] or "unnamed"
        try:
            req = json.loads(self.rfile.read(int(self.headers.get("content-length") or 0)))
        except Exception:
            req = None
        if isinstance(req, list):
            out = ([self.answer(client, r) for r in req] if len(req) <= MAX_BATCH
                   else {"jsonrpc": "2.0", "id": None, "error": {"code": -32600, "message": f"at most {MAX_BATCH} requests in a batch"}})
        else:
            out = self.answer(client, req)
        body = json.dumps(out).encode()
        self.send_response(200)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        body = b"rpc gateway: POST JSON-RPC to /<your name>\n"
        self.send_response(200)
        self.send_header("content-length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--port", type=int, default=8546)
    ap.add_argument("--upstream", required=True, help="an Ethereum mainnet archive node (state at block 26,438,999)")
    ap.add_argument("--dir", type=Path, default=Path(__file__).resolve().parent / "work" / "gateway")
    args = ap.parse_args()
    (args.dir / "log").mkdir(parents=True, exist_ok=True)
    Gateway.upstream, Gateway.root = args.upstream, args.dir
    Gateway.cache = sqlite3.connect(args.dir / "cache.db", check_same_thread=False)
    Gateway.cache.execute("CREATE TABLE IF NOT EXISTS kv (k TEXT PRIMARY KEY, v TEXT)")
    print(f"rpc gateway on http://127.0.0.1:{args.port}/<name> -> {args.upstream}", flush=True)
    ThreadingHTTPServer(("127.0.0.1", args.port), Gateway).serve_forever()


if __name__ == "__main__":
    main()
