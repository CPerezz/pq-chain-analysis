---
id: unidentified-629f7221-fixed-signer
title: "SmartAccountRelayer (3 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-629f7221
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb7244ddfd3a86dad529a71fb64f84b3505f42d19"
  name: "SmartAccountRelayer (study family c3992923), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0xb7244ddfd3a86dad529a71fb64f84b3505f42d19"
  name: "SmartAccountRelayer (study family c3992923)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c3992923"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb7244ddfd3a86dad529a71fb64f84b3505f42d19` (SmartAccountRelayer, family `c3992923`, 3 addresses, $0): SmartAccountRelayer: the signer must be authorizedCaller, fixed in the code / SmartAccountRelayer.recoverSigner: returns the signer. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
