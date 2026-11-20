---
id: 1d38c14b-fixed-signer
title: "0x1d38c14b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01"
  family: "516902903b2031cde71aa8ab50963ce8"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-28
fix:
  layer: new-deployment
  who_acts: "Operator: deploy a new streaming contract with a new signer"
evidence:
  level: source-read
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
  note: "The study note says claim needs a signature. The code shows it does not: only start() is signature-gated."
---

## Summary

The signer is an immutable EOA with no setter. If that key's account ever gets real code, start() stops working, so no new streams can begin. Existing streams can still be claimed without any signature, and tokens that were never streamed stay in the operator wallet. Only a function stops; nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer`, assigned only in the constructor
- signer() returns 0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b, which has no code (EOA) at block 26438999
- start() checks `ECDSA.recover(...) == signer`, with no ERC-1271 or code check
- claim() only checks `stream.recipient == msg.sender`, with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-28.

## Remediation

Deploy a new contract with a replaceable signer, or one that accepts ERC-1271. Existing streams keep working through claim().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
