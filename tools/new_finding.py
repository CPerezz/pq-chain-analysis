# /// script
# requires-python = ">=3.10"
# dependencies = ["pycryptodome"]
# ///
"""Scaffold one finding at one pinned block: facts read by tools, judgment left for a person or agent to write.

    uv run tools/new_finding.py ADDRESS --pattern PQ-n --study STUDY --issue SLUG --who TEXT [--block N] [--out DIR]
                                 [--txs-90d N] [--last YYYY-MM-DD]

Never hand-type a fact: every value this tool can read, it reads itself, at one block. Node: one request at a
time, 60 s timeout, one retry; never eth_getLogs, never trace_*. Refuses to run if the address is already filed
under the same pattern, or the study/pattern do not exist.
"""

import argparse
import json
import re
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

from Crypto.Hash import keccak

sys.path.insert(0, str(Path(__file__).resolve().parent))
import find  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
TOKENS = json.loads((ROOT / "tools" / "tokens.json").read_text())
STABLE = {"USDT", "USDC", "DAI", "USDS", "USDe", "PYUSD", "FDUSD", "USD1", "USDtb", "crvUSD", "GHO", "FRAX", "LUSD", "TUSD", "USDP", "RLUSD", "USD0"}
MAX_FEED_AGE = 2 * 86400
ZERO32 = "0" * 64
SLOT_1967_IMPL = "360894a13ba1a3210667c828492db98dca3e2076cc3735a8a38e1f2dd5f6f8a2"
SLOT_1967_ADMIN = "b53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103"
SLOT_1967_BEACON = "a3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50"
SLOT_1822 = "c5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
UPGRADE_SELECTORS = {bytes.fromhex("3659cfe6"), bytes.fromhex("4f1ef286"), bytes.fromhex("99a88ec4")}


def sel(sig: str) -> str:
    return keccak.new(digest_bits=256, data=sig.encode()).digest()[:4].hex()


# --- RPC: one request at a time, 60 s timeout, one retry -------------------------------------------------------

def rpc_url() -> str:
    url = __import__("os").environ.get("ETH_RPC_URL")
    if not url:
        sys.exit("ETH_RPC_URL is not set: point it at the archive node before running this tool.")
    return url


def rpc(method: str, params: list):
    payload = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode()
    last = None
    for attempt in range(2):  # one try, one retry
        try:
            req = urllib.request.Request(rpc_url(), payload, {"content-type": "application/json"})
            r = json.loads(urllib.request.urlopen(req, timeout=60).read())
            if "error" in r:
                raise RuntimeError(f"{method}: {r['error']}")
            return r["result"]
        except Exception as e:
            last = e
            if attempt == 0:
                time.sleep(1)
    raise last


def call(to: str, data: str, at: str) -> bytes | None:
    """eth_call; None on revert (never raises for a revert, since 'no answer' is itself a fact)."""
    try:
        return bytes.fromhex(rpc("eth_call", [{"to": to, "data": "0x" + data}, at])[2:])
    except RuntimeError:
        return None


def http_get(url: str):
    """One external HTTP request, 60 s timeout, one retry. Returns (status, json-or-None)."""
    last = None
    for attempt in range(2):
        try:
            req = urllib.request.Request(url, headers={"accept": "application/json"})
            with urllib.request.urlopen(req, timeout=60) as r:
                return r.status, json.loads(r.read())
        except urllib.error.HTTPError as e:
            return e.code, None
        except Exception as e:
            last = e
            if attempt == 0:
                time.sleep(1)
    raise last


# --- bytecode -----------------------------------------------------------------------------------------------

def opcode_scan(code: bytes) -> tuple[set, bool]:
    """PUSH4 immediates (candidate selectors) and whether DELEGATECALL (0xf4) appears outside push data."""
    push4, delegatecall, i, n = set(), False, 0, len(code)
    while i < n:
        op = code[i]
        if 0x60 <= op <= 0x7f:  # PUSH1..PUSH32
            width = op - 0x5f
            if op == 0x63 and i + 5 <= n:
                push4.add(code[i + 1:i + 5])
            i += 1 + width
            continue
        if op == 0xf4:
            delegatecall = True
        i += 1
    return push4, delegatecall


def addr_from_slot(word: bytes) -> str | None:
    a = word[-20:]
    return "0x" + a.hex() if any(a) else None


def addr_from_call(raw: bytes | None) -> str | None:
    if raw is None or len(raw) < 32:
        return None
    if any(raw[:12]):  # not a clean zero-padded address
        return None
    return addr_from_slot(raw[:32])


