"""Verified-source excerpts of the signature / proof checks -> data/excerpts/<address>.md.

Run on the remote box. For every hand-classified contract and its current implementation (data/state/state.json):
Sourcify v2 first (cached under data/sourcify), then Blockscout's verified source. Each excerpt is the code around
lines that call or name a pre-quantum check (ecrecover, ECDSA/SignatureChecker, ERC-1271, pairing/SNARK verify,
point evaluation, P-256, modexp, BLS, Schnorr/VRF), with file paths and line numbers. Library files that only define
the primitive (OpenZeppelin/Solady ECDSA etc.) are listed by name, not excerpted.
"""

import json
import os
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor

import requests

sys.path.insert(0, "scripts")
import sourcify  # noqa: E402

OUT = "data/excerpts"
CONTEXT = 4
MAX_LINES = 260
PATTERN = re.compile(
    r"ecrecover|ECDSA\.|tryRecover|\.recover\(|SignatureChecker|isValidSignature|_validateSignature|"
    r"verifyProof|verifyBatchProof|\bverify\(|[Pp]airing|staticcall\([^)]*\b(0x0?[5-9a]|0x100|5|6|7|8|10)\b|"
    r"pointEvaluation|POINT_EVALUATION|P256|WebAuthn|secp256r1|modexp|BLS|Schnorr|VRF|permit\(|transferWithAuthorization")
LIBRARY_FILE = re.compile(r"(?i)(^|/)(ECDSA|SignatureChecker(Lib)?|EIP712|ECDSAUpgradeable|SignatureCheckerUpgradeable|"
                          r"P256|WebAuthn|LibString|Strings|Math)\.sol$")


def blockscout_sources(a):
    for attempt in range(5):
        try:
            r = requests.get(f"https://eth.blockscout.com/api/v2/smart-contracts/{a}", timeout=60)
            if r.status_code == 404:
                return None
            if r.ok:
                d = r.json()
                if not d.get("source_code"):
                    return None
                srcs = {d.get("file_path") or f"{d.get('name', 'Contract')}.sol": d["source_code"]}
                for s in d.get("additional_sources") or []:
                    srcs[s["file_path"]] = s["source_code"]
                return {"name": d.get("name"), "sources": srcs, "via": "blockscout"}
        except requests.RequestException:
            pass
        time.sleep(2 + 3 * attempt)
    return None


def load(a):
    d = sourcify.get(a)
    if d and d.get("sources"):
        comp = d.get("compilation") or {}
        return {"name": comp.get("name"), "sources": {p: s.get("content", "") for p, s in d["sources"].items()}, "via": "sourcify"}
    return blockscout_sources(a)


def excerpt(a, label):
    src = load(a)
    if not src:
        return f"## {label} `{a}`\n\nNo verified source on Sourcify or Blockscout.\n"
    out = [f"## {label} `{a}` — {src.get('name') or '?'} (verified source via {src['via']})\n"]
    libs, budget = [], MAX_LINES
    for path in sorted(src["sources"], key=lambda p: ("/lib/" in p or "node_modules" in p or "@openzeppelin" in p, p)):
        lines = src["sources"][path].splitlines()
        hits = [i for i, line in enumerate(lines) if PATTERN.search(line) and not line.strip().startswith(("//", "*", "/*"))]
        if not hits:
            continue
        if LIBRARY_FILE.search(path):
            libs.append(path)
            continue
        windows = []
        for i in hits:
            lo, hi = max(0, i - CONTEXT), min(len(lines), i + CONTEXT + 1)
            if windows and lo <= windows[-1][1]:
                windows[-1][1] = hi
            else:
                windows.append([lo, hi])
        block = []
        for lo, hi in windows:
            block += [f"{n + 1:5d}  {lines[n]}" for n in range(lo, hi)] + ["  ..."]
        if budget <= 0:
            out.append(f"- `{path}`: {len(hits)} more matching lines (not shown)")
            continue
        block = block[:budget]
        budget -= len(block)
        out.append(f"### `{path}`\n\n```solidity\n" + "\n".join(block) + "\n```\n")
    if libs:
        out.append("Library files with the primitive itself (not excerpted): " + ", ".join(f"`{p}`" for p in libs) + "\n")
    return "\n".join(out)


def one(item):
    a, impl = item
    dst = f"{OUT}/{a}.md"
    if os.path.exists(dst):
        return
    parts = [excerpt(a, "Contract")]
    if impl and impl != a:
        parts.append(excerpt(impl, "Implementation"))
    open(dst, "w").write("\n".join(parts))


def main():
    state = json.load(open("data/state/state.json"))["contracts"]
    os.makedirs(OUT, exist_ok=True)
    items = [(a, d.get("implementation")) for a, d in state.items()]
    with ThreadPoolExecutor(6) as ex:
        list(ex.map(one, items))
    print("excerpts", len(os.listdir(OUT)))


if __name__ == "__main__":
    main()
