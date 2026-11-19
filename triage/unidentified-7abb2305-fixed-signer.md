---
id: unidentified-7abb2305-fixed-signer
title: "Unverified contract 0x6e5268…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-7abb2305
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6e52681fe40fb0778b387e5d75646afcf0e9496c"
  name: "unverified code (study family 52094261)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 52094261"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x6e52681fe40fb0778b387e5d75646afcf0e9496c` (unverified, family `52094261`, 1 address, $3k): BitGo pattern (isSigner, signers). Decided by: bytecode and names (no source).