# --- Sourcify / Blockscout -----------------------------------------------------------------------------------

def verification(address: str) -> tuple[bool, str]:
    """(verified, name) for one address."""
    try:
        status, body = http_get(f"https://sourcify.dev/server/v2/contract/1/{address}?fields=compilation")
        if status == 200 and body and body.get("match"):
            return True, body.get("compilation", {}).get("name") or ""
    except Exception:
        pass
    try:
        status, body = http_get(f"https://eth.blockscout.com/api/v2/smart-contracts/{address}")
        if status == 200 and body and body.get("is_verified"):
            return True, body.get("name") or ""
    except Exception:
        pass
    return False, ""


# --- value --------------------------------------------------------------------------------------------------

class Value:
    def __init__(self, at: str, now: int):
        self.at, self.now, self.feed_cache = at, now, {}

    def feed_price(self, pair: str) -> float | None:
        if pair in self.feed_cache:
            return self.feed_cache[pair]
        addr = TOKENS["feeds"][pair]
        desc = call(addr, sel("description()"), self.at)
        if desc is None or _text(desc).strip().upper() != pair.upper():
            self.feed_cache[pair] = None
            return None
        dec = call(addr, sel("decimals()"), self.at)
        r = call(addr, sel("latestRoundData()"), self.at)
        if dec is None or r is None or len(r) < 128:
            self.feed_cache[pair] = None
            return None
        answer = int.from_bytes(r[32:64], "big", signed=True)
        updated = int.from_bytes(r[96:128], "big")
        if answer <= 0 or self.now - updated > MAX_FEED_AGE:
            self.feed_cache[pair] = None
            return None
        price = answer / 10 ** int.from_bytes(dec, "big")
        self.feed_cache[pair] = price
        return price

    def price_of(self, symbol: str, spec: dict, done: dict) -> float | None:
        if "feed" in spec:
            price = self.feed_price(spec["feed"])
            if price is None:
                return None
            if "via" in spec:
                p2 = self.feed_price(spec["via"])
                if p2 is None:
                    return None
                price *= p2
        else:
            under = done.get(spec["of"])
            if under is None:
                return None
            addr = spec["address"]
            arg = (10 ** under["decimals"]).to_bytes(32, "big").hex() if "uint256" in spec["rate"] else ""
            raw = call(addr, sel(spec["rate"]) + arg, self.at)
            if raw is None or len(raw) < 32:
                return None
            rate = int.from_bytes(raw[:32], "big") / 10 ** under["decimals"]
            price = rate * under["usd"]
        if symbol in STABLE and not (0.9 <= price <= 1.1):
            return None
        return price

    def usd(self, address: str) -> tuple[float | None, float, int]:
        """(total usd or None, eth held, number of priced tokens held)."""
        eth_usd = self.feed_price("ETH / USD")
        wei = int(rpc("eth_getBalance", [address, self.at]), 16)
        eth = wei / 1e18
        if eth_usd is None:
            return None, eth, 0
        total = eth * eth_usd
        done, held = {}, 0
        for spec in TOKENS["tokens"]:
            symbol, addr = spec["symbol"], spec["address"]
            got_symbol = call(addr, sel("symbol()"), self.at)
            if got_symbol is None or _text(got_symbol).strip().upper() != symbol.upper():
                continue
            dec_raw = call(addr, sel("decimals()"), self.at)
            if dec_raw is None:
                continue
            dec = int.from_bytes(dec_raw, "big")
            price = self.price_of(symbol, spec, done)
            if price is None:
                continue
            done[symbol] = {"decimals": dec, "usd": price}
            bal_raw = call(addr, sel("balanceOf(address)") + "000000000000000000000000" + address[2:], self.at)
            bal = int.from_bytes(bal_raw, "big") if bal_raw else 0
            if bal:
                total += bal / 10 ** dec * price
                held += 1
        return total, eth, held


def _text(raw: bytes) -> str:
    if len(raw) >= 96 and int.from_bytes(raw[:32], "big") == 32:
        n = int.from_bytes(raw[32:64], "big")
        return raw[64:64 + n].decode(errors="replace")
    return raw[:32].rstrip(b"\0").decode(errors="replace")


def fmt_eth(wei_eth: float) -> str:
    return f"{wei_eth:,.2f}"


# --- scaffolding ---------------------------------------------------------------------------------------------

