---
id: unidentified-ab58d311-fixed-gas-recovery
title: "4 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-ab58d311
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x4a3e0c60f7fa67e8b65c401ddbbf7c17fea5fe40"
  name: "EOSBetSlots (study family 73f409b8)"
  upgradeable: "unknown"
- address: "0x7e03b8f86b9cfade0328a4a2c7588a659972129b"
  name: "EOSBetDice (study family 24fc6767)"
  upgradeable: "unknown"
- address: "0x3e4ecfcfdabb36c1f0058694941801cbb11f6582"
  name: "EOSBetSlots (study family 4a4250e9)"
  upgradeable: "unknown"
- address: "0xb533ff572f5e33d04d02b149e7dcfe980e424c63"
  name: "EOSBetDice (study family 4ab55f3c)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 73f409b8, 24fc6767, 4a4250e9, 4ab55f3c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 4 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x4a3e0c60f7fa67e8b65c401ddbbf7c17fea5fe40` (EOSBetSlots, family `73f409b8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7e03b8f86b9cfade0328a4a2c7588a659972129b` (EOSBetDice, family `24fc6767`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x3e4ecfcfdabb36c1f0058694941801cbb11f6582` (EOSBetSlots, family `4a4250e9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xb533ff572f5e33d04d02b149e7dcfe980e424c63` (EOSBetDice, family `4ab55f3c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
