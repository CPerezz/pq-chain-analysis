---
id: unidentified-1304f1b9-signature-rechecked
title: "AdExCore: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-1304f1b9
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x333420fc6a897356e69b62417cd17ff012177d2b"
  name: "AdExCore (study family 07c7ce7d)"
  upgradeable: "no"
  value_usd: 16061
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 07c7ce7d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $16k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x333420fc6a897356e69b62417cd17ff012177d2b` (AdExCore, family `07c7ce7d`, 1 address, $16k): AdEx core: a channel pays out only on a state root signed by two thirds of the channel's validators, the first of them always; after the channel's end its creator takes back what is left. Decided by: read.
