---
id: unidentified-67decb8b-fixed-gas-recovery
title: "11 contract families (31 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-67decb8b
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xe150b693404a433b1c822c113f3fa84fe8e2c255"
  name: "GAME (study family f64ec9dc), 1 of 19 addresses running it"
  upgradeable: "no"
- address: "0x06c2eec9ce3188301757531aee971fdbb9a7f0b1"
  name: "BONUSROLL (study family ed3fae76), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x89ddbf934890b6dfe6205f4ff93f4bbe678c4160"
  name: "unverified code (study family 84ff6843), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0xb1829ff3f01e0c594b9e1324e1f7574c7e136d69"
  name: "unverified code (study family fdbe00d9)"
  upgradeable: "unknown"
- address: "0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0"
  name: "unverified code (study family b1a8a1db)"
  upgradeable: "unknown"
- address: "0x227d4d8a46f97b47101dd445148e3ebf6660fede"
  name: "unverified code (study family 6e5281da)"
  upgradeable: "unknown"
- address: "0x504cf0215aeb20ef058a79880e2a5bfd8525254f"
  name: "unverified code (study family fef58f25)"
  upgradeable: "unknown"
- address: "0xed44676ef37fdbbd7f272542e529e8f99f1fd61f"
  name: "unverified code (study family 8681b53b)"
  upgradeable: "unknown"
- address: "0x7af05ffe5f5d144fe89a425af81bae6f9c7f6853"
  name: "unverified code (study family 261d2f0a)"
  upgradeable: "unknown"
- address: "0xa8956a6ca605f16aec8e72848655fae24cf032d9"
  name: "unverified code (study family 7ae302a9)"
  upgradeable: "unknown"
- address: "0x8b1e6a33be6bb447ef4c6ad4b7051cd99e12d484"
  name: "unverified code (study family c009392d)"
  upgradeable: "unknown"
families:
- code: "0xe150b693404a433b1c822c113f3fa84fe8e2c255"
  name: "GAME (study family f64ec9dc)"
  instances: 19
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x06c2eec9ce3188301757531aee971fdbb9a7f0b1"
  name: "BONUSROLL (study family ed3fae76)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
- code: "0x89ddbf934890b6dfe6205f4ff93f4bbe678c4160"
  name: "unverified code (study family 84ff6843)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f64ec9dc, ed3fae76, 84ff6843, fdbe00d9, b1a8a1db, 6e5281da, fef58f25, 8681b53b, 261d2f0a, 7ae302a9, c009392d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 11 code families, 31 addresses, $5k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xe150b693404a433b1c822c113f3fa84fe8e2c255` (GAME, family `f64ec9dc`, 19 addresses, $5k): Oraclize verifySig (variant): the recovered address must be the address of the public key carried in the proof; the result flag is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile; returns what… Decided by: read (function text).
- `0x06c2eec9ce3188301757531aee971fdbb9a7f0b1` (BONUSROLL, family `ed3fae76`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x89ddbf934890b6dfe6205f4ff93f4bbe678c4160` (unverified, family `84ff6843`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xb1829ff3f01e0c594b9e1324e1f7574c7e136d69` (unverified, family `fdbe00d9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0` (unverified, family `b1a8a1db`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x227d4d8a46f97b47101dd445148e3ebf6660fede` (unverified, family `6e5281da`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x504cf0215aeb20ef058a79880e2a5bfd8525254f` (unverified, family `fef58f25`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xed44676ef37fdbbd7f272542e529e8f99f1fd61f` (unverified, family `8681b53b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7af05ffe5f5d144fe89a425af81bae6f9c7f6853` (unverified, family `261d2f0a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa8956a6ca605f16aec8e72848655fae24cf032d9` (unverified, family `7ae302a9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x8b1e6a33be6bb447ef4c6ad4b7051cd99e12d484` (unverified, family `c009392d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
