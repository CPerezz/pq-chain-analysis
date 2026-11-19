---
id: unidentified-fe6959cb-fixed-gas-recovery
title: "Unverified contract 0x4ec0e4…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-fe6959cb
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x4ec0e441270db6f6c3c1cf08af2d9e1e92474883"
  name: "unverified code (study family c56e59d7)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c56e59d7"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x4ec0e441270db6f6c3c1cf08af2d9e1e92474883` (unverified, family `c56e59d7`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
