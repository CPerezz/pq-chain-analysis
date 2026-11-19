---
id: unidentified-b203e117-owner-keys
title: "MultiSigV1 wallet 0xb203e117 ($150.5M): a quantum attacker who recovers 3 of its 4 ECDSA owner keys can move the funds or upgrade the wallet through its proxy-admin multisig; owners can migrate in place"
project: unidentified-b203e117
status: confirmed
severity: MEDIUM
patterns: [PQ-12, PQ-17]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xb203e1170a30e68dc5b20aac08aa42619842c79e"
  implementation: "0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a"
  name: MultiSigV1 (TransparentUpgradeableProxy)
  upgradeable: "yes"
  admin: "proxy admin 0xca30217205742ecdc440b736aa65e0d28bd823c2 = MultiSigWalletWithPermit with the same 4 EOA owners, 3 of 4, owners immutable; read at block 26431695"
  value_usd: 150472395
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 15
families:
- code: "0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a"
  name: MultiSigV1 (TransparentUpgradeableProxy wallets on this implementation)
  instances: 2
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: "the wallet's owners (3 of 4 EOAs 0x44c341ad…, 0xedf1b98a…, 0x967a529b…, 0x739463da…): replaceOwner with post-quantum smart accounts on the wallet, and changeAdmin on the proxy (through admin 0xca30217205742ecdc440b736aa65e0d28bd823c2) to an admin with post-quantum owners"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-b203e117-owner-keys
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-b203e117-owner-keys/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 35075ad3"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

`0xb203e117…` is a 3-of-4 multisig (MultiSigV1, code by "pagefault") holding $150.5M (37,007 ETH and $83.4M USDT on
2026-11-17). All four owners are EOAs, and the wallet's day-to-day path, `executeTxWithPermits`, checks co-owners with
`ecrecover` (PQ-12). A quantum attacker who recovers three owner keys can send everything out, or upgrade the wallet
through its proxy admin, which is a second multisig with the same four keys and owners that cannot be changed. The
owners can fix it themselves: replace the wallet's owners with post-quantum accounts and move the proxy to a new admin.
Rated MEDIUM (step 4): owners migrating in place. The operator is not identified.

## Mechanism

- `executeTxWithPermits(destination, value, data, nonce, rs, ss, vs)`: the sender must be an owner, and each other
  confirmation is `ecrecover(digest, v, r, s)` over an EIP-712 digest that must be an owner (`MultiSigV1.sol` lines
  1359–1364); with `required - 1` valid signatures the call executes.
- The Gnosis `MultiSigWallet` base also has `submitTransaction` / `confirmTransaction` / `executeTransaction` by
  `msg.sender`, so owners that are contracts (post-quantum smart accounts) can operate the wallet.
- `addOwner`, `replaceOwner`, `removeOwner`, `changeRequirement` are `onlyWallet` and allowed only when owners are not
  immutable; on this wallet they are mutable (simulation), so the owners can swap themselves for post-quantum accounts.
- The proxy's admin `0xca302172…` is a `MultiSigWalletWithPermit` created by the factory with immutable owners (the
  same four EOAs, 3 of 4). Through it, three keys can `upgradeTo` any implementation. Its owners cannot be replaced,
  but it can call `changeAdmin` on the proxy to hand admin rights to a new, post-quantum-controlled admin.
- Pattern PQ-12. Excerpt: [`source-excerpts.md`](#source-excerpts-unidentified-b203e117-owner-keys).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x471756ad…`): `executeTxWithPermits`, owner management with
  `notImmutable`, the factory `create` that makes the admin with immutable owners
  ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (on-chain read, block 26,431,695): wallet and admin `getOwners()` (same four addresses), `required()` = 3 on
  both; all four owners have no code; EIP-1967 admin = `0xca302172…`; `addOwner` simulated from the wallet succeeds,
  from the admin reverts `MS01`.
- CHECKED (on-chain read, block 26,431,214): holdings 37,006.8 ETH + $83.4M USDT = $150.5M
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-b203e117-owner-keys/onchain.json)).
- CHECKED (Xatu, any function): 15 transactions 2026-10-16 to 2026-11-16, last 2026-11-13; Blockscout shows
  `executeTxWithPermits` calls on 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-b203e117-owner-keys/activity.json)).
