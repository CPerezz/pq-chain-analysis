---
id: unidentified-401dacb7-fixed-signer
title: "2,703 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-401dacb7
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfac4cae912316212098b135a2da0bf134dfa8340"
  name: "unverified code (study family db48ee01), 1 of 2,703 addresses running it, 2,701 by 7702 delegation"
  upgradeable: "no"
families:
- code: "0xfac4cae912316212098b135a2da0bf134dfa8340"
  name: "unverified code (study family db48ee01)"
  instances: 2703
  list: "every address running this code at block 26,438,999 (2,701 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families db48ee01"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2,703 addresses, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xfac4cae912316212098b135a2da0bf134dfa8340` (unverified, family `db48ee01`, 2,703 addresses, $5k): 7702 delegate used by 2,701 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Decided by: bytecode and names (no source).
