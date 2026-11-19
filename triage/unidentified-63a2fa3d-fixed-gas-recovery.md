---
id: unidentified-63a2fa3d-fixed-gas-recovery
title: "6 contract families (7 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-63a2fa3d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x6a64f8fc5d2afa0dbacee0716dff1a1d62875ff8"
  name: "unverified code (study family c910964b)"
  upgradeable: "unknown"
- address: "0x44093e02e18e5df0104bdcf27c2b52262fb4efac"
  name: "unverified code (study family 8b7c2aa5), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x3bded2a7b1007170dde21f7f602696c090cd32e0"
  name: "unverified code (study family d5db32d8)"
  upgradeable: "unknown"
- address: "0x4064156ace92a95723f1d6d50b875023e133c5b3"
  name: "unverified code (study family 7c1e7a6f)"
  upgradeable: "unknown"
- address: "0x4337e45eadb70fbde5d3877b644801f3d360e519"
  name: "unverified code (study family 2d0b135c)"
  upgradeable: "unknown"
- address: "0x56ba14327bd88b82f3c65be145c1aa0df2fc9622"
  name: "unverified code (study family 605ad0c4)"
  upgradeable: "unknown"
families:
- code: "0x44093e02e18e5df0104bdcf27c2b52262fb4efac"
  name: "unverified code (study family 8b7c2aa5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c910964b, 8b7c2aa5, d5db32d8, 7c1e7a6f, 2d0b135c, 605ad0c4"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 6 code families, 7 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x6a64f8fc5d2afa0dbacee0716dff1a1d62875ff8` (unverified, family `c910964b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x44093e02e18e5df0104bdcf27c2b52262fb4efac` (unverified, family `8b7c2aa5`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x3bded2a7b1007170dde21f7f602696c090cd32e0` (unverified, family `d5db32d8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x4064156ace92a95723f1d6d50b875023e133c5b3` (unverified, family `7c1e7a6f`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x4337e45eadb70fbde5d3877b644801f3d360e519` (unverified, family `2d0b135c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x56ba14327bd88b82f3c65be145c1aa0df2fc9622` (unverified, family `605ad0c4`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
