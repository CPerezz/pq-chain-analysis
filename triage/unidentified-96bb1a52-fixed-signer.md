---
id: unidentified-96bb1a52-fixed-signer
title: "Depositor: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-96bb1a52
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2017ec9ac39c949f3d372ff5202fbac4d99c6e4f"
  name: "Depositor (study family fe86201c)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fe86201c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x2017ec9ac39c949f3d372ff5202fbac4d99c6e4f` (Depositor, family `fe86201c`, 1 address, $0): Depositor batchDeposit: each deposit must be signed by `authority`, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
