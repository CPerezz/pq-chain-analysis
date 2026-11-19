---
id: unidentified-70b45bef-signature-rechecked
title: "PaymentChannels: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-70b45bef
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xd60eea947aae39e507430b30ce11f142304d9cb1"
  name: "PaymentChannels (study family 9299c0f3)"
  upgradeable: "no"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9299c0f3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $6k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xd60eea947aae39e507430b30ce11f142304d9cb1` (PaymentChannels, family `9299c0f3`, 1 address, $6k): PaymentChannels (newer, 138 recoveries in the window): as the older one: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment; a staker whose account takes code cannot take its stake… Decided by: read. Executed: a real transaction reverts when its signer has code.
