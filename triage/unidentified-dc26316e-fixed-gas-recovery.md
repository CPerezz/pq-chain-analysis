---
id: unidentified-dc26316e-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-dc26316e
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x7d26e660c3e348e50386bcbf30475ebe4c8b2df5"
  name: "unverified code (study family ac50eb69), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x73fb4fb22a38e6a97756964430833a6388277417"
  name: "unverified code (study family 0fc0c103)"
  upgradeable: "unknown"
- address: "0xa9207c4a98d6b5133419d59f0fbe4d3eb512e05b"
  name: "unverified code (study family b18138d9)"
  upgradeable: "unknown"
families:
- code: "0x7d26e660c3e348e50386bcbf30475ebe4c8b2df5"
  name: "unverified code (study family ac50eb69)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ac50eb69, 0fc0c103, b18138d9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x7d26e660c3e348e50386bcbf30475ebe4c8b2df5` (unverified, family `ac50eb69`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x73fb4fb22a38e6a97756964430833a6388277417` (unverified, family `0fc0c103`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa9207c4a98d6b5133419d59f0fbe4d3eb512e05b` (unverified, family `b18138d9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
