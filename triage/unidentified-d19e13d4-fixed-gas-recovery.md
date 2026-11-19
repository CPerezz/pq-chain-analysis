---
id: unidentified-d19e13d4-fixed-gas-recovery
title: "4 contract families (8 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-d19e13d4
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc32a2cf6a927d395f4a3ebd04b6ea84337521d1d"
  name: "LedgerRandomProofVerifier (study family adf52f5a), 1 of 4 addresses running it"
  upgradeable: "unknown"
- address: "0x1872b33bb33e372d6f039a8b6af2e1be228bda23"
  name: "LedgerRandomProofVerifier (study family c3529bc6), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x38f8e42659ea40a36096cd6db69ae24ab2562f52"
  name: "LedgerRandomProofVerifier (study family f26b9b68)"
  upgradeable: "unknown"
- address: "0x335ce71e5bb8351800459ceab23a15036ab267eb"
  name: "unverified code (study family 306d2771)"
  upgradeable: "unknown"
families:
- code: "0xc32a2cf6a927d395f4a3ebd04b6ea84337521d1d"
  name: "LedgerRandomProofVerifier (study family adf52f5a)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
- code: "0x1872b33bb33e372d6f039a8b6af2e1be228bda23"
  name: "LedgerRandomProofVerifier (study family c3529bc6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families adf52f5a, c3529bc6, f26b9b68, 306d2771"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 4 code families, 8 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc32a2cf6a927d395f4a3ebd04b6ea84337521d1d` (LedgerRandomProofVerifier, family `adf52f5a`, 4 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1872b33bb33e372d6f039a8b6af2e1be228bda23` (LedgerRandomProofVerifier, family `c3529bc6`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x38f8e42659ea40a36096cd6db69ae24ab2562f52` (LedgerRandomProofVerifier, family `f26b9b68`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x335ce71e5bb8351800459ceab23a15036ab267eb` (unverified, family `306d2771`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
