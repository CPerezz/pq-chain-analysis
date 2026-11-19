---
id: unidentified-beed5427-signature-rechecked
title: "M4Arena: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-beed5427
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xafbfd4e71045a12ee032848d9f965efc16a7d2af"
  name: "M4Arena (study family 33633495)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 33633495"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xafbfd4e71045a12ee032848d9f965efc16a7d2af` (M4Arena, family `33633495`, 1 address, $0): a game settled by co-signed turns: each side registers a key for the fight; _cheat (read) makes a side lose when it signed a seal other than the one on chain, and _replay needs both sides' signatures on every turn. Decided by: read.
