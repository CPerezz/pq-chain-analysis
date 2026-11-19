---
id: unidentified-b22d635d-fixed-signer
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b22d635d
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbe46291a835a0f3301eaa4b5962a8734a768ff8d"
  name: "unverified code (study family 9bfb5c42), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0xbe46291a835a0f3301eaa4b5962a8734a768ff8d"
  name: "unverified code (study family 9bfb5c42)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9bfb5c42"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xbe46291a835a0f3301eaa4b5962a8734a768ff8d` (unverified, family `9bfb5c42`, 3 addresses, $0): swap helper: a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction does the same, with the same logs, when its signer has code.
