# /// script
# requires-python = ">=3.10"
# dependencies = ["pyyaml", "eth-abi", "pycryptodome"]
# ///
"""Re-run what a format 2 finding states, on an archive node (`ETH_RPC_URL`).

    uv run tools/verify.py FILE [FILE ...] [--value] [--no-names] [--replays FILE] [--sources DIR] [--json]

Two things are re-run for each file:

  facts    the header facts a tool can read at `block`: that the address has code, the implementation behind a
           proxy, upgradeable, admin, verified or not, the name; with --value also what it holds. A value the tool
           reads must be the file's. A value the tool does not read, or reads differently, must be backed by a
           check whose `for` names that fact (`for: [admin]`). Not re-read: copies, activity, project, label (the
           study's data); `whose` is a judgment a check may back.
  checks   every entry of `checks:` (CHECK_KINDS in tools/build.py). Each must give the result it states.

A check proves a fact, not what the card concludes from it: that is the reviewer's part. A `replay` check needs the
results of the study's fork engine (--replays: one JSON object per line, {"tx": hash, "runs": {run: true or false}});
without them it is reported as not re-run. Exit code 1 if anything fails.
"""

import argparse
import json
import sys
import urllib.request
from pathlib import Path

from eth_abi import decode, encode
from eth_abi.grammar import TupleType, parse

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402
import new_finding as nf  # noqa: E402

OK, FAIL, SKIP = "ok", "FAIL", "skip"


def hexaddr(v) -> str:
    """An address as 0x + 40 lowercase hex, from a string or from the number an unquoted YAML hex became."""
    return "0x%040x" % v if isinstance(v, int) else str(v).lower()


def to_int(v) -> int:
    return v if isinstance(v, int) else int(str(v), 16 if str(v).lower().startswith("0x") else 10)


def truth(v) -> bool:
    return v in (True, 1, "true", "True", "yes")


def to_py(t, v):
    """A YAML value as the Python value eth_abi encodes for ABI type T."""
    if t.is_array:
        return [to_py(t.item_type, x) for x in v]
    if isinstance(t, TupleType):
        return tuple(to_py(c, x) for c, x in zip(t.components, v))
    return {"address": hexaddr, "uint": to_int, "int": to_int, "bool": truth, "string": str}.get(
        t.base, lambda x: x if isinstance(x, bytes) else bytes.fromhex(str(x).removeprefix("0x")))(v)


def canon(t, v):
    """A decoded or an expected value in one comparable form."""
    if t.is_array:
        return [canon(t.item_type, x) for x in v]
    if isinstance(t, TupleType):
        return [canon(c, x) for c, x in zip(t.components, v)]
    if t.base == "address":
        return int(hexaddr(v), 16)
    if t.base in ("uint", "int"):
        return to_int(v)
    if t.base == "bool":
        return truth(v)
    if t.base == "string":
        return str(v)
    return (v.hex() if isinstance(v, bytes) else str(v).removeprefix("0x")).lower()


def split_fn(fn: str) -> tuple[str, str, str | None]:
    """"name(in)(out)" as (name, "(in)", "(out)" or None), minding nested parentheses."""
    i, depth = fn.index("("), 0
    for j in range(i, len(fn)):
        depth += (fn[j] == "(") - (fn[j] == ")")
        if depth == 0:
            break
    return fn[:i].strip(), fn[i:j + 1], fn[j + 1:].strip() or None


def sources_of(address: str, cache: Path | None) -> dict[str, str]:
    """Verified source files of ADDRESS, path -> text: Sourcify, else Blockscout. {} when it is not verified."""
    hit = cache / f"{address}.json" if cache else None
    if hit and hit.exists():
        return json.loads(hit.read_text())
    out = {}
    status, body = nf.http_get(f"https://sourcify.dev/server/v2/contract/1/{address}?fields=sources")
    if status == 200 and body and body.get("sources"):
        out = {k: v.get("content", "") for k, v in body["sources"].items()}
    else:
        status, body = nf.http_get(f"https://eth.blockscout.com/api/v2/smart-contracts/{address}")
        if status == 200 and body and body.get("is_verified"):
            out = {body.get("file_path") or f"{body.get('name') or 'contract'}.sol": body.get("source_code") or ""}
            out.update({s["file_path"]: s["source_code"] for s in body.get("additional_sources") or []})
    if hit and out:
        hit.parent.mkdir(parents=True, exist_ok=True)
        hit.write_text(json.dumps(out))
    return out


