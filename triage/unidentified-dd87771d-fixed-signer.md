---
id: unidentified-dd87771d-fixed-signer
title: "Unverified contract 0x0c1f85…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-dd87771d
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0c1f853649bb66c14864d73f1e3b616ff0ef43d1"
  name: "unverified code (study family 8c0cc9d0)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8c0cc9d0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0c1f853649bb66c14864d73f1e3b616ff0ef43d1` (unverified, family `8c0cc9d0`, 1 address, $0): an ERC-1271 contract with two selectors that answers for a signer fixed in its code. Decided by: bytecode and names (no source). Executed: a real transaction does the same, with the same logs, when its signer has code.
