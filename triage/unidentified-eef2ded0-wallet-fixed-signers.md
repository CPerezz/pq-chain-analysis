---
id: unidentified-eef2ded0-wallet-fixed-signers
title: "2 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-eef2ded0
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x844a936bd00b07b9b3c2a3fae3f199c96c01036d"
  name: "unverified code (study family a3cb30ad), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x844a936bd00b07b9b3c2a3fae3f199c96c01036d"
  name: "unverified code (study family a3cb30ad)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 624197
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a3cb30ad"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 2 addresses, $624k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x844a936bd00b07b9b3c2a3fae3f199c96c01036d` (unverified, family `a3cb30ad`, 2 addresses, $624k): BitGo pattern (isSigner, sendMultiSig), 346 ETH. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
