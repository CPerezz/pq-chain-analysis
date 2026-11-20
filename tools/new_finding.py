# /// script
# requires-python = ">=3.10"
# dependencies = ["pycryptodome"]
# ///
"""Scaffold one finding at one pinned block: facts read by tools, judgment left for a person or agent to write.

    uv run tools/new_finding.py ADDRESS --pattern PQ-n --study STUDY --issue SLUG --who TEXT [--block N] [--out DIR]
                                 [--txs-90d N] [--last YYYY-MM-DD]
    uv run tools/new_finding.py --selftest      known answers read from the node; run it before trusting a batch

Never hand-type a fact: every value this tool can read, it reads itself, at one block. Node (`ETH_RPC_URL`): one
request at a time, 60 s timeout, one retry; never eth_getLogs, never trace_*. Refuses to run if the address is
already filed under the same pattern, or the study/pattern do not exist. `read_facts` is what `tools/verify.py`
re-runs on a finished file.
"""

import argparse
import json
import os
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


def k256(data: bytes) -> bytes:
    return keccak.new(digest_bits=256, data=data).digest()


def sel(sig: str) -> str:
    return k256(sig.encode())[:4].hex()


# Storage slots, computed from their definitions so that no digit can be mistyped (EIP-1967: the hash minus one).
slot_1967 = lambda name: (int.from_bytes(k256(f"eip1967.proxy.{name}".encode()), "big") - 1).to_bytes(32, "big").hex()
SLOT_1967_IMPL, SLOT_1967_ADMIN, SLOT_1967_BEACON = slot_1967("implementation"), slot_1967("admin"), slot_1967("beacon")
SLOT_1822 = k256(b"PROXIABLE").hex()
UPGRADE_SELECTORS = {bytes.fromhex(sel(s)) for s in ("upgradeTo(address)", "upgradeToAndCall(address,bytes)", "upgrade(address,address)")}
CLONE = re.compile(r"363d3d373d3d3d363d73([0-9a-f]{40})5af43d82803e903d91602b57fd5bf3")  # EIP-1167, the whole runtime code


# --- RPC: one request at a time, 60 s timeout, one retry -------------------------------------------------------

def rpc_url() -> str:
    url = os.environ.get("ETH_RPC_URL")
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
        except RuntimeError:
            raise  # the node answered with an error: asking again gives the same answer
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


def storage(address: str, slot: str, at: str) -> bytes:
    return bytes.fromhex(rpc("eth_getStorageAt", [address, "0x" + slot.removeprefix("0x"), at])[2:].rjust(64, "0"))


def http_get(url: str):
    """One external HTTP request, 60 s timeout, one retry. Returns (status, json-or-None)."""
    last = None
    for attempt in range(2):
        try:
            req = urllib.request.Request(url, headers={"accept": "application/json", "user-agent": "pq-chain-analysis"})
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
        self.at, self.now, self.feed_cache, self.tokens = at, now, {}, None

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

    def priced(self) -> dict:
        """symbol -> {address, decimals, usd} for every token of tokens.json that passes its checks; read once."""
        if self.tokens is None:
            self.tokens = {}
            for spec in TOKENS["tokens"]:
                symbol, addr = spec["symbol"], spec["address"]
                got_symbol = call(addr, sel("symbol()"), self.at)
                if got_symbol is None or _text(got_symbol).strip().upper() != symbol.upper():
                    continue
                dec_raw = call(addr, sel("decimals()"), self.at)
                if dec_raw is None:
                    continue
                price = self.price_of(symbol, spec, self.tokens)
                if price is None:
                    continue
                self.tokens[symbol] = {"address": addr, "decimals": int.from_bytes(dec_raw, "big"), "usd": price}
        return self.tokens

    def usd(self, address: str) -> tuple[float | None, float, int]:
        """(total usd or None, eth held, number of priced tokens held)."""
        eth_usd = self.feed_price("ETH / USD")
        eth = int(rpc("eth_getBalance", [address, self.at]), 16) / 1e18
        if eth_usd is None:
            return None, eth, 0
        total, held = eth * eth_usd, 0
        for t in self.priced().values():
            bal_raw = call(t["address"], sel("balanceOf(address)") + "000000000000000000000000" + address[2:], self.at)
            bal = int.from_bytes(bal_raw, "big") if bal_raw else 0
            if bal:
                total += bal / 10 ** t["decimals"] * t["usd"]
                held += 1
        return total, eth, held


