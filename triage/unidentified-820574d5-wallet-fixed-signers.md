---
id: unidentified-820574d5-wallet-fixed-signers
title: "6 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-820574d5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x06ac37833ee0eaad2ab4fac2d7bfcdc4234c9bce"
  name: "unverified code (study family 8b6d3b8c), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0x06ac37833ee0eaad2ab4fac2d7bfcdc4234c9bce"
  name: "unverified code (study family 8b6d3b8c)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8b6d3b8c"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 6 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x06ac37833ee0eaad2ab4fac2d7bfcdc4234c9bce` (unverified, family `8b6d3b8c`, 6 addresses, $0): BitGo pattern (signers, sendMultiSig) by its names. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
