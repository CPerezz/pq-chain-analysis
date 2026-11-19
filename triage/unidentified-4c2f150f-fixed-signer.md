---
id: unidentified-4c2f150f-fixed-signer
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4c2f150f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9f42a800c80c18646a9e9e475e6451196e16888e"
  name: "unverified code (study family ef2d2157), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x9f42a800c80c18646a9e9e475e6451196e16888e"
  name: "unverified code (study family ef2d2157)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ef2d2157"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x9f42a800c80c18646a9e9e475e6451196e16888e` (unverified, family `ef2d2157`, 3 addresses, $0): time-locked vaults; same verdict as 42cce71f. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
