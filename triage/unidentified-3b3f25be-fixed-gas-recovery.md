---
id: unidentified-3b3f25be-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-3b3f25be
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x59d2dcd705da352f49798738d83035c12948f835"
  name: "Game (study family 942bf9d3)"
  upgradeable: "unknown"
- address: "0x47ff79b11cb1470329567360a9e065587d956ba3"
  name: "Game (study family aacb4978)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 942bf9d3, aacb4978"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x59d2dcd705da352f49798738d83035c12948f835` (Game, family `942bf9d3`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x47ff79b11cb1470329567360a9e065587d956ba3` (Game, family `aacb4978`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
