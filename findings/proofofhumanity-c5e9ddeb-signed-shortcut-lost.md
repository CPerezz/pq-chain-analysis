---
id: proofofhumanity-c5e9ddeb-signed-shortcut-lost
title: "ProofOfHumanity: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb"
  family: "213ed30446c52304cb28248a708056a1"
  name: "ProofOfHumanity"
  label: "Proof of Humanity"
  upgradeable: "no"
  rating: LOW
  value_usd: 75431
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 13
  last_active: 2026-11-16
fix:
  layer: none
  who_acts: "the voucher"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same act open by direct call: LOW."
---

## Summary

Proof of Humanity: a vouch can be given by the voucher's own call (addVouch) or by its signature passed in changeStateToPending. A voucher with code loses only the signed route.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Proof of Humanity vouches: a vouch is given on chain by the voucher's own call, or by its signature. Read from source.
- ProofOfHumanity.sol:726 addVouch(address) by msg.sender
- ProofOfHumanity.sol:762-798 changeStateToPending recovers signed vouches

## Impact and exposure

- Value held at block 26,438,999: $75,431 (ETH and 49 priced tokens).
- Activity: 13 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

The voucher calls addVouch directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
