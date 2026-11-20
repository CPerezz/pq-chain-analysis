---
id: cec34a37-fixed-signer
title: "0xcec34a37: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcec34a3781b54f253c59b04235f50425f8a968ec"
  family: "11aa8691ce3bafef4a2f1c3c58dd7303"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator must deploy a new contract with a new signer"
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
  note: "owner() returns 0, so the owner rescue functions may be unusable. I still rated MEDIUM because signed calls forward msg.value in the same transaction, so no signature-only user balance builds up."
---

## Summary

The signer is a constant EOA with no setter and no ERC-1271 or code check. If that key's account gets code, signed calls and purchases stop. The code shows no held user deposits that only a signature could release.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Constant 0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d is used next to the ECDSA error messages and 'invalid signature' in 0x8ff0018f
- Verified facts: 0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d is an EOA with code_bytes 0 and no delegation
- Only setter is transferOwnership (owner), which writes the owner slot 0x33, not the signer
- upgradeable: no; no proxy slot and no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be rotated or that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
