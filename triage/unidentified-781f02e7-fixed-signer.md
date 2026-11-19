---
id: unidentified-781f02e7-fixed-signer
title: "Unverified contract 0xbf7fe1…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-781f02e7
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbf7fe109f674ab1341d69e67a262e50ce87eb7c1"
  name: "unverified code (study family 015573ba)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 015573ba"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xbf7fe109f674ab1341d69e67a262e50ce87eb7c1` (unverified, family `015573ba`, 1 address, $0): deposit claims are checked against a signer that is a constant in the code; no upgrade path. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
