---
id: 5fe5b545-fixed-signer
title: "0x5fe5b545: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5fe5b545d9f44eb19dd6f589e3e6adca597ce12b"
  family: "068284326f4dc1d0388768b2293f5bd4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x956bb027149ce08f430a56f7a7a6af4d8b28abbc"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The decompilation does not show the ecrecover call site; 0xca8ee3e7 is the likely spot. The study note's description ('presale deposit/claim') does not match this code."
---

## Summary

The signer is a hard-coded constant with no setter, and that address is an EOA today, so the claim holds. But every path that moves value works without the signature: the owner can call withdraw(), the owner runs enterWinners, and users call withdrawPrize(). If the signer stopped recovering under EIP-8151, at most a verification view would break.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signerPubKey constant 575237671657041990084961364690712122409577165497 = 0x64c28c9f…32b9, code_bytes 0 and not delegated
- No function writes the signer. transferOwnership only writes the owner bits of store_g
- Unresolved_3ccfd60b (withdraw): owner-only, transfers address(this).balance
- withdrawPrize pays out storage_map_d, which is set by the owner-only enterWinners with no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No action needed for funds. Don't give the signer key's account real code; if a signature check is ever needed, deploy a new contract that has a signer setter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
