---
id: unidentified-0001bc50-fixed-signer
title: "Unverified contract 0xbf9604…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-0001bc50
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbf96042d61937b1686b81557c3a92806f1727ecf"
  name: "unverified code (study family 53708593)"
  upgradeable: "no"
  value_usd: 25805
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 53708593"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $26k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xbf96042d61937b1686b81557c3a92806f1727ecf` (unverified, family `53708593`, 1 address, $26k): one stored signer; all 21 selectors named and none replaces it. Decided by: bytecode and names (no source).
