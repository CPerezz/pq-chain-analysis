---
id: unidentified-948774fa-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-948774fa
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x88dc3f7554ef092ea5c750cec7dfd31d732a2794"
  name: "unverified code (study family fe3c3379), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x73acdc8ffb42fab481196604812ad8521bed29ca"
  name: "unverified code (study family cc47f632)"
  upgradeable: "unknown"
- address: "0xbd311e4e6edf55532d71a1a7265e4482ae391c9d"
  name: "unverified code (study family 58f9d6f8)"
  upgradeable: "unknown"
families:
- code: "0x88dc3f7554ef092ea5c750cec7dfd31d732a2794"
  name: "unverified code (study family fe3c3379)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fe3c3379, cc47f632, 58f9d6f8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x88dc3f7554ef092ea5c750cec7dfd31d732a2794` (unverified, family `fe3c3379`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x73acdc8ffb42fab481196604812ad8521bed29ca` (unverified, family `cc47f632`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbd311e4e6edf55532d71a1a7265e4482ae391c9d` (unverified, family `58f9d6f8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
