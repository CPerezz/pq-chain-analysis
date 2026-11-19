---
id: unidentified-b451d93e-fixed-signer
title: "6 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b451d93e
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc2cb7bce682af8ad9e1e1c1dec183a0902456482"
  name: "unverified code (study family 4cef3f5e), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0xc2cb7bce682af8ad9e1e1c1dec183a0902456482"
  name: "unverified code (study family 4cef3f5e)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4cef3f5e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc2cb7bce682af8ad9e1e1c1dec183a0902456482` (unverified, family `4cef3f5e`, 6 addresses, $0): six accounts whose owner key is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
