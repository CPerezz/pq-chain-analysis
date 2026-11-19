---
id: unidentified-ab0d964b-fixed-signer
title: "2 contract families (2 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ab0d964b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0bf3c12eb6081665b68dd34a811c52c5f2b235fd"
  name: "unverified code (study family 98a49092)"
  upgradeable: "no"
- address: "0x1e6d92e7133e04544575e37005b112033573b7b0"
  name: "unverified code (study family a32a4117)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98a49092, a32a4117"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0bf3c12eb6081665b68dd34a811c52c5f2b235fd` (unverified, family `98a49092`, 1 address, $0): two selectors: a withdraw behind a loop of stored signers. Decided by: bytecode and names (no source).
- `0x1e6d92e7133e04544575e37005b112033573b7b0` (unverified, family `a32a4117`, 1 address, $0): two selectors: a withdraw behind a loop of stored signers. Decided by: bytecode and names (no source).
