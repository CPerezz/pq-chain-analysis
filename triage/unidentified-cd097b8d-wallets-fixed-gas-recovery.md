---
id: unidentified-cd097b8d-wallets-fixed-gas-recovery
title: "18,825 two-signature wallets give ecrecover 3,072 gas: under EIP-8151 nothing they hold can move again"
project: unidentified-cd097b8d
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x94fde2d6ac81379872dc6c7a1a6b9226662dacd2"
  implementation: null
  name: two-signature wallet (unverified), the one replayed
  upgradeable: "no"
  admin: "none: no DELEGATECALL, SELFDESTRUCT or CREATE; owner changes are self-calls"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: null
- address: "0xfd1e02b42694e845fbf28741e5ce9881507d9551"
  implementation: null
  name: two-signature wallet (same code), the largest balance
  upgradeable: "no"
  admin: "none"
  value_usd: 2327
  value_basis: held
  value_as_of: 2026-11-18
  last_active: null
  txs_30d: null
families:
- code: "0x94fde2d6ac81379872dc6c7a1a6b9226662dacd2"
  name: "runtime code hash 0x46550840f29528f1c203e196cc1082e1c1423c7cddb471748db9517c485ca81d"
  instances: 17653
  list: "addresses created by factory 0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59 with this code"
  upgradeable: "no"
  value_usd: 4719
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x016c670f5cacf03515d9f6c2fb6bf34f6a5ca5cf"
  name: "runtime code hash 0x08b417379dea69621e151474a028a33ed19219a26491e1387695cf7e130d59e1"
  instances: 1168
  list: "addresses created by factory 0x6ccab97ec94f8158fda451c5504db728adad7dc2 with this code"
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0x276164d5121df16e039c90f74c4b65d225c65635"
  name: "runtime code hash 0xaf293bbb5e21635401653fe5bca367b5721479e3c22fe6070f3e1bedca869583"
  instances: 4
  list: "four addresses"
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: "each wallet's owner and co-signer: move everything out before EIP-8151 is active"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (bytecode read, one real transaction replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed-gas list"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

Wallets from two factories (2019–2021) check two signatures with `ecrecover` and give each check exactly 3,072
gas. Under EIP-8151 a recovery costs 3,200 or 6,100, so every check fails and the wallet hits `INVALID`; both
asset functions and all owner changes pass through it. Immutable: from activation nothing they hold can move.

## Mechanism

PQ-14. One recovery routine, entered from `transferErc20` and the general call (`0x9d55b53f`); owner setters accept
only self-calls, which need the same signatures.

## Evidence

- Bytecode of `0x94fde2d6…` (block 26,438,999), pc 187–207: `PUSH2 0x0c00` (3,072), `STATICCALL` to `0x01`,
  `INVALID` on failure. No `DELEGATECALL`, `SELFDESTRUCT`, `CREATE`.
- Executed (reference implementation of the fork, only the precompile changed): tx
  `0x0323ebe3274b24b64ec6193d93729c9a37fecb1371d921cfd6d7dc98628dbd0f` (block 26,432,607): today success, 64,082
  gas, equal to the receipt; under EIP-8151 `INVALID`, the whole 200,000 used.
- 18,825 addresses with the three codes; 149 recovered a signature after block 22,000,000.

## Impact and exposure

17 wallets hold about USD 4,700 in ETH and 49 large tokens (other tokens not counted). Each wallet is one owner's;
the project is not identified.

## Remediation

Owners move assets out before activation. The contracts cannot change.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; proposed rating LOW → HIGH: value and activity no longer lower a rating; each
  wallet holds one owner's funds.
