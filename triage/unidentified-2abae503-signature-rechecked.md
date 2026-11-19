---
id: unidentified-2abae503-signature-rechecked
title: "Unverified contract 0x0dba77…: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-2abae503
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x0dba77b066816a8528dea8659a9896e2fdd798dc"
  name: "unverified code (study family 803f5b90)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 803f5b90"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x0dba77b066816a8528dea8659a9896e2fdd798dc` (unverified, family `803f5b90`, 1 address, $0): a proof checker (31 recoveries) that accepts statements signed by recovered parties; who they must be is not established. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
