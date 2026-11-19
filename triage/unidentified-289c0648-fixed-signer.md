---
id: unidentified-289c0648-fixed-signer
title: "Unverified contract 0xe00d10…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-289c0648
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe00d101d869348ffeed8519838e015e82f7e16b6"
  name: "unverified code (study family afacaa6c)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families afacaa6c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xe00d101d869348ffeed8519838e015e82f7e16b6` (unverified, family `afacaa6c`, 1 address, $0): ERC-1271 contract answering for a signer that is a constant in its code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
