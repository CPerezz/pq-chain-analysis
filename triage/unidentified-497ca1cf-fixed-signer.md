---
id: unidentified-497ca1cf-fixed-signer
title: "168 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-497ca1cf
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb6111fe01dc70a69ad708b70d28a3e9ba3d5ea02"
  name: "unverified code (study family 57a7e58c), 1 of 168 addresses running it"
  upgradeable: "no"
families:
- code: "0xb6111fe01dc70a69ad708b70d28a3e9ba3d5ea02"
  name: "unverified code (study family 57a7e58c)"
  instances: 168
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 57a7e58c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 168 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb6111fe01dc70a69ad708b70d28a3e9ba3d5ea02` (unverified, family `57a7e58c`, 168 addresses, $0): MEV bot contracts (168 clones; 125 recoveries in the window): trades are signed by a stored owner key with no visible rotation. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
