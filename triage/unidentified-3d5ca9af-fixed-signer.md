---
id: unidentified-3d5ca9af-fixed-signer
title: "Unverified contract 0xa332b0…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3d5ca9af
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa332b0c5c306f676d4b491d259d190193a5c71e9"
  name: "unverified code (study family 89b8ce12)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 89b8ce12"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa332b0c5c306f676d4b491d259d190193a5c71e9` (unverified, family `89b8ce12`, 1 address, $0): a signer that is a constant in the code; selectors unnamed. Decided by: bytecode and names (no source).
