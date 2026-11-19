---
id: unidentified-ae30634d-fixed-gas-recovery
title: "Unverified contract 0x7c0bfd…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-ae30634d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x7c0bfdf96a77d05aa8b037f1b19da8f40fab42c3"
  name: "unverified code (study family fb45f9f7)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fb45f9f7"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x7c0bfdf96a77d05aa8b037f1b19da8f40fab42c3` (unverified, family `fb45f9f7`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
