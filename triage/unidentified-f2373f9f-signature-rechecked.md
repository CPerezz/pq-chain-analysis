---
id: unidentified-f2373f9f-signature-rechecked
title: "Unverified contract 0x94cfc9…: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-f2373f9f
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x94cfc9954948b7dddfb4af79e5df48b4379ff27d"
  name: "unverified code (study family 910c41c1)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 910c41c1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x94cfc9954948b7dddfb4af79e5df48b4379ff27d` (unverified, family `910c41c1`, 1 address, $0): offers signed by their parties and settled later (3 recoveries). Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
