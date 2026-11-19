---
id: unidentified-b0fd1b4b-fixed-gas-recovery
title: "8 contract families (10 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b0fd1b4b
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb4b71bd698422fe8f1d3aaf694a422b45fc425d6"
  name: "BitrueRaffleNumber (study family c51555c0), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x31cb660a3dce9d1d702e8aa6e881fc9e5cb2877d"
  name: "unverified code (study family 7958e252)"
  upgradeable: "unknown"
- address: "0x1aee1fe9146cdcdb7776e9f5ffb19e21a1b73824"
  name: "unverified code (study family 2f7abdd1)"
  upgradeable: "unknown"
- address: "0x915eeb333de7a217df33b7bc0fb0a60a0b086f2b"
  name: "unverified code (study family 85a80dc2), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x73f423ab3fc16213055b5df765b297354eeb04ac"
  name: "unverified code (study family 03d955f2)"
  upgradeable: "unknown"
- address: "0xea6af92839cf5a0e8b4e6873d58634681cf701d1"
  name: "BitrueRaffleNumber (study family 6d3396a9)"
  upgradeable: "unknown"
- address: "0xa8ec8a4a59b618f89a1715eab405d9377b5cb06d"
  name: "unverified code (study family eef1df18)"
  upgradeable: "unknown"
- address: "0x56b8a62208835dfad921882d80e014c8e0363fe4"
  name: "unverified code (study family c9aec734)"
  upgradeable: "unknown"
families:
- code: "0xb4b71bd698422fe8f1d3aaf694a422b45fc425d6"
  name: "BitrueRaffleNumber (study family c51555c0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x915eeb333de7a217df33b7bc0fb0a60a0b086f2b"
  name: "unverified code (study family 85a80dc2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c51555c0, 7958e252, 2f7abdd1, 85a80dc2, 03d955f2, 6d3396a9, eef1df18, c9aec734"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 8 code families, 10 addresses, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xb4b71bd698422fe8f1d3aaf694a422b45fc425d6` (BitrueRaffleNumber, family `c51555c0`, 2 addresses, $1k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x31cb660a3dce9d1d702e8aa6e881fc9e5cb2877d` (unverified, family `7958e252`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1aee1fe9146cdcdb7776e9f5ffb19e21a1b73824` (unverified, family `2f7abdd1`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x915eeb333de7a217df33b7bc0fb0a60a0b086f2b` (unverified, family `85a80dc2`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x73f423ab3fc16213055b5df765b297354eeb04ac` (unverified, family `03d955f2`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xea6af92839cf5a0e8b4e6873d58634681cf701d1` (BitrueRaffleNumber, family `6d3396a9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa8ec8a4a59b618f89a1715eab405d9377b5cb06d` (unverified, family `eef1df18`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x56b8a62208835dfad921882d80e014c8e0363fe4` (unverified, family `c9aec734`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
