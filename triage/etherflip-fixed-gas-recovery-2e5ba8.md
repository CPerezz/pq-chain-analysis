---
id: etherflip-fixed-gas-recovery-2e5ba8
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: etherflip
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x48d8f22d45e40f34cb7c10799f31246f134e9b7f"
  name: "EtherFlipGold (study family 2e5ba8f7)"
  upgradeable: "no"
  value_usd: 29053
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xffc08dd84a66775e6236e0a80ee2f340e0042f8c"
  name: "EtherFlip (study family 2bb5ed98)"
  upgradeable: "unknown"
- address: "0x3023d5ee05ebee74b61f940433b7783eac1f221e"
  name: "EtherFlip (study family b510c254)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2e5ba8f7, 2bb5ed98, b510c254"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $29k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x48d8f22d45e40f34cb7c10799f31246f134e9b7f` (EtherFlipGold, family `2e5ba8f7`, 1 address, $29k): Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile /… Decided by: read (function text).
- `0xffc08dd84a66775e6236e0a80ee2f340e0042f8c` (EtherFlip, family `2bb5ed98`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x3023d5ee05ebee74b61f940433b7783eac1f221e` (EtherFlip, family `b510c254`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
