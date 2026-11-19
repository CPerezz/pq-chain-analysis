---
id: unidentified-afb1f041-fixed-signer
title: "Vault: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-afb1f041
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9cde019f455b9a3c33d95912edceabbe0cad3444"
  name: "Vault (study family 55f224ce)"
  upgradeable: "no"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 55f224ce"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $6k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x9cde019f455b9a3c33d95912edceabbe0cad3444` (Vault, family `55f224ce`, 1 address, $6k): Vault changeRecipientAddress: signed by serverSigner, fixed in the code. Decided by: read (function text).
