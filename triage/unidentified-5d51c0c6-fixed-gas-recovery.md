---
id: unidentified-5d51c0c6-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-5d51c0c6
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xbf43a3f0777bf04f9820380b6e4df6e692f7ddb7"
  name: "RNG (study family b00e432e)"
  upgradeable: "unknown"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xab3cb4b53f2c77efd6d3c0c0b002317b1825dc3a"
  name: "unverified code (study family 2bdf0b69)"
  upgradeable: "unknown"
- address: "0x27f86204b9280a5b77c9f6d013555c867aba9a6c"
  name: "RNG (study family 434ef726)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b00e432e, 2bdf0b69, 434ef726"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $2k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xbf43a3f0777bf04f9820380b6e4df6e692f7ddb7` (RNG, family `b00e432e`, 1 address, $2k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xab3cb4b53f2c77efd6d3c0c0b002317b1825dc3a` (unverified, family `2bdf0b69`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x27f86204b9280a5b77c9f6d013555c867aba9a6c` (RNG, family `434ef726`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