- INFERRED: the three owners with nonce 0 have public keys exposed through their `(v, r, s)` confirmations in
  `executeTxWithPermits` calldata (150 wallet transactions), so all four keys are recoverable with a CRQC.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb203e117…` MultiSigV1 (TransparentUpgradeableProxy) | yes (admin multisig, same owners) | $150.5M | 2026-11-13 | 15 |

The wallet holds the funds itself (`value_basis: held`). The admin `0xca302172…` holds no funds but controls upgrades.
The implementation `0x471756ad…` backs 2 proxies (family entry); the other was not reviewed. Operator not identified
(creator is the public factory `0x63edeb9a…`; no explorer labels; inflows look like regular deposits from many
addresses).

## Remediation

- The owners (3 of 4) call `replaceOwner` on the wallet to install post-quantum smart accounts (which operate through
  `submitTransaction` / `confirmTransaction`), and use the admin multisig to `changeAdmin` the proxy to a new admin
  whose owners are post-quantum. Both steps need only the current owners; no new deployment or fund move is required.
  Alternatively they move the funds to a post-quantum wallet.
- A later implementation upgrade could verify co-owners through ERC-1271 / ERC-7913 in `executeTxWithPermits`.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: owners can move to post-quantum signers in place (contract owners, modules or upgrade)).
- 2026-11-17 review (Review23): MEDIUM kept, step 4: wallet owners are mutable and the immutable-owner proxy admin can hand over via `changeAdmin`, so the same 3-of-4 owners can migrate in place. Read owners (4 EOAs), threshold 3 and admin structure at block 26,431,695. Operator still unidentified.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: unidentified-b203e117-owner-keys

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb203e1170a30e68dc5b20aac08aa42619842c79e` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a` — MultiSigV1 (verified source via sourcify)

### `MultiSigV1.sol`

```solidity
 1356              )
 1357          );
 1358  
 1359          for (uint8 i = 0; i < rs.length; ++i) {
 1360              address owner = ecrecover(digest, vs[i], rs[i], ss[i]);
 1361              require(owner != address(0), "MS03");
 1362              require(isOwner[owner], "MS04");
 1363  
 1364              confirmations[newTransactionId][owner] = true;
  ...
```

# Review notes (Review23, 2026-11-17)

Reads at block 26,431,695 (https://ethereum-rpc.publicnode.com):

- Wallet proxy `0xb203e1170a30e68dc5b20aac08aa42619842c79e` (TransparentUpgradeableProxy): implementation
  `0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a` (MultiSigV1, verified), EIP-1967 admin
  `0xca30217205742ecdc440b736aa65e0d28bd823c2`.
- Wallet `getOwners()` = `0x44c341ad187d48eafb7df892f9d4411827bb9527`, `0xedf1b98a188b2d496797b14b6b28a0f3afe5bc10`,
  `0x967a529baa2dc7cec989a073ca9a81d8a80540ca`, `0x739463da605ae91de81d2fccd534623320166349`; `required()` = 3;
  `transactionCount()` = 150. All four owners have no code (EOAs); nonces 153, 0, 0, 0.
- Admin `0xca302172…` is a `MultiSigWalletWithPermit` created by the factory in the same transaction as the proxy
  (`UpgradeableMultiSignWalletFactory.create`, which passes `_immutable = true` for the admin): same four owners,
  `required()` = 3, `transactionCount()` = 0.
- Mutability (eth_call simulations): `addOwner(0x…dEaD)` from the wallet itself succeeds (owners mutable,
  `ownersImmutable = false`); the same call from the admin to itself reverts `MS01` (admin owners immutable).

Verified source (Sourcify, `MultiSigV1.sol`):

- `executeTxWithPermits(destination, value, data, nonce, rs, ss, vs)`: `msg.sender` must be an owner; each
  `(v, r, s)` is `ecrecover`ed over an EIP-712 digest and must be an owner (lines 1359–1364); needs
  `rs.length + 1 == required`.
- Gnosis `MultiSigWallet` base: `submitTransaction` / `confirmTransaction` / `executeTransaction` by `msg.sender`
  (owners may be contracts). `addOwner`, `removeOwner`, `replaceOwner`, `changeRequirement` are `onlyWallet` and
  `notImmutable`.
- Proxy admin powers (OpenZeppelin TransparentUpgradeableProxy): `upgradeTo`, `upgradeToAndCall`, `changeAdmin`.

Recent use: `executeTxWithPermits` by `0x44c341ad…` on 2026-11-16 (USDT transfers); daily inbound transfers from
many addresses. Operator not identified (creator is the factory `0x63edeb9a…`; no explorer tags).
