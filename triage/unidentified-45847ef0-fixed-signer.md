---
id: unidentified-45847ef0-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-45847ef0
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x451d3136de17a1c97bbefbc69e1b47e26db744ba"
  name: "unverified code (study family b796700c), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x451d3136de17a1c97bbefbc69e1b47e26db744ba"
  name: "unverified code (study family b796700c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b796700c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x451d3136de17a1c97bbefbc69e1b47e26db744ba` (unverified, family `b796700c`, 2 addresses, $0): bridge with five selectors: one stored signer, no setter. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
