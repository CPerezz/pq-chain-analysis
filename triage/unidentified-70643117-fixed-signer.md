---
id: unidentified-70643117-fixed-signer
title: "AmbirePaymaster (3 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-70643117
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x30dc602e16b957b333ad1369fd115282d4df44f5"
  name: "AmbirePaymaster (study family aff47504), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x30dc602e16b957b333ad1369fd115282d4df44f5"
  name: "AmbirePaymaster (study family aff47504)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families aff47504"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x30dc602e16b957b333ad1369fd115282d4df44f5` (AmbirePaymaster, family `aff47504`, 3 addresses, $0): Ambire paymaster: the recovered address must be the relayer fixed in the code. Decided by: read. Executed: a real transaction reverts when its signer has code.
