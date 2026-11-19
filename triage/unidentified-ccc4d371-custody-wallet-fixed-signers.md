---
id: unidentified-ccc4d371-custody-wallet-fixed-signers
title: "83 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-ccc4d371
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8e3a4a7208aa489cc0a1c7290070811b07e60c87"
  name: "unverified code (study family 6e908382), 1 of 83 addresses running it"
  upgradeable: "no"
families:
- code: "0x8e3a4a7208aa489cc0a1c7290070811b07e60c87"
  name: "unverified code (study family 6e908382)"
  instances: 83
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 13172205
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6e908382"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 83 addresses, $13.2M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0x8e3a4a7208aa489cc0a1c7290070811b07e60c87` (unverified, family `6e908382`, 83 addresses, $13.2M): 83 wallets holding 7,299 ETH in the BitGo pattern: a stored signer other than the caller; no function name that changes signers. Decided by: bytecode and names (no source).
