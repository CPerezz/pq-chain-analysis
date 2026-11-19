---
id: unidentified-3c6510f0-fixed-signer
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3c6510f0
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x36b7113079580a9949cb7de6e005c96971d8111f"
  name: "unverified code (study family 645c4390), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x36b7113079580a9949cb7de6e005c96971d8111f"
  name: "unverified code (study family 645c4390)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 645c4390"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x36b7113079580a9949cb7de6e005c96971d8111f` (unverified, family `645c4390`, 3 addresses, $0): an NFT burn-claim contract (1 recovery); inferred: claims signed by a fixed party. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
