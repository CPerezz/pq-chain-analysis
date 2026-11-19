---
id: unidentified-56fb7a00-fixed-signer
title: "Unverified contract 0x7d6fb6…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-56fb7a00
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7d6fb6b38cbb6b893a49984caebe4e7441592ede"
  name: "unverified code (study family 98a58ac3)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98a58ac3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x7d6fb6b38cbb6b893a49984caebe4e7441592ede` (unverified, family `98a58ac3`, 1 address, $2k): a fee token whose guarded transfers need a stored signer's signature (1.1 ETH). Decided by: bytecode and names (no source).
