---
id: unidentified-d8f46971-wallet-fixed-signers
title: "62 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-d8f46971
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfdffb38544dc145795e9ea2b82fc3dcb3c72e59c"
  name: "unverified code (study family 75aebbd4), 1 of 62 addresses running it"
  upgradeable: "no"
families:
- code: "0xfdffb38544dc145795e9ea2b82fc3dcb3c72e59c"
  name: "unverified code (study family 75aebbd4)"
  instances: 62
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 70558
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 75aebbd4"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 62 addresses, $71k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xfdffb38544dc145795e9ea2b82fc3dcb3c72e59c` (unverified, family `75aebbd4`, 62 addresses, $71k): multisig wallets (62, 39 ETH with tokens): owners and threshold fixed at creation; an owner with code cannot sign, so funds must move before owners migrate. Decided by: bytecode and names (no source).
