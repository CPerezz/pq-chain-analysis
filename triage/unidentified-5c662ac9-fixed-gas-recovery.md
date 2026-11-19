---
id: unidentified-5c662ac9-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-5c662ac9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x0869d49644ce3fd53dcbfa824b3794c0b4ae3774"
  name: "Lottesy10eth (study family 81f2bc33)"
  upgradeable: "unknown"
- address: "0x7909f0b4a0c25f126f85e010aa573c64e5e2ebf9"
  name: "Lottesy10eth (study family ec4beda2)"
  upgradeable: "unknown"
- address: "0x162d558ac8f3b8aba5f549066ac81df4ddc912a2"
  name: "Lottesy10eth (study family edb8a366)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 81f2bc33, ec4beda2, edb8a366"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x0869d49644ce3fd53dcbfa824b3794c0b4ae3774` (Lottesy10eth, family `81f2bc33`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7909f0b4a0c25f126f85e010aa573c64e5e2ebf9` (Lottesy10eth, family `ec4beda2`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x162d558ac8f3b8aba5f549066ac81df4ddc912a2` (Lottesy10eth, family `edb8a366`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
