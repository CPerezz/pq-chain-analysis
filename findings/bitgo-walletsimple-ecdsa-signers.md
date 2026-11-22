---
id: bitgo-walletsimple-ecdsa-signers
title: "BitGo WalletSimple multisigs (23 wallets, $713M): a quantum attacker who recovers two of a wallet's three ECDSA signer keys can move everything; signers cannot be changed, so funds must move to a new wallet"
project: bitgo
status: confirmed
severity: HIGH
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x326d9f47ba49bbaac279172634827483af70a601"
  implementation: null
  name: WalletSimple (standalone, constructor signers)
  upgradeable: "no"
  admin: "none: signers fixed at creation, 2-of-3, all 3 EOAs (most active: 0xe8412e6f428f4142b78858db78e9eccce95d58e9, nonce 36094); signers.json"
  value_usd: 29260221
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 55
- address: "0x2e6b9ede9421bd2b2647d3da76e4671ba10bbd67"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x3a1ec84c16a1ff604f0d97e1004068e3814b1586, nonce 165380); signers.json"
  value_usd: 28069690
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 15
- address: "0x308672703961164e64332ba1ce19b85827502b4d"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xe8412e6f428f4142b78858db78e9eccce95d58e9, nonce 36094); signers.json"
  value_usd: 20572985
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 10
- address: "0x81a3d17d143731a26b262f6739376d3f122bccea"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xe8412e6f428f4142b78858db78e9eccce95d58e9, nonce 36094); signers.json"
  value_usd: 18478533
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-10
  txs_30d: 0
- address: "0x367c42a6f261ec54ffbecf5f41c226be12a3dca0"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xc08fb884576cc89957e9058ef11587c468c2952f, nonce 226669); signers.json"
  value_usd: 26490481
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1218
- address: "0x0f33afb00334ea05f6f0e64fc919920ecd4bd16c"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x833b62b180a2e74c325d5fc02ef917ddc807d67b, nonce 1050); signers.json"
  value_usd: 19
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-28
  txs_30d: 0
- address: "0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x3a1ec84c16a1ff604f0d97e1004068e3814b1586, nonce 165380); signers.json"
  value_usd: 29863393
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 36
- address: "0x0ac9fce7636af8fa933068a3a5ecb71f8177c4f3"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xc08fb884576cc89957e9058ef11587c468c2952f, nonce 226669); signers.json"
  value_usd: 22441339
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-30
  txs_30d: 3
- address: "0xb66410ae75317faf13dba869b6df7b30892d1e46"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xc5c817fb84f629810cd324bc91c204ef0cfb8aa3, nonce 99); signers.json"
  value_usd: 24433333
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-06
  txs_30d: 6
- address: "0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb"
  implementation: null
  name: WalletSimple (standalone, constructor signers)
  upgradeable: "no"
  admin: "none: signers fixed at creation, 2-of-3, all 3 EOAs (most active: 0x4bc6186ac7c0e1029a9e5aeb3ab10d03e11b7f4a, nonce 128459); signers.json"
  value_usd: 101949
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 2042
- address: "0x004c26816da9219cf3408e84edd9716df4b5739a"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x9f47624c77a332279c97b4e1fe169293cfc1c85e, nonce 1315); signers.json"
  value_usd: 24544130
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 149
- address: "0xa3f74537f048b893d726c173cb322fd21a28b18a"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x4bd64da54b76073ff796de6ac4d60c08c10ee8da, nonce 74); signers.json"
  value_usd: 21632944
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-23
  txs_30d: 4
- address: "0x1522900b6dafac587d499a862861c0869be6e428"
  implementation: "0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691"
  name: WalletSimple (delegatecall forwarder proxy to 0x5b9e8728…)
  upgradeable: "no"
  admin: "none: signers fixed at creation, 2-of-3, all 3 EOAs (most active: 0x00bdb5699745f5b860228c8f939abf1b9ae374ed, nonce 2190710); signers.json"
  value_usd: 319852
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 3964
- address: "0x273a4db9f7cb388ec216df8c347f0529b22f4bd8"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x3a1ec84c16a1ff604f0d97e1004068e3814b1586, nonce 165380); signers.json"
  value_usd: 43179293
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 28
- address: "0xa07b07e4542bea95f38c54f39ec25750ffc3dfcd"
  implementation: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clone of 0xe8e847cf…, FlattenedWalletSimple)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xc5c817fb84f629810cd324bc91c204ef0cfb8aa3, nonce 99); signers.json"
  value_usd: 20023836
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-10
  txs_30d: 0
