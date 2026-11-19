---
id: ownbit-wallet-fixed-signers
title: "7 contract families (531 addresses): under EIP-8151 wallets lock once their fixed signers take code"
project: ownbit
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf71b3e5bb29cd7a81e51bd1af8e8ab2693a6b34f"
  name: "OwnbitMultiSigImplementation (study family 66d724c3), 1 of 158 addresses running it"
  upgradeable: "no"
- address: "0xbda946f67a7afe62950b42aab151ca34c05e56b6"
  name: "OwnbitMultiSig (study family bd7bb1ad), 1 of 139 addresses running it"
  upgradeable: "no"
- address: "0xccee72a5e5ad695c1fe1e545537990e45b1bc005"
  name: "OwnbitMultiSig (study family 0464e742), 1 of 138 addresses running it"
  upgradeable: "no"
- address: "0xf2c5001639628e63c866815e55ab5cb24bb3cae4"
  name: "OwnbitMultiSigImplementation (study family 3180553b), 1 of 8 addresses running it"
  upgradeable: "no"
- address: "0x476adbaed7d11bafd5c3790d243ced52717c4b59"
  name: "OwnbitMultiSigImplementation (study family 0a0deb27), 1 of 16 addresses running it"
  upgradeable: "no"
- address: "0x9d3e5cbd5b2f2af1c1d6cff63c7ea3a8894ad79f"
  name: "OwnbitMultiSig (study family 2ea7385b), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0x0f498806617efa9c5fbd201320d21d43dd47bf00"
  name: "OwnbitMultiSig (study family cd492812), 1 of 66 addresses running it"
  upgradeable: "no"
families:
- code: "0xf71b3e5bb29cd7a81e51bd1af8e8ab2693a6b34f"
  name: "OwnbitMultiSigImplementation (study family 66d724c3)"
  instances: 158
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3981040
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbda946f67a7afe62950b42aab151ca34c05e56b6"
  name: "OwnbitMultiSig (study family bd7bb1ad)"
  instances: 139
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1322201
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xccee72a5e5ad695c1fe1e545537990e45b1bc005"
  name: "OwnbitMultiSig (study family 0464e742)"
  instances: 138
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 564105
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf2c5001639628e63c866815e55ab5cb24bb3cae4"
  name: "OwnbitMultiSigImplementation (study family 3180553b)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 511232
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x476adbaed7d11bafd5c3790d243ced52717c4b59"
  name: "OwnbitMultiSigImplementation (study family 0a0deb27)"
  instances: 16
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 101236
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9d3e5cbd5b2f2af1c1d6cff63c7ea3a8894ad79f"
  name: "OwnbitMultiSig (study family 2ea7385b)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0f498806617efa9c5fbd201320d21d43dd47bf00"
  name: "OwnbitMultiSig (study family cd492812)"
  instances: 66
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 66d724c3, bd7bb1ad, 0464e742, 3180553b, 0a0deb27, 2ea7385b, cd492812"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 7 code families, 531 addresses, $6.5M held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xf71b3e5bb29cd7a81e51bd1af8e8ab2693a6b34f` (OwnbitMultiSigImplementation, family `66d724c3`, 158 addresses, $4.0M): Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0xbda946f67a7afe62950b42aab151ca34c05e56b6` (OwnbitMultiSig, family `bd7bb1ad`, 139 addresses, $1.3M): Ownbit multisig (older): `required` distinct owners by ECDSA; no function changes the owners. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0xccee72a5e5ad695c1fe1e545537990e45b1bc005` (OwnbitMultiSig, family `0464e742`, 138 addresses, $564k): Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0xf2c5001639628e63c866815e55ab5cb24bb3cae4` (OwnbitMultiSigImplementation, family `3180553b`, 8 addresses, $511k): Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners / Ownbit standard multisig _recoverPacked: returns the signer or zero / Ownbit standard… Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0x476adbaed7d11bafd5c3790d243ced52717c4b59` (OwnbitMultiSigImplementation, family `0a0deb27`, 16 addresses, $101k): Ownbit multisig (variant): distinct owners by ECDSA; no function changes the owners, but owners inactive for long lower the number required. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0x9d3e5cbd5b2f2af1c1d6cff63c7ea3a8894ad79f` (OwnbitMultiSig, family `2ea7385b`, 6 addresses, $10k): Ownbit multisig (variant with inactivity): distinct owners by ECDSA; owners cannot be changed, inactive ones lower the number required. Decided by: read (function text).
- `0x0f498806617efa9c5fbd201320d21d43dd47bf00` (OwnbitMultiSig, family `cd492812`, 66 addresses, $8k): Ownbit multisig (older variant with inactivity). Decided by: read (function text).
