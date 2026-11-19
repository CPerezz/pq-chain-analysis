---
id: unidentified-3cc29b79-wallet-fixed-signers
title: "Unverified contract 0x2d3f75…: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-3cc29b79
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2d3f75cedea57c1bc223af77807fdbdfd5b7ce40"
  name: "unverified code (study family 39bc549f)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 39bc549f"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x2d3f75cedea57c1bc223af77807fdbdfd5b7ce40` (unverified, family `39bc549f`, 1 address, $0): multisig with ordered owner signatures; no function name that changes owners. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
