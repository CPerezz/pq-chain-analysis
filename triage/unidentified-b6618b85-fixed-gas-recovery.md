---
id: unidentified-b6618b85-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b6618b85
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x088af5cf29595ac339f1a73eb9cbee2359d51bae"
  name: "unverified code (study family fa3fc198)"
  upgradeable: "unknown"
- address: "0xed340c0c30afb421c4165a90d0c69af8c1de99e4"
  name: "emojiRandomGame (study family 67086ea6)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fa3fc198, 67086ea6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x088af5cf29595ac339f1a73eb9cbee2359d51bae` (unverified, family `fa3fc198`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xed340c0c30afb421c4165a90d0c69af8c1de99e4` (emojiRandomGame, family `67086ea6`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
