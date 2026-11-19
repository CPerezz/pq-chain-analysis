---
id: unidentified-22754561-fixed-signer
title: "CreepzInvasionPass: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-22754561
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf3ec2d6394fc899a5dc1823a205670ebb30939cc"
  name: "CreepzInvasionPass (study family 5cab1fff)"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5cab1fff"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xf3ec2d6394fc899a5dc1823a205670ebb30939cc` (CreepzInvasionPass, family `5cab1fff`, 1 address, $5k): Creepz pass: signed by signerAddress, set in the constructor. Decided by: read.