def _text(raw: bytes) -> str:
    if len(raw) >= 96 and int.from_bytes(raw[:32], "big") == 32:
        n = int.from_bytes(raw[32:64], "big")
        return raw[64:64 + n].decode(errors="replace")
    return raw[:32].rstrip(b"\0").decode(errors="replace")


# --- the facts of one address at one block --------------------------------------------------------------------

def read_facts(address: str, block_no: int, names: bool = True, valuer: Value | None = None) -> tuple[dict, list[str]]:
    """What this tool reads about ADDRESS at BLOCK_NO, and the log of the reads. Empty or None = not established.

    code_bytes, code_hash, delegation (the target of an EIP-7702 account), proxy_of, proxy_kind, upgradeable
    ("yes", "no" or ""), admin, verified (None when `names` is off), name, value_usd, eth, tokens_held (None without a
    `valuer`). Rules for `upgradeable`, all conservative:
      a proxy with the EIP-1967 admin slot set                                      yes, admin = that address
      a proxy without it whose implementation has an upgrade function               yes, admin = owner() if it answers
      a beacon proxy whose beacon answers owner()                                   yes, admin = that owner
      a fixed clone (EIP-1167), or no proxy: the code that runs has no DELEGATECALL
        and no upgrade function                                                     no
      anything else                                                                 left empty
    """
    at, log = hex(block_no), []
    code = bytes.fromhex(rpc("eth_getCode", [address, at])[2:])
    f = {"code_bytes": len(code), "code_hash": "0x" + k256(code).hex() if code else None, "delegation": None, "proxy_of": None,
         "proxy_kind": None, "upgradeable": "", "admin": "", "verified": None, "name": "", "value_usd": None, "eth": None, "tokens_held": None}
    if not code:
        log.append(f"eth_getCode at block {block_no:,}: no code")
        return f, log
    if len(code) == 23 and code.startswith(b"\xef\x01\x00"):
        f["delegation"] = "0x" + code[3:].hex()
    log.append(f"eth_getCode at block {block_no:,}: {len(code):,} bytes" + (f" (an EIP-7702 delegation to {f['delegation']})" if f["delegation"] else ""))

    impl, admin_slot = storage(address, SLOT_1967_IMPL, at), storage(address, SLOT_1967_ADMIN, at)
    beacon_slot, uups = storage(address, SLOT_1967_BEACON, at), storage(address, SLOT_1822, at)
    clone = CLONE.fullmatch(code.hex())
    beacon = None
    if any(impl):
        f["proxy_of"], f["proxy_kind"] = addr_from_slot(impl), "eip1967"
        log.append(f"EIP-1967 implementation slot at block {block_no:,}: {f['proxy_of']}")
    elif any(beacon_slot):
        beacon = addr_from_slot(beacon_slot)
        f["proxy_of"], f["proxy_kind"] = addr_from_call(call(beacon, sel("implementation()"), at)), "beacon"
        log.append(f"EIP-1967 beacon slot at block {block_no:,}: beacon {beacon}, implementation() {f['proxy_of']}")
    elif any(uups):
        f["proxy_of"], f["proxy_kind"] = addr_from_slot(uups), "eip1822"
        log.append(f"EIP-1822 slot at block {block_no:,}: {f['proxy_of']}")
    elif clone:
        f["proxy_of"], f["proxy_kind"] = "0x" + clone.group(1), "clone"
        log.append(f"EIP-1167 clone of {f['proxy_of']} (fixed in the code)")
    else:
        log.append("EIP-1967, EIP-1822 and beacon slots empty; not an EIP-1167 clone")

    def fixed(runs: bytes, what: str) -> bool:
        push4, delegatecall = opcode_scan(runs)
        if not delegatecall and not (push4 & UPGRADE_SELECTORS):
            log.append(f"{what}: no DELEGATECALL opcode and no upgradeTo, upgradeToAndCall or upgrade selector")
            return True
        log.append(f"{what}: a DELEGATECALL opcode or an upgrade selector is present; upgradeable left empty")
        return False

    owner = addr_from_call(call(address, sel("owner()"), at))
    if f["proxy_kind"] in ("eip1967", "eip1822"):
        if any(admin_slot):
            f["upgradeable"], f["admin"] = "yes", addr_from_slot(admin_slot)
            log.append(f"EIP-1967 admin slot at block {block_no:,}: {f['admin']}")
        elif f["proxy_of"]:
            icode = bytes.fromhex(rpc("eth_getCode", [f["proxy_of"], at])[2:])
            if opcode_scan(icode)[0] & UPGRADE_SELECTORS:
                f["upgradeable"], f["admin"] = "yes", owner or ""
                log.append(f"EIP-1967 admin slot empty; the implementation has an upgrade function; owner() at block {block_no:,}: {owner or 'no answer'}")
            else:
                log.append("EIP-1967 admin slot empty and no upgrade function in the implementation; upgradeable left empty")
    elif f["proxy_kind"] == "beacon":
        bowner = addr_from_call(call(beacon, sel("owner()"), at))
        if bowner:
            f["upgradeable"], f["admin"] = "yes", bowner
        log.append(f"owner() of the beacon at block {block_no:,}: {bowner or 'no answer'}")
    else:
        runs = bytes.fromhex(rpc("eth_getCode", [f["proxy_of"], at])[2:]) if clone else code
        if not f["delegation"] and fixed(runs, "the clone's target" if clone else "not a proxy"):
            f["upgradeable"] = "no"
        getter = "owner()"
        if not owner:
            owner, getter = addr_from_call(call(address, sel("admin()"), at)), "admin()"
        f["admin"] = owner or ""
        log.append(f"{getter} at block {block_no:,}: {owner}" if owner else f"owner() and admin() at block {block_no:,}: no answer")

    if names:
        ok, name = verification(address)
        log.append(f"Sourcify/Blockscout for {address}: {'verified, name ' + name if ok else 'not verified'}")
        iok, iname = (False, "")
        if f["proxy_of"]:
            iok, iname = verification(f["proxy_of"])
            log.append(f"Sourcify/Blockscout for {f['proxy_of']}: {'verified, name ' + iname if iok else 'not verified'}")
        # verified means the code that runs: behind a proxy or clone, the implementation's (a verified proxy shell
        # running unverified logic is bytecode)
        f["verified"], f["name"] = (iok if f["proxy_of"] else ok), iname if iok else (name if ok and not f["proxy_of"] else "")
    if valuer is not None:
        usd, f["eth"], f["tokens_held"] = valuer.usd(address)
        f["value_usd"] = None if usd is None else round(usd)
        log.append(f"value: ETH/USD feed unavailable; {f['eth']:,.2f} ETH held" if usd is None
                   else f"value at block {block_no:,}: {f['eth']:,.2f} ETH + {f['tokens_held']} priced token{'s' if f['tokens_held'] != 1 else ''} = ${round(usd):,}")
    return f, log


