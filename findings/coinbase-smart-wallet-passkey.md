---
id: coinbase-smart-wallet-passkey
title: "Coinbase Smart Wallet: any single P-256 passkey owner (or ECDSA address owner) can be forged by a quantum attacker to drain or take over the wallet, across about 107,000 mainnet wallets, until each owner adds a post-quantum signer and removes the old ones"
project: coinbase
status: confirmed
severity: MEDIUM
patterns: [PQ-9, PQ-12]
primitives: [p256, sw_p256, ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x1631adb3e1fdb65e7936272c89861cb2aac2906a"
  implementation: "0x00000110dcdedc9581cb5ecb8467282f2926534d"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS _authorizeUpgrade onlyOwner): passkey + EOA 0x6d0738b778dd5fff419da8ed5d6e6add3b6c12e2, read at block 26431561"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 0
- address: "0xef765c7e05fdb747c9d6a6f4d48e5214d52d4fbb"
  implementation: "0x000100abaad02f1cfc8bbe32bd5a564817339e72"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS onlyOwner): one passkey, read at block 26431561"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 0
- address: "0x0b7920a49953cba15f9188f6bd4c0be66421bfc0"
  implementation: "0x00000110dcdedc9581cb5ecb8467282f2926534d"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS onlyOwner): passkey + EOA 0xff814427528f33a2165305f6d8db30dd1bd8ba4e, read at block 26431561"
  value_usd: 7
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 0
- address: "0x3aa9add3f321db2a99bf394f75b6def1cd47fc80"
  implementation: "0x00000110dcdedc9581cb5ecb8467282f2926534d"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS onlyOwner): passkey + EOA 0x21df70d85ef9af19c3ee797500b3d1423f634036, read at block 26431561"
  value_usd: 13
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 0
- address: "0x2ea269e0102e70817be5929662e47ee7a0980b95"
  implementation: "0x00000110dcdedc9581cb5ecb8467282f2926534d"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS onlyOwner): passkey + EOAs 0x221a9de3d666bdac71d0e6fa4c5ff6587136606a, 0x4de99b804bda114135e4dba5780f86a08e87dbc1, read at block 26431561"
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 0
- address: "0xea03aa1a0e629c171c9681deba61aae72aa1ed1a"
  implementation: "0x000100abaad02f1cfc8bbe32bd5a564817339e72"
  name: ERC-1967 proxy → CoinbaseSmartWallet (sample wallet)
  upgradeable: "yes"
  admin: "any single wallet owner (UUPS onlyOwner): passkey + contract 0xf85210b21cc50302f477ba56686d2019dc9b67ad, read at block 26431561"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 2
families:
- code: "0x00000110dcdedc9581cb5ecb8467282f2926534d"
  name: CoinbaseSmartWallet proxies (implementation 0x00000110…)
  instances: 73153
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0x000100abaad02f1cfc8bbe32bd5a564817339e72"
  name: CoinbaseSmartWallet proxies (implementation 0x000100ab…)
  instances: 33847
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: "Each wallet's owners (any single owner can addOwnerAddress/addOwnerPublicKey/removeOwnerAtIndex or upgradeToAndCall); Coinbase (Base) to ship a post-quantum owner type or implementation and wallet support"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-smart-wallet-passkey
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0x000100ab, cast owner reads at block 26431561
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

Coinbase Smart Wallet accounts are controlled by a list of owners; each owner is a P-256 passkey (WebAuthn, PQ-9) or an
address checked with `ecrecover` first (PQ-12), and any single owner can move funds, add or remove owners and upgrade
the wallet. A quantum attacker who recovers one passkey private key from its public key (stored on-chain) or one owner
EOA's key controls the wallet. All six sample wallets have a passkey owner, five also have an EOA owner; about 107,000
mainnet wallets run the two implementations, and their total balance was not measured (the samples hold $26). Rated
MEDIUM, step 4: each owner can fix it by adding a post-quantum signer and removing the old owners (or upgrading).

## Mechanism

- `validateUserOp` and ERC-1271 `isValidSignature` both call `CoinbaseSmartWallet._isValidSignature` (implementation
  `0x000100ab…` lines 297–325; `0x00000110…` lines 318–346): the signature names an `ownerIndex`; a 64-byte owner is a
  P-256 key checked with `WebAuthn.verify` (precompile `0x100`, FreshCryptoLib software fallback); a 32-byte owner is an
  address checked with solady `SignatureCheckerLib.isValidSignatureNow`, which tries `ecrecover` for 64/65-byte
  signatures before falling back to ERC-1271 with the full signature.
- `MultiOwnable.onlyOwner` accepts any single owner (or the wallet itself); `_authorizeUpgrade` is `onlyOwner` (line
  331). Owner changes and `upgradeToAndCall` may be signed once and replayed on every chain
  (`canSkipChainIdValidation`), so one forged owner signature takes over the wallet on all chains where it exists.
- The scheme is chosen per owner, not by the wallet: an owner of another type stays valid until it is removed.

## Evidence

