---
id: unidentified-4abd798b-fixed-signer
title: "Unverified contract 0x0494f4…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4abd798b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0494f4d4811f76654d45b68dd85d1c85e0126f84"
  name: "unverified code (study family 74648c05)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 74648c05"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0494f4d4811f76654d45b68dd85d1c85e0126f84` (unverified, family `74648c05`, 1 address, $3k): ERC-1271 contract with four selectors answering for a signer that is a constant in its code. Decided by: bytecode and names (no source).