def block_time(block_no: int | None) -> tuple[int, int]:
    blk = rpc("eth_getBlockByNumber", [hex(block_no) if block_no is not None else "latest", False])
    return int(blk["number"], 16), int(blk["timestamp"], 16)


# --- self-test: answers known from elsewhere, read through this tool ----------------------------------------------

def selftest() -> int:
    """Each expected value below was read independently of this tool (the literals from EIP-1967 and EIP-1822; the
    implementation and admin with `cast storage`; the names on Etherscan). Block 26,438,999."""
    block, bad = 26438999, []

    def want(what, got, expected):
        if got != expected:
            bad.append(f"{what}: got {got!r}, expected {expected!r}")

    want("EIP-1967 implementation slot", SLOT_1967_IMPL, "360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc")
    want("EIP-1967 admin slot", SLOT_1967_ADMIN, "b53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103")
    want("EIP-1967 beacon slot", SLOT_1967_BEACON, "a3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50")
    want("EIP-1822 slot", SLOT_1822, "c5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7")
    want("selector of transfer(address,uint256)", sel("transfer(address,uint256)"), "a9059cbb")
    for name, address, expected in SELFTEST:
        f, _ = read_facts(address, block, names=False)
        for key, value in expected.items():
            want(f"{name} {address} {key}", f[key], value)
    print("\n".join(bad) if bad else f"selftest passed: {len(SELFTEST)} contracts at block {block:,}")
    return 1 if bad else 0


