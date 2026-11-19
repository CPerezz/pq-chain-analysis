---
id: unidentified-00000397-fixed-signer
title: "n00bRescueExecutor (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-00000397
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x000003ef88bde4e32674eb5f8f2262f006349711"
  name: "n00bRescueExecutor (study family 98b1e27e), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x000003ef88bde4e32674eb5f8f2262f006349711"
  name: "n00bRescueExecutor (study family 98b1e27e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98b1e27e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x000003ef88bde4e32674eb5f8f2262f006349711` (n00bRescueExecutor, family `98b1e27e`, 2 addresses, $0): n00bRescueExecutor: calls must be signed by `signer`, an address written in the source with no setter. Decided by: read. Executed: a real transaction reverts when its signer has code.
