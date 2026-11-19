---
id: unidentified-83aa3895-signature-rechecked
title: "OrchidLottery1: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-83aa3895
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x6db8381b2b41b74e17f5d4eb82e8d5b04dda0a82"
  name: "OrchidLottery1 (study family 69f4295e)"
  upgradeable: "no"
  value_usd: 5594
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 69f4295e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $6k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x6db8381b2b41b74e17f5d4eb82e8d5b04dda0a82` (OrchidLottery1, family `69f4295e`, 1 address, $6k): Orchid lottery claim: a ticket signed by the signer of a funder's account pays the recipient out of that account's deposit. Decided by: read (function text).
