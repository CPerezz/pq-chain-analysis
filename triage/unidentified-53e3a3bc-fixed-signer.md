---
id: unidentified-53e3a3bc-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-53e3a3bc
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x172fa1962cf5fcb345ea72f5e06e9ed08cbd0790"
  name: "unverified code (study family 08fde0aa), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x172fa1962cf5fcb345ea72f5e06e9ed08cbd0790"
  name: "unverified code (study family 08fde0aa)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 08fde0aa"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $4k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x172fa1962cf5fcb345ea72f5e06e9ed08cbd0790` (unverified, family `08fde0aa`, 2 addresses, $4k): ERC-1271 contract with four selectors answering for a signer that is a constant in its code. Decided by: bytecode and names (no source).