- address: "0xb3d891c05febd428b782c242bf94dc73613549c9"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0xd32a4eeac73c2ae72a02cdd1ed16ec387b14773f, nonce 25889); signers.json"
  value_usd: 41712
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 6
- address: "0x187c0e0aa33282096b39a33457939f1dc3ea8e0f"
  implementation: null
  name: WalletSimple (standalone, constructor signers)
  upgradeable: "no"
  admin: "none: signers fixed at creation, 2-of-3, all 3 EOAs (most active: 0xd2c82f2e5fa236e114a81173e375a73664610998, nonce 2805998); signers.json"
  value_usd: 19964000
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-11
  txs_30d: 2
- address: "0x2edc7235fbebc560f59d55f206e340102f11aca5"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x66d358554df807d6aadd6e369772a7c8aa4fb017, nonce 2266); signers.json"
  value_usd: 19435743
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-03
  txs_30d: 0
- address: "0xbafbf3f8f244828caf4e93295c9174fa8b63e032"
  implementation: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clone of 0xe5dcdc13…)
  upgradeable: "no"
  admin: "none: signers fixed at init, 2-of-3, all 3 EOAs (most active: 0x376df20bfdc23ea8b2cc54cdc7277b9dada984b0, nonce 14); signers.json"
  value_usd: 27304737
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-10
  txs_30d: 0
families:
- code: "0xe5dcdc13b628c2df813db1080367e929c1507ca0"
  name: WalletSimple (EIP-1167 clones of 0xe5dcdc13…)
  instances: 1868
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0xe8e847cf573fc8ed75621660a36affd18c543d7e"
  name: WalletSimple (EIP-1167 clones of 0xe8e847cf…, FlattenedWalletSimple)
  instances: 7005
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: "each wallet's signers (two of three co-sign moving the funds) to a post-quantum-capable wallet; BitGo (wallet software; factories 0xa7198f48c58e91f01317e70cd24c5cce475c1555 and 0x9a0d63911620f7fc15c3c020edbe4d7267ea3e4d) has to provide one"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers/signers.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (source read, one real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, replays of 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

These 23 BitGo WalletSimple multisigs hold $712.8M (ETH and tokens, 2026-11-17). Each is 2-of-3: the transaction
sender must be a signer and the second signer is checked with `ecrecover` (PQ-12). All 69 signer slots are EOAs (60
distinct keys). A quantum attacker who recovers the keys of the active sender and of the co-signer (both public once
they have signed on chain) can send everything to itself. The signer set is fixed at creation and the code cannot
change, so the only fix is the owners moving the funds to a post-quantum-capable wallet. Rated HIGH (step 4): funds
must move, and that depends on 23 independent owner groups (and BitGo for a wallet to move to).

## Mechanism

- `sendMultiSig`, `sendMultiSigToken`, `sendMultiSigBatch` are `onlySigner` (msg.sender must be a signer) and call
  `verifyMultiSig`, which takes `otherSigner = recoverAddressFromSignature(operationHash, signature)` (`ecrecover`),
  requires `isSigner(otherSigner)` and `otherSigner != msg.sender`, then executes the call or transfer. There is no
  ERC-1271 path, so the second signer must be an ECDSA key.
- Signers: clones of `0xe5dcdc13…` (`contracts/WalletSimple.sol`) and `0xe8e847cf…` (`FlattenedWalletSimple.sol`)
  store `mapping(address => bool) signers`, set once by `init(address[] allowedSigners)` (exactly 3,
  `onlyUninitialized`); the comment reads "Signers CANNOT be changed once they are set". The standalone wallets and
  the forwarder proxy to `0x5b9e8728…` set `address[] signers` in the constructor. No function changes signers, and
  none of the contracts is upgradeable.
- `activateSafeMode` (any signer) only restricts sends to signer addresses; an attacker holding a signer key is such
  an address, so it does not protect the funds.
- Pattern PQ-12. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): `WalletSimple.sol` of `0xe5dcdc13…` (`init`, `sendMultiSig`,
  `verifyMultiSig`), `FlattenedWalletSimple.sol` of `0xe8e847cf…` (same logic), `WalletSimple.sol` of `0x5b9e8728…`
  (constructor signers, `recoverAddressFromSignature` → `ecrecover`).
