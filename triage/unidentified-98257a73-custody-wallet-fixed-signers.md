---
id: unidentified-98257a73-custody-wallet-fixed-signers
title: "2 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-98257a73
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8c33d309157553d69413d98ea853424689c0c2b1"
  name: "unverified code (study family 051d3568), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x8c33d309157553d69413d98ea853424689c0c2b1"
  name: "unverified code (study family 051d3568)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9739391
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 051d3568"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 2 addresses, $9.7M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0x8c33d309157553d69413d98ea853424689c0c2b1` (unverified, family `051d3568`, 2 addresses, $9.7M): 2 multisig wallets holding 5,397 ETH, 1,098 recoveries in the window: ordered owner signatures (isOwner, threshold, execute); no function name that changes owners. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
