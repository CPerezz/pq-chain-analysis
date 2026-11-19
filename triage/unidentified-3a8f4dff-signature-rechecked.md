---
id: unidentified-3a8f4dff-signature-rechecked
title: "CoordinationPaymentChannels (2 copies): under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-3a8f4dff
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6"
  name: "CoordinationPaymentChannels (study family 0d0deff0), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6"
  name: "CoordinationPaymentChannels (study family 0d0deff0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 15700
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0d0deff0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 2 addresses, $16k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6` (CoordinationPaymentChannels, family `0d0deff0`, 2 addresses, $16k): CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature on a commitment next to the coordinator's; a staker whose account takes code cannot withdraw. Decided by: read.
