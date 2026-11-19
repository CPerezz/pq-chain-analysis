---
id: unidentified-b3bd6aaa-fixed-signer
title: "Unverified contract 0x64348e…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b3bd6aaa
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x64348ed96c8b9fc4a254efc2f2f5d54567a47565"
  name: "unverified code (study family 113d2124)"
  upgradeable: "no"
  value_usd: 7218
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 113d2124"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $7k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x64348ed96c8b9fc4a254efc2f2f5d54567a47565` (unverified, family `113d2124`, 1 address, $7k): no selectors; a signer that is a constant in the code. Decided by: bytecode and names (no source).
