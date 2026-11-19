---
id: unidentified-8b2fe6db-fixed-signer
title: "Unverified contract 0x9e84f5…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-8b2fe6db
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9e84f5ae2cae54e3f58328a8b74b118ce24880f5"
  name: "unverified code (study family 9dd61ef8)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9dd61ef8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x9e84f5ae2cae54e3f58328a8b74b118ce24880f5` (unverified, family `9dd61ef8`, 1 address, $0): a signer that is a constant in the code; selectors unnamed. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