def main():
    p = argparse.ArgumentParser()
    p.add_argument("address")
    p.add_argument("--pattern", required=True)
    p.add_argument("--study", required=True)
    p.add_argument("--issue", required=True)
    p.add_argument("--block", type=int)
    p.add_argument("--who", required=True)
    p.add_argument("--out", default="triage")
    p.add_argument("--txs-90d", type=int)
    p.add_argument("--last")
    args = p.parse_args()

    address = args.address.lower()
    if not re.fullmatch(r"0x[0-9a-f]{40}", address):
        sys.exit(f"not an address: {args.address}")

    if not (ROOT / "studies" / args.study).is_dir():
        sys.exit(f"no such study: studies/{args.study}/")
    if not re.search(rf"^## {re.escape(args.pattern)}:", (ROOT / "patterns.md").read_text(), re.M):
        sys.exit(f"no such pattern: {args.pattern} (patterns.md)")
    hits = find.scan([address])[address]
    dup = [h for h in hits if args.pattern in h["patterns"]]
    if dup:
        sys.exit(f"{address} is already filed under {args.pattern}: {dup[0]['folder']}/{dup[0]['file']}")

    checks: list[str] = []

    # block and as_of
    if args.block is not None:
        block_hex = hex(args.block)
        blk = rpc("eth_getBlockByNumber", [block_hex, False])
        block_no = args.block
    else:
        blk = rpc("eth_getBlockByNumber", ["latest", False])
        block_no = int(blk["number"], 16)
        block_hex = blk["number"]
    timestamp = int(blk["timestamp"], 16)
    as_of = datetime.fromtimestamp(timestamp, tz=timezone.utc).date().isoformat()

    # 1. code
    code_hex = rpc("eth_getCode", [address, block_hex])
    code = bytes.fromhex(code_hex[2:])
    if not code:
        sys.exit(f"{address} has no code at block {block_no:,}")
    is_7702 = len(code) == 23 and code.startswith(b"\xef\x01\x00")
    note = " (a 7702 delegation)" if is_7702 else ""
    checks.append(f"eth_getCode at block {block_no:,}: {len(code):,} bytes{note}")

    # 2. proxy slots
    impl_slot = bytes.fromhex(rpc("eth_getStorageAt", [address, "0x" + SLOT_1967_IMPL, block_hex])[2:].rjust(64, "0"))
    admin_slot = bytes.fromhex(rpc("eth_getStorageAt", [address, "0x" + SLOT_1967_ADMIN, block_hex])[2:].rjust(64, "0"))
    beacon_slot = bytes.fromhex(rpc("eth_getStorageAt", [address, "0x" + SLOT_1967_BEACON, block_hex])[2:].rjust(64, "0"))
    uups_slot = bytes.fromhex(rpc("eth_getStorageAt", [address, "0x" + SLOT_1822, block_hex])[2:].rjust(64, "0"))

    proxy_of = None
    if any(impl_slot):
        proxy_of = addr_from_slot(impl_slot)
        checks.append(f"EIP-1967 implementation slot at block {block_no:,}: {proxy_of}")
    elif any(beacon_slot):
        beacon = addr_from_slot(beacon_slot)
        proxy_of = addr_from_call(call(beacon, sel("implementation()"), block_hex))
        checks.append(f"EIP-1967 beacon slot at block {block_no:,}: beacon {beacon}, implementation() {proxy_of}")
    elif any(uups_slot):
        proxy_of = addr_from_slot(uups_slot)
        checks.append(f"EIP-1822 slot at block {block_no:,}: {proxy_of}")
    else:
        checks.append("EIP-1967/1822/beacon slots empty")
    is_proxy = proxy_of is not None

    # 4. upgradeable / admin (before verification, since name may come from the implementation)
    upgradeable, admin = "", ""
    if is_proxy:
        if any(admin_slot):
            admin = addr_from_slot(admin_slot)
            upgradeable = "yes"
            checks.append(f"EIP-1967 admin slot at block {block_no:,}: {admin} (proxy, admin set)")
        else:
            owner = addr_from_call(call(address, sel("owner()"), block_hex))
            if owner:
                admin, upgradeable = owner, "yes"
                checks.append(f"EIP-1967 admin slot empty; owner() at block {block_no:,}: {owner}")
            else:
                checks.append(f"EIP-1967 admin slot empty; owner() at block {block_no:,}: no answer")
    else:
        push4, delegatecall = opcode_scan(code)
        if not delegatecall and not (push4 & UPGRADE_SELECTORS):
            upgradeable = "no"
            checks.append("not a proxy; no DELEGATECALL opcode and no upgradeTo/upgradeToAndCall/ProxyAdmin.upgrade selector in the runtime code")
        else:
            checks.append("not a proxy; a DELEGATECALL opcode or an upgrade selector is present: upgradeable left unestablished")
        owner = addr_from_call(call(address, sel("owner()"), block_hex))
        getter = "owner()"
        if not owner:
            owner, getter = addr_from_call(call(address, sel("admin()"), block_hex)), "admin()"
        if owner:
            admin = owner
            checks.append(f"{getter} at block {block_no:,}: {admin}")
        else:
            checks.append(f"owner() and admin() at block {block_no:,}: no answer")

    # 3. verification and name
    self_verified, self_name = verification(address)
    checks.append(f"Sourcify/Blockscout for {address}: {'verified, name ' + self_name if self_verified else 'not verified'}")
    impl_verified, impl_name = (False, "")
    if is_proxy and proxy_of:
        impl_verified, impl_name = verification(proxy_of)
        checks.append(f"Sourcify/Blockscout for implementation {proxy_of}: {'verified, name ' + impl_name if impl_verified else 'not verified'}")
    verified = self_verified or impl_verified
    name = impl_name if (is_proxy and impl_verified) else (self_name if self_verified else "")
    code_field = "verified" if verified else "bytecode"
    code_url = f"https://etherscan.io/address/{address}#code"

    # 5. value
    v = Value(block_hex, timestamp)
    usd, eth_held, held = v.usd(address)
    if usd is None:
        checks.append(f"value: ETH/USD feed unavailable; {fmt_eth(eth_held)} ETH held, value.usd left empty")
    else:
        checks.append(f"value: {fmt_eth(eth_held)} ETH + {held} token{'s' if held != 1 else ''} = ${round(usd):,}")

    # 6. activity
    txs_90d = args.txs_90d
    last = args.last
    if txs_90d is not None or last is not None:
        checks.append(f"activity (txs_90d={txs_90d}, last={last}) given by the caller")

    # --- render ---------------------------------------------------------------------------------------------
    slug = re.sub(r"[^a-z0-9]+", "-", (name or "contract").lower()).strip("-") or "contract"
    file_id = f"{slug}-{address[2:10]}-{args.issue}"
    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{file_id}.md"
    if out_path.exists():
        sys.exit(f"refusing to overwrite {out_path}")

    today = datetime.now(timezone.utc).date().isoformat()

    def q(v):  # a JSON string is a valid YAML double-quoted scalar, whatever it holds
        return "" if v in (None, "") else json.dumps(v) if isinstance(v, str) else str(v)

    empty_fields = ["title", "severity", "justification", "category", "value.whose", "contract.project", "contract.label"]
    for label, v_ in (("contract.name", name), ("contract.proxy_of", proxy_of), ("contract.upgradeable", upgradeable),
                       ("contract.admin", admin), ("value.usd", usd), ("activity.txs_90d", txs_90d), ("activity.last", last),
                       ("impact", None), ("action", None), ("evidence_level", None)):
        if v_ in (None, ""):
            empty_fields.append(label)

    checks_md = "\n".join(f"- {c}" for c in checks)
    body = f"""---
id: {file_id}
format: 2
title:
status: candidate
severity:
justification:
category:
pattern: {args.pattern}
study: {args.study}
as_of: {as_of}
block: {block_no}
contract:
  address: "{address}"
  name: {q(name) if name else ""}
  project:
  label:
  code: {code_field}
  code_url: {code_url}
  proxy_of: {q(proxy_of) if proxy_of else ""}
  copies: 1
  family:
  upgradeable: {q(upgradeable) if upgradeable else ""}
  admin: {q(admin) if admin else ""}
value:
  usd: {"" if usd is None else round(usd)}
  whose:
  basis: held
activity:
  txs_90d: {"" if txs_90d is None else txs_90d}
  last: {"" if last is None else last}
impact:
action:
evidence_level:
sources:
- study: {args.study}
  who: {q(args.who)}
  date: {today}
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

TODO: what this contract does, where it trusts the signature, what goes wrong.

## Evidence

TODO: one fact that shows the problem, with a link.

## Reviewer notes

### Mechanism

TODO: the path through the code, for this contract.

### Checks

{checks_md}

### History

- {today}: scaffolded by tools/new_finding.py at block {block_no}.
"""
    out_path.write_text("\n".join(line.rstrip() for line in body.split("\n")))
    print(str(out_path))
    print("empty fields: " + ", ".join(empty_fields))


if __name__ == "__main__":
    main()
