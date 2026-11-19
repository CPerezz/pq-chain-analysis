---
id: unidentified-14ce9458-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-14ce9458
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x9a9c62cc05ceb3c189c43b18b070821794db6944"
  name: "unverified code (study family fb873e34), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0xeda2b1cc85743ad07d6eb8e5a22cdbe142c10e6d"
  name: "EthereumPot (study family 24a0bbf9)"
  upgradeable: "unknown"
- address: "0x5a13caa82851342e14cd2ad0257707cddb8a31b7"
  name: "EthereumPot (study family 0261295d)"
  upgradeable: "unknown"
families:
- code: "0x9a9c62cc05ceb3c189c43b18b070821794db6944"
  name: "unverified code (study family fb873e34)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fb873e34, 24a0bbf9, 0261295d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x9a9c62cc05ceb3c189c43b18b070821794db6944` (unverified, family `fb873e34`, 2 addresses, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xeda2b1cc85743ad07d6eb8e5a22cdbe142c10e6d` (EthereumPot, family `24a0bbf9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x5a13caa82851342e14cd2ad0257707cddb8a31b7` (EthereumPot, family `0261295d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