- CHECKED (on-chain read, blocks 26,431,535 and 26,431,538): signers of all 23 wallets
  ([`signers.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers/signers.json)). Standalone wallets and the proxy:
  `signers(i)`; clones: candidates from the creation transaction (`createWallet` on BitGo `WalletFactory`
  `0xa7198f48…` or `0x9a0d6391…`), confirmed with `isSigner()`. Every wallet has exactly 3 signers; all 60 distinct
  signer addresses have no code (EOAs).
- CHECKED: `0x1522900b…` is a 51-byte forwarder that delegatecalls the hard-coded `0x5b9e8728…` (bytecode read).
- CHECKED (on-chain read, block 26,431,214): holdings, no EIP-1967 proxies
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers/onchain.json)).
- CHECKED (Xatu, any function): activity 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitgo-walletsimple-ecdsa-signers/activity.json)).
- INFERRED: the co-signer's public key is recoverable from any `sendMultiSig` signature in calldata, and the sender's
  from its transactions, so for every wallet that has transacted both keys of a working pair are exposed; the
  never-used third (backup) key may still be unexposed.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): transaction
  `0x23999f0ebb376034c26688ca5cd9f30fd481dc7996c804e2dcfed4485e70898b` (block 26,438,982, position 58:
  `sendMultiSig` on the clone `0x50532e8cbcd69092cb6d06d6f851b39f6fb45bcd`, co-signer `0x8111fe67…`) replayed on the
  reference implementation of the fork, from the parent block's state, with only the `ecrecover` precompile changed.
  Today's rules: success, 82,526 gas, equal to the real receipt. EIP-8151: success, 85,626 gas (3,100 more: the
  co-signer's address is cold). EIP-8151 with ordinary code at the co-signer's address: **revert**. EIP-8151 with an
  EIP-7702 delegation at the co-signer's address: success, 85,626 gas.

## Impact and exposure

Signer structure: each wallet has one sending key with transactions (`n` = nonce) and two keys that have never sent a
transaction (co-signer and backup). Some sending keys and one co-signer are shared across wallets in this finding
(`×n`): `0xe8412e6f…` (4 wallets), `0x3a1ec84c…` and `0xc08fb884…` (3 each), `0xc5c817fb…` and `0x0e4d24af…` (2
each). Recovering one shared sending key therefore gives half of the pair for several wallets.

| Wallet | Code | Signers (EOAs; nonce; wallets sharing) | Held now | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0xbd02c511…` | standalone | `0x9c58bcb0…` n=144547; `0xc6fc89ab…` n=0; `0xe764f73b…` n=0 | $221.0M | 2026-11-16 | 4,541 |
| `0x3a5cc868…` | standalone | `0xb02c6c40…` n=555828; `0xd9d77776…` n=0; `0x3290e22e…` n=0 | $51.5M | 2026-11-16 | 19,489 |
| `0x100ae042…` | clone 0xe8e847cf | `0xc08fb884…` n=226669 (×3); `0x0e4d24af…` n=0 (×2); `0x7f3296fe…` n=0 | $45.0M | 2026-11-16 | 1,949 |
| `0x273a4db9…` | clone 0xe5dcdc13 | `0x3a1ec84c…` n=165380 (×3); `0xa4f3f34c…` n=0; `0xecfe7d40…` n=0 | $43.2M | 2026-11-13 | 28 |
| `0x4a2d57d6…` | clone 0xe5dcdc13 | `0x3a1ec84c…` n=165380 (×3); `0x7dcde223…` n=0; `0xfdaf5437…` n=0 | $29.9M | 2026-11-10 | 36 |
| `0x326d9f47…` | standalone | `0xe8412e6f…` n=36094 (×4); `0xf04286ba…` n=0; `0x4cfb9040…` n=0 | $29.3M | 2026-11-15 | 55 |
| `0x2e6b9ede…` | clone 0xe5dcdc13 | `0x3a1ec84c…` n=165380 (×3); `0x01938dbc…` n=0; `0xd2364a2e…` n=0 | $28.1M | 2026-11-13 | 15 |
| `0xbafbf3f8…` | clone 0xe5dcdc13 | `0x376df20b…` n=14; `0x54a36fdb…` n=0; `0x6a75b346…` n=0 | $27.3M | 2026-05-10 | 0 |
| `0x367c42a6…` | clone 0xe8e847cf | `0xc08fb884…` n=226669 (×3); `0x0e4d24af…` n=0 (×2); `0x9d9d15cc…` n=0 | $26.5M | 2026-11-16 | 1,218 |
| `0x004c2681…` | clone 0xe8e847cf | `0x9f47624c…` n=1315; `0x1f745e2b…` n=0; `0xce05ee0b…` n=0 | $24.5M | 2026-11-15 | 149 |
| `0xb66410ae…` | clone 0xe8e847cf | `0xc5c817fb…` n=99 (×2); `0x7c21e036…` n=0; `0xccc07d25…` n=0 | $24.4M | 2026-11-06 | 6 |
| `0x0ac9fce7…` | clone 0xe5dcdc13 | `0xc08fb884…` n=226669 (×3); `0x04a0142f…` n=0; `0x76c08a87…` n=0 | $22.4M | 2026-10-30 | 3 |
| `0xa3f74537…` | clone 0xe5dcdc13 | `0x4bd64da5…` n=74; `0x068aeebc…` n=0; `0xa7d0e47f…` n=0 | $21.6M | 2026-10-23 | 4 |
| `0x30867270…` | clone 0xe8e847cf | `0xe8412e6f…` n=36094 (×4); `0x04b00fa2…` n=0; `0x28149575…` n=0 | $20.6M | 2026-11-15 | 10 |
| `0xa07b07e4…` | clone 0xe8e847cf | `0xc5c817fb…` n=99 (×2); `0x3d8d7702…` n=0; `0x83added1…` n=0 | $20.0M | 2026-05-10 | 0 |
| `0x187c0e0a…` | standalone | `0xd2c82f2e…` n=2805998; `0xe5c425d4…` n=0; `0xb8b86e0c…` n=0 | $20.0M | 2026-11-11 | 2 |
| `0x2edc7235…` | clone 0xe5dcdc13 | `0x66d35855…` n=2266; `0x58f4db8f…` n=0; `0x5e9963df…` n=0 | $19.4M | 2026-06-03 | 0 |
| `0xd07c7fd3…` | clone 0xe5dcdc13 | `0xe8412e6f…` n=36094 (×4); `0x2c97ccca…` n=0; `0x7de549d0…` n=0 | $19.2M | 2026-11-13 | 9 |
| `0x81a3d17d…` | clone 0xe8e847cf | `0xe8412e6f…` n=36094 (×4); `0xbf8ece0d…` n=0; `0xfcca59ec…` n=0 | $18.5M | 2026-05-10 | 0 |
| `0x1522900b…` | proxy 0x5b9e8728 | `0x00bdb569…` n=2190710; `0x3e071255…` n=0; `0x17a44288…` n=0 | $320k | 2026-11-16 | 3,964 |
| `0x3a61da6d…` | standalone | `0x4bc6186a…` n=128459; `0x9b5236e1…` n=2; `0xe531ecc8…` n=0 | $102k | 2026-11-15 | 2,042 |
| `0xb3d891c0…` | clone 0xe5dcdc13 | `0xd32a4eea…` n=25889; `0x8fa6b281…` n=0; `0x97fc86c6…` n=0 | $42k | 2026-11-10 | 6 |
| `0x0f33afb0…` | clone 0xe5dcdc13 | `0x833b62b1…` n=1050; `0xb7ef75ec…` n=0; `0xd8fab08c…` n=0 | $19 | 2026-09-28 | 0 |

Total held: $712.8M (`value_basis: held`, 2026-11-17), dominated by `0xbd02c511…` ($221.0M). Four wallets
(`0xbafbf3f8…`, `0xa07b07e4…`, `0x81a3d17d…`, `0x2edc7235…`, $85.2M together) had no transactions in the 30-day window
but were active within the year. The same code runs in 1,868 clones of `0xe5dcdc13…` and 7,005 clones of
`0xe8e847cf…` (families, not measured).

## Remediation

- Owners of each wallet co-sign (two of three) a transfer of all assets to a wallet whose signers can be
  post-quantum: for example a Safe with ERC-1271 post-quantum owner contracts, or a future BitGo wallet version that
  verifies the co-signer through ERC-1271 / ERC-7913. WalletSimple cannot rotate signers or be upgraded, so moving the
  funds is the only fix; deposit forwarders pointing at old wallets must be replaced too.
- BitGo must provide the post-quantum wallet version and drive migration for its customers; the WalletFactory
  contracts `0xa7198f48…` and `0x9a0d6391…` deploy only ECDSA-only WalletSimple clones.
- Protocol change: not needed for the fix. EIP-8151 would not help: making `ecrecover` fail for migrated signer
  addresses would lock the wallet instead (the co-signer check has no other path).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review23): HIGH kept, step 4: signer sets are fixed and the code is immutable, so only moving $712.8M out protects it, across 23 independent owner groups. Read all 69 signer slots (60 EOAs, none contracts) into `signers.json`; `0x1522900b…` given its delegatecall target as implementation.
- 2026-11-19 (study `eip-8151-impact`): `WalletSimple.sol` of `0xe5dcdc13…` read again line by line: `signers` is
  written only in `init` (line 82), every outflow goes through `verifyMultiSig` (lines 431 to 454), and there is no
  contract-signature path. What EIP-8151, as written, does here: a signer whose address has real code can no longer
  be the recovered co-signer, and can still be the sender. A wallet keeps working while one signer without code (or
  with a 7702 delegation) signs and a different signer sends. When all three have real code nothing can leave, and
  the signers cannot be changed. So the EIP stops the old key of a migrated signer from co-signing, and it locks a
  wallet whose three signers migrate. One real transaction was replayed four ways (Evidence). On activation day
  alone nothing breaks: the recovery gets all gas and each send costs 3,100 more. The study's inventory at block
  26,438,999 counts 4,107 clones of `0xe5dcdc13…`, holding 524,769 ETH together.
