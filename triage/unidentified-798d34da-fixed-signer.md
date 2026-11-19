---
id: unidentified-798d34da-fixed-signer
title: "UnusualGs: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-798d34da
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x089045a72b70b05ec22ea4be23ebc07768fb3e7f"
  name: "UnusualGs (study family 7ce071c8)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7ce071c8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x089045a72b70b05ec22ea4be23ebc07768fb3e7f` (UnusualGs, family `7ce071c8`, 1 address, $3k): UnusualGs allow list: signed by CONTRACT_OWNER, set in the constructor, never changed. Decided by: read.
