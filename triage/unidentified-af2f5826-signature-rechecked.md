---
id: unidentified-af2f5826-signature-rechecked
title: "2 unverified contracts with one code: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-af2f5826
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x7a984235ee85d776eafaa1b0a09ce760748dd4a6"
  name: "unverified code (study family 98f05b38), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x7a984235ee85d776eafaa1b0a09ce760748dd4a6"
  name: "unverified code (study family 98f05b38)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98f05b38"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 2 addresses, $5k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x7a984235ee85d776eafaa1b0a09ce760748dd4a6` (unverified, family `98f05b38`, 2 addresses, $5k): light-client bridge by its function names (challenge, checkBlockProducerSignatureInHead): anyone may challenge a block whose producer signature does not verify. Decided by: bytecode and names (no source).
