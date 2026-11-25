"""JSON-RPC to an archive node (read only): ETH_RPC_URL, default http://127.0.0.1:8545."""
import json
import os
import urllib.request

URL = os.environ.get("ETH_RPC_URL", "http://127.0.0.1:8545")


def call(method, params):
    req = urllib.request.Request(URL, json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode(),
                                 {"Content-Type": "application/json"})
    r = json.loads(urllib.request.urlopen(req, timeout=300).read())
    if "error" in r:
        raise RuntimeError(f"{method}: {r['error']}")
    return r["result"]
