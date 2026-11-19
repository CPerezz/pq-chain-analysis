---
id: unidentified-cfe47bb8-fixed-gas-recovery
title: "3 contract families (5 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-cfe47bb8
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1aaf4359f7dc140b7f0de66f0ca503b95a5f157b"
  name: "unverified code (study family 82a714cd), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0xedb69fe5c154eb74d1a5d48203b43086d812ad77"
  name: "unverified code (study family 6edef593)"
  upgradeable: "unknown"
- address: "0x4cfae03ad849ca169720256feab7e095498a53f0"
  name: "unverified code (study family 716b0b53), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x1aaf4359f7dc140b7f0de66f0ca503b95a5f157b"
  name: "unverified code (study family 82a714cd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
- code: "0x4cfae03ad849ca169720256feab7e095498a53f0"
  name: "unverified code (study family 716b0b53)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 82a714cd, 6edef593, 716b0b53"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 5 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1aaf4359f7dc140b7f0de66f0ca503b95a5f157b` (unverified, family `82a714cd`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xedb69fe5c154eb74d1a5d48203b43086d812ad77` (unverified, family `6edef593`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x4cfae03ad849ca169720256feab7e095498a53f0` (unverified, family `716b0b53`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
