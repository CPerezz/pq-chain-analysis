---
id: unidentified-165c74e3-fixed-gas-recovery
title: "3 contract families (6 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-165c74e3
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x2948002e609e5b5e286b91f1d47bb924c4274b69"
  name: "EtherFlipRaffleToken (study family 93941d18), 1 of 4 addresses running it"
  upgradeable: "unknown"
- address: "0x61968339a34c727c1887040a16fe7d715f4667ac"
  name: "unverified code (study family abad198c)"
  upgradeable: "unknown"
- address: "0x3c9680f1ef75693f22de279c1fb35067fc15e2fa"
  name: "EtherFlipLite (study family ef9bceac)"
  upgradeable: "unknown"
families:
- code: "0x2948002e609e5b5e286b91f1d47bb924c4274b69"
  name: "EtherFlipRaffleToken (study family 93941d18)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 93941d18, abad198c, ef9bceac"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 6 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x2948002e609e5b5e286b91f1d47bb924c4274b69` (EtherFlipRaffleToken, family `93941d18`, 4 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x61968339a34c727c1887040a16fe7d715f4667ac` (unverified, family `abad198c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x3c9680f1ef75693f22de279c1fb35067fc15e2fa` (EtherFlipLite, family `ef9bceac`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
