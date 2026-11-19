---
id: unidentified-07ca46b1-fixed-signer
title: "87 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-07ca46b1
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb599ab9a8c771dbed6d58a29156bac6d36dce891"
  name: "unverified code (study family e2ef51e8), 1 of 87 addresses running it"
  upgradeable: "no"
families:
- code: "0xb599ab9a8c771dbed6d58a29156bac6d36dce891"
  name: "unverified code (study family e2ef51e8)"
  instances: 87
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e2ef51e8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 87 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb599ab9a8c771dbed6d58a29156bac6d36dce891` (unverified, family `e2ef51e8`, 87 addresses, $0): 87 contracts checking two signers (signerA, signerB) that are constants in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