- CHECKED (Sourcify full source of implementation `0x000100abaad02f1cfc8bbe32bd5a564817339e72`; excerpt of
  `0x00000110…`): the paths above ([`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-smart-wallet-passkey/source-excerpts.md)).
- CHECKED (cast at block 26,431,561): implementation slots and owners of the six sample wallets: each has a passkey at
  index 0; five have an EOA owner, one a contract owner ([`owners.md`](#owner-reads-review12-2026-11-17)).
- CHECKED (on-chain read at block 26,431,214): holdings $0–13 per sample wallet
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-smart-wallet-passkey/onchain.json)).
- CHECKED (precompile trace, year to March 2026): P-256 verifications per sample wallet (`curated_contracts.csv`
  `cats`: 0x1631adb3 p256 585 / sw_p256 312; 0xef765c7e 146 / 1,433; 0x0b7920a4 68 / 492; 0x3aa9add3 648 / 673;
  0x2ea269e0 512 / 38; 0xea03aa1a 6 / 538).
- CHECKED (census, families table): 73,153 proxies use implementation `0x00000110…` and 33,847 use `0x000100ab…`.
- INFERRED: most wallets in the families have a passkey owner (Coinbase's smart-wallet onboarding creates one); not
  read per wallet.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x02f5dd83cc5ee015ca4c50ebc0171a7f8ac4cf37c06e0cb9da4eb9dab607723c` (block 26,435,141, position 1), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (280,688 gas); under EIP-8151 it also succeeds (293,088 gas). With one byte of code at the recovered signer
  `0x185e8266a14a8f66429be36df6fedd67debf010b`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `7cb392d9` (CoinbaseSmartWallet).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1631adb3…` CoinbaseSmartWallet | yes (owners) | $1 | 2026-11-16 | 0 |
| `0xef765c7e…` CoinbaseSmartWallet | yes (owners) | $1 | 2026-11-16 | 0 |
| `0x0b7920a4…` CoinbaseSmartWallet | yes (owners) | $7 | 2026-11-16 | 0 |
| `0x3aa9add3…` CoinbaseSmartWallet | yes (owners) | $13 | 2026-11-16 | 0 |
| `0x2ea269e0…` CoinbaseSmartWallet | yes (owners) | $4 | 2026-11-16 | 0 |
| `0xea03aa1a…` CoinbaseSmartWallet | yes (owners) | $0 | 2026-11-16 | 2 |

- Families: 73,153 + 33,847 wallets; their combined balance was not measured, so the value step lowers nothing.
- Each wallet's funds are its owners' own; nothing is pooled across wallets.

## Remediation

- Post-quantum replacement: each owner adds a post-quantum signer, either as an address owner that is a contract
  verifying a post-quantum signature through ERC-1271 (the solady path passes the full signature) or through a new
  owner type in an upgraded implementation (e.g. an ERC-7913 verifier), then removes every passkey and EOA owner.
- Who acts: each wallet's owners (any single owner can make these changes); Coinbase/Base to provide the post-quantum
  signer, implementation and wallet UI. No contract-wide admin exists.
- Protocol change: helps for the EOA owners: with EIP-8151, an owner address that has moved to post-quantum account code
  could no longer pass the `ecrecover` branch. It does not help passkeys; a P-256 owner must be removed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review12): MEDIUM -> MEDIUM, step 4: owners migrating their accounts (add post-quantum signer, remove passkey/EOA owners). Added PQ-12 and `ecrecover` (sample wallets have EOA owners, checked ecrecover-first); fix.layer contract-upgrade -> account-migration; owners read at block 26,431,561.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Owner reads (Review12, 2026-11-17)

`cast` against https://eth.drpc.org at block 26,431,561: EIP-1967 implementation slot, `nextOwnerIndex()`,
`ownerCount()`, `ownerAtIndex(i)` (64 bytes = P-256 public key (x, y); 32 bytes = address owner), and `eth_getCode` of
address owners (latest block).

| Wallet | Implementation | Owners |
|---|---|---|
| 0x1631adb3e1fdb65e7936272c89861cb2aac2906a | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x6d0738b778dd5fff419da8ed5d6e6add3b6c12e2 (EOA) |
| 0xef765c7e05fdb747c9d6a6f4d48e5214d52d4fbb | 0x000100abaad02f1cfc8bbe32bd5a564817339e72 | [0] passkey |
| 0x0b7920a49953cba15f9188f6bd4c0be66421bfc0 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0xff814427528f33a2165305f6d8db30dd1bd8ba4e (EOA) |
| 0x3aa9add3f321db2a99bf394f75b6def1cd47fc80 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x21df70d85ef9af19c3ee797500b3d1423f634036 (EOA) |
| 0x2ea269e0102e70817be5929662e47ee7a0980b95 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x221a9de3d666bdac71d0e6fa4c5ff6587136606a (EOA); [2] 0x4de99b804bda114135e4dba5780f86a08e87dbc1 (EOA) |
| 0xea03aa1a0e629c171c9681deba61aae72aa1ed1a | 0x000100abaad02f1cfc8bbe32bd5a564817339e72 | [0] passkey; [1] 0xf85210b21cc50302f477ba56686d2019dc9b67ad (contract) |

Source (Sourcify, implementation 0x000100ab…; the 0x00000110… excerpt has the same `_isValidSignature`):
- `CoinbaseSmartWallet._isValidSignature` (lines 297–325): 32-byte owner → solady
  `SignatureCheckerLib.isValidSignatureNow` (ecrecover first for 64/65-byte signatures, then ERC-1271 with the full
  signature); 64-byte owner → `WebAuthn.verify` (P-256 via precompile 0x100, FreshCryptoLib fallback).
- `_authorizeUpgrade` is `onlyOwner` (line 331); `MultiOwnable.onlyOwner` (line 93) accepts any single owner or the
  wallet itself; `addOwnerAddress`, `addOwnerPublicKey`, `removeOwnerAtIndex`, `removeLastOwner`, `upgradeToAndCall`
  may be replayed across chains (`canSkipChainIdValidation`, lines 260–271).
