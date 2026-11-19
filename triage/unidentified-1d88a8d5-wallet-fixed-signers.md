---
id: unidentified-1d88a8d5-wallet-fixed-signers
title: "74 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-1d88a8d5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x06a4ef39e077471214e4a8bfa0cbbe34e88849a2"
  name: "unverified code (study family cd61b9c1), 1 of 74 addresses running it"
  upgradeable: "no"
families:
- code: "0x06a4ef39e077471214e4a8bfa0cbbe34e88849a2"
  name: "unverified code (study family cd61b9c1)"
  instances: 74
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 35730
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cd61b9c1"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 74 addresses, $36k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x06a4ef39e077471214e4a8bfa0cbbe34e88849a2` (unverified, family `cd61b9c1`, 74 addresses, $36k): 74 wallets: signers in a stored set (signerNum); no function name that changes them. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
