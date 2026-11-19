---
id: unidentified-7781779f-fixed-signer
title: "Unverified contract 0x09c6dd…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-7781779f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x09c6dd9f7edd76685127f321b6bfd3e1401c6028"
  name: "unverified code (study family 9e5fd0c9)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9e5fd0c9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x09c6dd9f7edd76685127f321b6bfd3e1401c6028` (unverified, family `9e5fd0c9`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
