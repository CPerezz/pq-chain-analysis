---
id: unidentified-d59ceaa6-fixed-signer
title: "Unverified contract 0x2e42b3…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-d59ceaa6
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2e42b3af52f6ffaff822e48411a7d7b7dbac38d3"
  name: "unverified code (study family 23d615a6)"
  upgradeable: "no"
  value_usd: 13895
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 23d615a6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $14k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x2e42b3af52f6ffaff822e48411a7d7b7dbac38d3` (unverified, family `23d615a6`, 1 address, $14k): a claim contract (8 ETH): claims need the fixed defaultSigner's signature; a signer with code ends claims. Decided by: bytecode and names (no source).
