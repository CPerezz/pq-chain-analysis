---
id: stakingmanager-a1c4d914-fixed-signer
title: "StakingManager: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa1c4d914ce176df69fa94bb6be8422e2582cfd0b"
  family: "cb483ac5b7c116357b3720554f8d98a8"
  name: "StakingManager"
  upgradeable: "no"
  rating: HIGH
  value_usd: 20080
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the operator keeps the key without code, or moves users to a new deployment"
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
  rating: HIGH
  note: "stakes locked if signOwner_ takes code"
---

## Summary

`StakingManager` at `0xa1c4d914ce176df69fa94bb6be8422e2582cfd0b`. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: StakingManager withdraw: signed by signOwner_, a stored address; no function among its names changes it / StakingManager._recover: returns the signer. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: withdraw(id, period, to, amount, sig) needs a signature of signOwner_, a stored address with no setter among the contract's functions; there is no other way to take a stake out.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $20,080 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
