---
id: unidentified-c8ea531a-fixed-signer
title: "4 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c8ea531a
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc5e56340595360d8fe105c52c6a2bc192e6a39d8"
  name: "unverified code (study family f0840389), 1 of 4 addresses running it"
  upgradeable: "no"
families:
- code: "0xc5e56340595360d8fe105c52c6a2bc192e6a39d8"
  name: "unverified code (study family f0840389)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f0840389"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 4 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc5e56340595360d8fe105c52c6a2bc192e6a39d8` (unverified, family `f0840389`, 4 addresses, $0): ERC-1271 contract answering for a signer that is a constant in its code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
