---
id: trust-wallet-barz-passkey
title: "Trust Wallet Barz: a quantum attacker who recovers a wallet's P-256 passkey key can sign UserOperations and drain it, across about 30,000 passkey wallets, until Trust Wallet registers a post-quantum verification facet and each owner switches"
project: trust-wallet
status: confirmed
severity: MEDIUM
patterns: [PQ-9]
primitives: [sw_p256]
trigger: user-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x62b3aa5a0b99074b5d8a983c130845cef930057e"
  implementation: "0xee1af8e967ec04c84711842796a5e714d2fd33e6"
  name: Barz diamond (sample wallet) → Secp256r1VerificationFacet
  upgradeable: "yes"
  admin: the wallet's own passkey owner (diamondCut through a UserOperation, only to facets registered in FacetRegistry 0xafcb70e6e9514e2a15b23a01d2a9b9f7a34f2c33)
  value_usd: 152
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-20
  txs_30d: 1
- address: "0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225"
  implementation: "0xee1af8e967ec04c84711842796a5e714d2fd33e6"
  name: Barz diamond (sample wallet) → Secp256r1VerificationFacet
  upgradeable: "yes"
  admin: the wallet's own passkey owner (diamondCut through a UserOperation, only to registered facets)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-15
  txs_30d: 0
families:
- code: "0xee1af8e967ec04c84711842796a5e714d2fd33e6"
  name: Barz diamond accounts (573-byte proxy, code hash 0xe152e0d0…) that verified P-256 signatures in the trace; Secp256r1VerificationFacet in 68 of 70 sampled
  instances: 30049
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: 322247
  value_basis: held
  value_as_of: 2026-11-17
fix:
  layer: account-migration
  who_acts: "Trust Wallet: FacetRegistry 0xafcb70e6e9514e2a15b23a01d2a9b9f7a34f2c33 owner Safe 0x8c62a63c5cb598a092c838d6e2fbead978d05747 (3 of 8) registers a post-quantum verification facet and the wallet app supports it; then each wallet owner replaces Secp256r1VerificationFacet through diamondCut (or diamondCutWithGuardian)"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/trust-wallet-barz-passkey
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review14 (facet source, facet sample, family balances)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/trust-wallet-barz-passkey/accounts.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Trust Wallet's Barz smart accounts with passkey login verify every UserOperation and every ERC-1271 signature against
one P-256 public key, in software (`modexp`). A P-256 public key is stored in the account, so a quantum attacker can
recover the private key and spend or take over any such wallet. About 30,000 such wallets verified P-256 signatures in
the trace; they hold 177.9 ETH (USD 322k on 2026-11-17, tokens not measured). Each wallet can swap its verification
facet, but only to facets in Trust Wallet's FacetRegistry, and none is post-quantum: rated MEDIUM (step 4: a release
by Trust Wallet, then owners migrating).

## Mechanism

- Each Barz account is an EIP-2535 diamond. `validateUserOp` (AccountFacet `0xfde5…8332`) calls the verification
  facet's `validateOwnerSignature`; `isValidSignature` is routed to the verification facet directly.
- `Secp256r1VerificationFacet` (`0xee1a…33e6`) `_validateSignature` → `LibSecp256r1.Verify(q, rValue, sValue,
  uint256(sigHash))` (line 210) against the stored owner key; `LibSecp256r1` is a Solidity P-256 implementation
  "modified to use precompile 0x05 modexp" (`staticcall(14000, 0x5, …)`, line 366).
- `DiamondCutFacet.diamondCut` (`0x0b95…e1e0`) is `enforceIsSelf` (the account calling itself via a signed
  UserOperation) and `_checkFacetCutValidity` requires every added or replaced facet to be registered in
  `s.facetRegistry.areFacetFunctionSelectorsRegistered(...)`; with guardians the route is `diamondCutWithGuardian`.
- Pattern PQ-9 (P-256 passkeys). Changing the passkey only swaps one P-256 key for another.

## Evidence

- CHECKED (Blockscout verified source of Secp256r1VerificationFacet, DiamondCutFacet and Modifiers, read 2026-11-17):
  the functions above ([`accounts.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/trust-wallet-barz-passkey/accounts.json)).
- CHECKED (cast, 2026-11-17): `facetAddress(...)` and `facetAddresses()` of `0x62b3…057e`; `owner()` returns a P-256
  public key for both sample wallets; BarzFactory `0x729c…272a` `facetRegistry()` = `0xafcb…2c33`, whose `owner()` is
  Safe `0x8c62…5747` (threshold 3, 8 owners).
- CHECKED (precompile trace): 30,049 accounts with this proxy code called `modexp` with the P-256 field and group
  moduli (all time); 16,101 of them in 88,655 transactions in the trace year (`data/agg/modexp_moduli.parquet`,
  `y1_caller.parquet`).
- CHECKED (state probe at block 26,431,694): all 30,049 have code; 19,136 hold ETH, 177.88 ETH in total.
- CHECKED (`facetAddress(0x1626ba7e)` on 70 sampled accounts): 68 use `0xee1a…33e6`; 2 returned no facet.
- CHECKED (Xatu, any function): sample wallets' activity in the table
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/trust-wallet-barz-passkey/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x62b3aa5a…` Barz (sample) | yes (owner, registered facets only) | USD 152 | 2026-10-20 | 1 |
| `0xc5aea9e1…` Barz (sample) | yes (owner, registered facets only) | USD 0 | 2026-10-15 | 0 |
| family: 30,049 Barz passkey wallets | yes | USD 322k (ETH only) | — | — |

Each wallet's own balance is exposed to the recovery of its own passkey key; ERC-20 balances and approvals given by
these wallets were not measured. The largest ETH balances: `0xebbb…1093` 38.6 ETH, `0x8e75…b9c8` 11.1 ETH.

## Remediation

- Trust Wallet registers a post-quantum verification facet (ML-DSA, Falcon or hash-based signatures, or a WebAuthn
  ML-DSA passkey) in FacetRegistry `0xafcb…2c33` through Safe `0x8c62…5747`, and ships wallet support.
- Each owner then replaces `Secp256r1VerificationFacet` with it through `diamondCut` / `diamondCutWithGuardian`.
  Until then, owners can only move funds to another post-quantum account.
- A protocol change helps only indirectly: EIP-8141 frame transactions with post-quantum verification give a target
  to move to; nothing protects a wallet that keeps the P-256 facet.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (Trust Wallet registers a post-quantum facet, owners migrate). Added the family of 30,049 passkey wallets (177.9 ETH held); alternative set to configurable-verifier (facets are swappable, but only to registered ones).

# Source excerpts: trust-wallet-barz-passkey

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225`

No verified source on Sourcify or Blockscout.


## Contract `0x62b3aa5a0b99074b5d8a983c130845cef930057e`

No verified source on Sourcify or Blockscout.
