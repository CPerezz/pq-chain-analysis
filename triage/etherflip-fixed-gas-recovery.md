---
id: etherflip-fixed-gas-recovery
title: "EtherFlip: under EIP-8151 every valid signature fails on activation day"
project: etherflip
status: candidate
severity: MEDIUM
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xe5a04d98538231b0fab9aba60cd73ce4ff3039df"
  name: "EtherFlip (study family 0fa7b998)"
  upgradeable: "no"
  value_usd: 1359014
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0fa7b998"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $1.4M held. Rated by hand: read: the owner moves the bankroll with refundTransfer, no signature needed.

## Evidence

- `0xe5a04d98538231b0fab9aba60cd73ce4ff3039df` (EtherFlip, family `0fa7b998`, 1 address, $1.4M): Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile /… Decided by: read (function text).
