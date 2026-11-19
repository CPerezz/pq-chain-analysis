---
id: unidentified-a36d91b6-fixed-signer
title: "Unverified contract 0x0bdbad…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a36d91b6
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0bdbad7f19a99c4cc289fa765bf2b9f8b47a4f9e"
  name: "unverified code (study family 681a4362)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 681a4362"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0bdbad7f19a99c4cc289fa765bf2b9f8b47a4f9e` (unverified, family `681a4362`, 1 address, $2k): a signed-withdrawal contract (1.3 ETH). Decided by: bytecode and names (no source).
