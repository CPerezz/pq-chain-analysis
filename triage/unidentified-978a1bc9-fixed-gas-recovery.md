---
id: unidentified-978a1bc9-fixed-gas-recovery
title: "2 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-978a1bc9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x06e24feeaab8ff9b436dc466351852e972eef3ba"
  name: "EtherHiLo (study family b930c775)"
  upgradeable: "unknown"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0848e6daa36a515005b1e0b45732212ca4a6efaa"
  name: "EtherHiLoRandom (study family f6982e5d), 1 of 3 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x0848e6daa36a515005b1e0b45732212ca4a6efaa"
  name: "EtherHiLoRandom (study family f6982e5d)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b930c775, f6982e5d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 4 addresses, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x06e24feeaab8ff9b436dc466351852e972eef3ba` (EtherHiLo, family `b930c775`, 1 address, $1k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x0848e6daa36a515005b1e0b45732212ca4a6efaa` (EtherHiLoRandom, family `f6982e5d`, 3 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