def run_check(c: dict, block: int, ctx: dict) -> tuple[str, str]:
    """(ok | FAIL | skip, what was found) for one entry of `checks`."""
    kind = next(k for k in build.CHECK_KINDS if k in c)
    target, at = c[kind], hex(c.get("at") or block)
    if kind in ("code", "bytecode", "selector"):
        code = bytes.fromhex(nf.rpc("eth_getCode", [target, at])[2:])
    if kind == "code":
        got = "empty" if not code else "delegation" if len(code) == 23 and code.startswith(b"\xef\x01\x00") else "contract"
        found = f"{got}, {len(code):,} bytes" + (f", delegated to 0x{code[3:].hex()}" if got == "delegation" else "")
        ok = (got == c["is"] and (c.get("bytes") is None or to_int(c["bytes"]) == len(code))
              and (c.get("target") is None or (got == "delegation" and hexaddr(c["target"]) == "0x" + code[3:].hex())))
        return (OK if ok else FAIL), found
    if kind == "bytecode":
        there = str(c["has"]).removeprefix("0x").lower() in code.hex()
        return (OK if there != truth(c.get("absent")) else FAIL), f"{'present' if there else 'absent'} in {len(code):,} bytes"
    if kind == "selector":
        name, ins, _ = split_fn(c["fn"])
        there = bytes.fromhex(nf.sel(name + ins)) in nf.opcode_scan(code)[0]
        return (OK if there != truth(c.get("absent")) else FAIL), f"0x{nf.sel(name + ins)} {'present' if there else 'absent'}"
    if kind == "storage":
        got = int.from_bytes(nf.storage(target, str(c["slot"]) if not isinstance(c["slot"], int) else hex(c["slot"]), at), "big")
        return (OK if got == to_int(c["is"]) else FAIL), "0x%064x" % got
    if kind == "nonce":
        got = int(nf.rpc("eth_getTransactionCount", [target, at]), 16)
        ok = (c.get("is") is None or got == to_int(c["is"])) and (c.get("min") is None or got >= to_int(c["min"]))
        return (OK if ok else FAIL), str(got)
    if kind == "call":
        name, ins, outs = split_fn(c["fn"])
        in_t = parse(ins).components if ins != "()" else []  # eth_abi refuses an empty tuple
        data = nf.sel(name + ins) + encode([t.to_type_str() for t in in_t], [to_py(t, v) for t, v in zip(in_t, c.get("args") or [])]).hex()
        tx = {"to": target, "data": "0x" + data, **({"from": hexaddr(c["from"])} if c.get("from") else {})}
        try:
            raw = bytes.fromhex(nf.rpc("eth_call", [tx, at])[2:])
        except RuntimeError as e:
            return (OK if truth(c.get("reverts")) else FAIL), f"reverted ({str(e)[:80]})"
        if truth(c.get("reverts")):
            return FAIL, "did not revert"
        if outs is None:
            return FAIL, "the check's fn names no return types: write name(args)(returns)"
        out_t = parse(outs).components if outs != "()" else []
        try:
            got = decode([t.to_type_str() for t in out_t], raw)
        except Exception as e:
            return FAIL, f"the answer does not decode as {outs}: {str(e)[:60]} (0x{raw.hex()[:80]})"
        want = c["is"] if len(out_t) > 1 else [c["is"]]
        shown = ", ".join(str(x) if not isinstance(x, bytes) else "0x" + x.hex() for x in got)
        try:
            same = [canon(t, x) for t, x in zip(out_t, got)] == [canon(t, x) for t, x in zip(out_t, want)]
        except Exception as e:
            return FAIL, f"`is` does not fit {outs}: {str(e)[:60]}; got {shown}"
        return (OK if same else FAIL), shown[:200]
    if kind == "source":
        files = sources_of(target, ctx.get("sources"))
        if not files:
            return FAIL, "no verified source on Sourcify or Blockscout"
        names = [k for k in files if k == c["file"] or k.endswith("/" + c["file"]) or Path(k).name == c["file"]]
        if len(names) != 1:
            return FAIL, f"{len(names)} files match {c['file']!r} among {len(files)}"
        first, last = (c["line"], c["line"]) if c.get("line") is not None else c["lines"]
        text = " ".join("\n".join(files[names[0]].split("\n")[first - 1:last]).split())
        return (OK if " ".join(str(c["has"]).split()) in text else FAIL), f"{names[0]} lines {first}-{last}: {text[:120]}"
    if kind == "tx":
        tx = nf.rpc("eth_getTransactionByHash", [target])
        if tx is None:
            return FAIL, "no such transaction"
        receipt = nf.rpc("eth_getTransactionReceipt", [target])
        good = receipt["status"] == "0x1"
        ok = (c.get("to") is None or (tx["to"] or "").lower() == hexaddr(c["to"])) and (c.get("ok") is None or good == truth(c["ok"]))
        return (OK if ok else FAIL), f"block {int(tx['blockNumber'], 16):,}, to {tx['to']}, {'succeeded' if good else 'failed'}"
    if kind == "replay":
        runs = (ctx.get("replays") or {}).get(target.lower())
        if runs is None or c["run"] not in runs:
            return SKIP, "not re-run: needs the fork engine's results (--replays)"
        return (OK if runs[c["run"]] == truth(c["ok"]) else FAIL), f"{c['run']}: {'succeeded' if runs[c['run']] else 'failed'}"
    if kind == "ref":
        try:
            status = urllib.request.urlopen(urllib.request.Request(target, method="HEAD"), timeout=60).status
        except Exception as e:
            return FAIL, f"the link does not open: {str(e)[:60]}"
        return (SKIP if status == 200 else FAIL), "a written record, not re-run" if status == 200 else f"HTTP {status}"
    return FAIL, "unknown kind"


