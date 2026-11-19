---
id: unidentified-606675c9-custody-wallet-fixed-signers
title: "139 unverified contracts with one code: under EIP-8151 custody wallets lock once their fixed signers take code"
project: unidentified-606675c9
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe978d95b437d75826aba2ed1a0bdb534f173e28c"
  name: "unverified code (study family 9ede059a), 1 of 139 addresses running it"
  upgradeable: "no"
families:
- code: "0xe978d95b437d75826aba2ed1a0bdb534f173e28c"
  name: "unverified code (study family 9ede059a)"
  instances: 139
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3067211
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9ede059a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract holds other people's money behind signers fixed in the code; once enough of them take code, nothing moves. 1 code family, 139 addresses, $3.1M held. Whose money: inferred from Etherscan tags on the wallets or from nearly all of it sitting in one wallet; tags are leads, not names. To settle the rating: how many signers must take code before it locks; who holds it.

## Evidence

- `0xe978d95b437d75826aba2ed1a0bdb534f173e28c` (unverified, family `9ede059a`, 139 addresses, $3.1M): 139 wallets holding 1,700 ETH: signers in a stored set (signerNum); no function name that changes them. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
