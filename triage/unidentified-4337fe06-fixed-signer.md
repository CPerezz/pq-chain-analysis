---
id: unidentified-4337fe06-fixed-signer
title: "Unverified contract 0xdca97b…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4337fe06
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xdca97b9a4b89f97543ffc1ecade03a3f8555ed56"
  name: "unverified code (study family 8e07e77f)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8e07e77f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xdca97b9a4b89f97543ffc1ecade03a3f8555ed56` (unverified, family `8e07e77f`, 1 address, $0): account whose signer is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
