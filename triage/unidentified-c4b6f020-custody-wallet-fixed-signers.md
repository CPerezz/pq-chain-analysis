---
id: unidentified-c4b6f020-custody-wallet-fixed-signers
title: "622 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-c4b6f020
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x40f9f920ece7cce223625c088a6c1281ef396cf2"
  name: "unverified code (study family 41d5f6fd), 1 of 622 addresses running it"
  upgradeable: "no"
families:
- code: "0x40f9f920ece7cce223625c088a6c1281ef396cf2"
  name: "unverified code (study family 41d5f6fd)"
  instances: 622
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 53099178
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 41d5f6fd"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 622 addresses, $53.1M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0x40f9f920ece7cce223625c088a6c1281ef396cf2` (unverified, family `41d5f6fd`, 622 addresses, $53.1M): 622 multisig wallets holding 29,425 ETH: ordered signatures of owners (getOwners, isOwner, threshold, execute); no function name that changes the owners. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
