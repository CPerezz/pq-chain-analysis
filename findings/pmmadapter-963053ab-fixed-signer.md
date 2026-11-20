---
id: pmmadapter-963053ab-fixed-signer
title: "PMMAdapter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x963053abf215ef480c53ce70120ccd9259f4e5a8"
  family: "1d4765b0193cbc66fcefbae9a42c29a4"
  name: "PMMAdapter"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (new adapter)"
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
  note: "Order filler, nothing locked: MEDIUM."
---

## Summary

PMMAdapter CallerAuth: the signer must equal the immutable AUTH_SIGNER, with no setter. The signed fill path dies if that key takes code. As an order filler, the adapter holds no funds by design.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: CallerAuth: the signer must be AUTH_SIGNER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source CallerAuth.sol:10,25,62: immutable AUTH_SIGNER; revert AUTH_BadAuthSig
- state.json at block 26438999: balance 0, no proxy slots

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new adapter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
