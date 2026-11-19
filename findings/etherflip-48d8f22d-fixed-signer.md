---
id: etherflip-48d8f22d-fixed-signer
title: "EtherFlipGold: signer fixed in code"
project: etherflip
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x48d8f22d45e40f34cb7c10799f31246f134e9b7f"
  family: "2e5ba8f711a5325c5fe13689650786c9"
  name: "EtherFlipGold"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 29148
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner refunds open bets and moves the bankroll"
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
  note: "as EtherFlip"
---

## Summary

`EtherFlipGold` at `0x48d8f22d45e40f34cb7c10799f31246f134e9b7f`. As EtherFlip: the Oraclize proof key is fixed; the game stops while the owner moves the money without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Same code and owner as EtherFlip; refundTransfer present.
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $29,148 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner refunds and withdraws.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
