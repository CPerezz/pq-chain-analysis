---
id: unidentified-142a1615-fixed-gas-recovery
title: "Casino (2 copies): under EIP-8151 every valid signature fails on activation day"
project: unidentified-142a1615
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x20edeb88f0a2379957ff2011702538eca721d3b8"
  name: "Casino (study family 65a51c97), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x20edeb88f0a2379957ff2011702538eca721d3b8"
  name: "Casino (study family 65a51c97)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 65a51c97"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x20edeb88f0a2379957ff2011702538eca721d3b8` (Casino, family `65a51c97`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
