---
id: unidentified-066931a6-signature-rechecked
title: "Unverified contract 0x1f53de…: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-066931a6
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x1f53de95888a82aaae1d90741009a559c107dce6"
  name: "unverified code (study family 017a2365)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 017a2365"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x1f53de95888a82aaae1d90741009a559c107dce6` (unverified, family `017a2365`, 1 address, $0): payment links (2 recoveries): a link created with a signer can be claimed with its signature later; a signer with code voids unclaimed links (inferred). Decided by: bytecode and names (no source).
