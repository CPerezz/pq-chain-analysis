---
id: unidentified-facf2b3c-fixed-signer
title: "21 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-facf2b3c
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb8c50124c7f77437a704a6590735a72e561de503"
  name: "unverified code (study family 1caf5e40), 1 of 21 addresses running it"
  upgradeable: "no"
families:
- code: "0xb8c50124c7f77437a704a6590735a72e561de503"
  name: "unverified code (study family 1caf5e40)"
  instances: 21
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1caf5e40"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 21 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb8c50124c7f77437a704a6590735a72e561de503` (unverified, family `1caf5e40`, 21 addresses, $0): 21 contracts with one stored verifier and a fixed threshold; no setter name. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
