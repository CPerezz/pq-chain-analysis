---
id: unidentified-558b3d94-fixed-signer
title: "Unverified contract 0x53a449…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-558b3d94
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x53a449540d792dc8f848d8a050e003ef63e348cc"
  name: "unverified code (study family 6c690638)"
  upgradeable: "no"
  value_usd: 7399
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6c690638"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $7k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x53a449540d792dc8f848d8a050e003ef63e348cc` (unverified, family `6c690638`, 1 address, $7k): one selector, withdraw, behind a signer that is a constant in the code. Decided by: bytecode and names (no source).