def check_facts(head: dict, ctx: dict) -> list[tuple[str, str, str]]:
    c, block = head.get("contract") or {}, head.get("block")
    valuer = None
    if ctx.get("value"):
        valuer = ctx.setdefault("valuers", {}).get(block) or ctx["valuers"].setdefault(block, nf.Value(hex(block), nf.block_time(block)[1]))
    f, _ = nf.read_facts(c["address"], block, names=ctx.get("names", True), valuer=valuer if (c.get("copies") or 1) == 1 else None)
    if not f["code_bytes"]:
        return [("code at the block", FAIL, "the address has no code")]
    out = [("code at the block", OK, f"{f['code_bytes']:,} bytes")]

    def same(what, file_value, tool_value):
        fv, tv = ("" if file_value in (None, "none") else str(file_value).lower()), (tool_value or "").lower()
        backed = [k["id"] for k in head.get("checks") or [] if what in (k.get("for") or [])]
        if fv == tv:
            out.append((f"contract.{what}", OK, tv or "empty"))
        elif backed:
            out.append((f"contract.{what}", OK, f"file {fv or 'empty'}, tool {tv or 'empty'}; backed by check {', '.join(backed)}"))
        else:
            out.append((f"contract.{what}", FAIL, f"file {fv or 'empty'}, tool {tv or 'empty'}, and no check is marked `for: [{what}]`"))

    same("proxy_of", c.get("proxy_of"), f["proxy_of"])
    same("upgradeable", c.get("upgradeable"), f["upgradeable"])
    same("admin", c.get("admin"), f["admin"])
    if ctx.get("names", True):
        same("name", c.get("name"), f["name"])
        claimed = c.get("code") == "verified"
        out.append(("contract.code", OK if claimed == bool(f["verified"]) else FAIL,
                    f"file {c.get('code')}, {'verified' if f['verified'] else 'not verified'} on Sourcify or Blockscout"))
    usd = (head.get("value") or {}).get("usd")
    if ctx.get("value") and usd is not None:
        if (c.get("copies") or 1) > 1:
            out.append(("value.usd", SKIP, f"covers {c['copies']} copies: the study's data"))
        elif f["value_usd"] is None:
            out.append(("value.usd", SKIP, "the price feed did not answer at the block"))
        else:
            close = abs(usd - f["value_usd"]) <= max(5, 0.01 * max(usd, f["value_usd"]))
            out.append(("value.usd", OK if close else FAIL, f"file ${usd:,}, tool ${f['value_usd']:,}"))
    return out


def verify_file(path: Path, ctx: dict) -> list[tuple[str, str, str]]:
    head, _ = build.split(path, build.Problems())
    if head is None or head.get("format") != 2:
        return [("format", FAIL, "not a format 2 finding")]
    if not isinstance(head.get("block"), int) or not isinstance((head.get("contract") or {}).get("address"), str):
        return [("header", FAIL, "needs block and contract.address")]
    out = [] if ctx.get("no_facts") else check_facts(head, ctx)
    for c in head.get("checks") or []:
        try:
            status, found = run_check(c, head["block"], ctx)
        except Exception as e:  # a check that cannot run has not passed
            status, found = FAIL, f"could not run: {type(e).__name__}: {str(e)[:100]}"
        out.append((f"check {c.get('id')} ({c.get('says')})", status, found))
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("files", nargs="+", type=Path)
    ap.add_argument("--value", action="store_true", help="also recompute what the address holds (about 150 reads)")
    ap.add_argument("--no-names", action="store_true", help="skip Sourcify and Blockscout: name and verified are not re-read")
    ap.add_argument("--no-facts", action="store_true", help="run the checks only")
    ap.add_argument("--replays", type=Path, help="results of the fork engine, one JSON object per line")
    ap.add_argument("--sources", type=Path, help="a folder to keep fetched source files in")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()
    ctx = {"value": args.value, "names": not args.no_names, "no_facts": args.no_facts, "sources": args.sources, "replays": {}}
    if args.replays:
        ctx["replays"] = {d["tx"].lower(): d["runs"] for d in map(json.loads, args.replays.read_text().splitlines()) if d}
    bad = 0
    for path in args.files:
        rows = verify_file(path, ctx)
        bad += sum(1 for _, s, _ in rows if s == FAIL)
        if args.json:
            print(json.dumps({"file": str(path), "results": rows}))
        else:
            print(f"{path}")
            for what, status, found in rows:
                print(f"  {status:4} {what}: {found}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
