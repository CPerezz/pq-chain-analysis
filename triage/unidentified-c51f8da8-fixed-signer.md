---
id: unidentified-c51f8da8-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c51f8da8
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc495f766b0e93999679380a0f8cdc2f7d2fe1cda"
  name: "unverified code (study family 53acd230), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xc495f766b0e93999679380a0f8cdc2f7d2fe1cda"
  name: "unverified code (study family 53acd230)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 53acd230"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc495f766b0e93999679380a0f8cdc2f7d2fe1cda` (unverified, family `53acd230`, 2 addresses, $0): ERC-1271 swap contract answering for a signer that is a constant in its code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
