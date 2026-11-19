---
id: unidentified-9e4a158a-custody-wallet-fixed-signers
title: "31 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-9e4a158a
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2cc81b80a293408a89084c77a0983de0730f731a"
  name: "unverified code (study family daae4066), 1 of 31 addresses running it"
  upgradeable: "no"
families:
- code: "0x2cc81b80a293408a89084c77a0983de0730f731a"
  name: "unverified code (study family daae4066)"
  instances: 31
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 47981987
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families daae4066"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 31 addresses, $48.0M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0x2cc81b80a293408a89084c77a0983de0730f731a` (unverified, family `daae4066`, 31 addresses, $48.0M): 31 wallets holding 26,589 ETH: signers in storage (isSigner, signers), a loop of recoveries; no function name that changes them. Decided by: bytecode and names (no source).
