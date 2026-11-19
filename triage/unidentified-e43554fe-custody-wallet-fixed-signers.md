---
id: unidentified-e43554fe-custody-wallet-fixed-signers
title: "2 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-e43554fe
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e"
  name: "unverified code (study family c8330e19), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e"
  name: "unverified code (study family c8330e19)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 36271836
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c8330e19"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 2 addresses, $36.3M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e` (unverified, family `c8330e19`, 2 addresses, $36.3M): 2 wallets holding 20,100 ETH: a loop of recoveries compared with stored signers (getSigners, THRESHOLD); no function name that changes them. Decided by: bytecode and names (no source).
