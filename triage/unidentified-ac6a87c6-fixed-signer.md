---
id: unidentified-ac6a87c6-fixed-signer
title: "Unverified contract 0x4a0feb…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ac6a87c6
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4a0febaa503b3395c9bcf70230a957c3d8e80266"
  name: "unverified code (study family 4226be16)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4226be16"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4a0febaa503b3395c9bcf70230a957c3d8e80266` (unverified, family `4226be16`, 1 address, $0): verifying paymaster: a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
