---
id: unidentified-ec0d3d2d-fixed-gas-recovery
title: "2 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-ec0d3d2d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x95dd2d11d85ebe7fcfad4f06d1cd45220ab2c48d"
  name: "EJackpot (study family 06752083), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x1d02f74ca991e415916afab11c4d853784df8d9e"
  name: "GuessGame (study family 9b92410f), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x95dd2d11d85ebe7fcfad4f06d1cd45220ab2c48d"
  name: "EJackpot (study family 06752083)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
- code: "0x1d02f74ca991e415916afab11c4d853784df8d9e"
  name: "GuessGame (study family 9b92410f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 06752083, 9b92410f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x95dd2d11d85ebe7fcfad4f06d1cd45220ab2c48d` (EJackpot, family `06752083`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1d02f74ca991e415916afab11c4d853784df8d9e` (GuessGame, family `9b92410f`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
