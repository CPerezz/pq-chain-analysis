---
id: unidentified-c5557771-fixed-signer
title: "678 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c5557771
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xddc197b1ee3e11d14a3c62489266ea1d5a07862f"
  name: "unverified code (study families dbcdc640, 31774487), 1 of 678 addresses running it"
  upgradeable: "no"
families:
- code: "0xddc197b1ee3e11d14a3c62489266ea1d5a07862f"
  name: "unverified code (study families dbcdc640, 31774487)"
  instances: 678
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families dbcdc640"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 678 addresses, $902 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xddc197b1ee3e11d14a3c62489266ea1d5a07862f` (unverified, family `dbcdc640`, 678 addresses, $902): 678 mint clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
