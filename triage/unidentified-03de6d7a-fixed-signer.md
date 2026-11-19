---
id: unidentified-03de6d7a-fixed-signer
title: "SaitoToken: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-03de6d7a
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfa14fa6958401314851a17d6c5360ca29f74b57b"
  name: "SaitoToken (study family e7ec3ded)"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e7ec3ded"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xfa14fa6958401314851a17d6c5360ca29f74b57b` (SaitoToken, family `e7ec3ded`, 1 address, $5k): SaitoToken: minting needs three stored owner keys; no setter in the source. Decided by: read.