SELFTEST = [
    ("EtherDelta, no proxy", "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819",
     {"code_bytes": 6613, "proxy_of": None, "upgradeable": "no", "admin": "0x1ed014aec47fae44c9e55bac7662c0b78ae61798"}),
    ("tBTC WalletRegistry, EIP-1967 proxy with an admin", "0x46d52e41c2f300bc82217ce22b920c34995204eb",
     {"proxy_kind": "eip1967", "proxy_of": "0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6", "upgradeable": "yes",
      "admin": "0x7affa05f726d293eb1193807a91617318292008e"}),
    ("an EIP-1822 proxy", "0xddf58ae26b751c6a3f0b04670e10d6c66a69ce72",
     {"proxy_kind": "eip1822", "proxy_of": "0x802fcf40c7b8dbfa9dc6e52f05c2a47916341833"}),
    ("an EIP-1167 clone of code that cannot change", "0x095af1ebbd5006f1a61a010e9c1f2b72f95d8143",
     {"code_bytes": 45, "proxy_kind": "clone", "proxy_of": "0xd5fe1c1f216b775dfd30638fa7164d41321ef79b", "upgradeable": "no"}),
    ("an EIP-7702 account", "0x235c1b67c56280e0904b244204e0897537033b63",
     {"code_bytes": 23, "delegation": "0x1e68c71fa1b7c3efd4a576b5551d2e8004f96ea7", "proxy_of": None, "upgradeable": ""}),
]


# --- scaffolding ---------------------------------------------------------------------------------------------

def main():
    if sys.argv[1:] == ["--selftest"]:
        sys.exit(selftest())
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

    block_no, timestamp = block_time(args.block)
    as_of = datetime.fromtimestamp(timestamp, tz=timezone.utc).date().isoformat()
    f, checks = read_facts(address, block_no, valuer=Value(hex(block_no), timestamp))
    if not f["code_bytes"]:
        sys.exit(f"{address} has no code at block {block_no:,}")
    name, proxy_of, upgradeable, admin, usd = f["name"], f["proxy_of"], f["upgradeable"], f["admin"], f["value_usd"]
    txs_90d, last = args.txs_90d, args.last
    if txs_90d is not None or last is not None:
        checks.append(f"activity (txs_90d={txs_90d}, last={last}) given by the caller")

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
  name: {q(name)}
  project:
  label:
  code: {"verified" if f["verified"] else "bytecode"}
  code_url: https://etherscan.io/address/{address}#code
  proxy_of: {q(proxy_of)}
  copies: 1
  family:
  upgradeable: {q(upgradeable)}
  admin: {q(admin)}
value:
  usd: {"" if usd is None else usd}
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
