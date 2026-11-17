---
id: "0x-v4-order-sig-ecdsa-only"
title: "0x v4 Exchange Proxy: a forged ECDSA signature fills limit, RFQ and OTC orders or meta-transactions against a maker's or taker's approvals to 0xdef1c0de; post-quantum makers cannot sign"
project: "0x"
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xdef1c0ded9bec7f1a1670819833240f027b25eff"
  implementation: null
  name: ZeroEx (feature router; signature checks in NativeOrdersFeature 0x1fcc3e6f…, OtcOrdersFeature 0x5ebac8db…, MetaTransactionsFeature 0xf2a9f3a2…)
  upgradeable: "yes"
  admin: "owner ZeroExGovernor 0x618f9c67ce7bf1a50afa1e7e0238422601b0ff6e (2 of 4 multisig, 2-day time lock) via migrate/extend/rollback; read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: 13
families: []
fix:
  layer: contract-upgrade
  who_acts: "ZeroExGovernor 0x618f9c67ce7bf1a50afa1e7e0238422601b0ff6e (2 of 4): replace or roll back the order and meta-transaction features"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v4-order-sig-ecdsa-only
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
  who: Review08 (verified feature sources and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v4-order-sig-ecdsa-only/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: ["0x-v2-order-sig-scheme-select"]
---

## Summary

Every signed path of the 0x v4 Exchange Proxy (limit, RFQ and OTC orders, taker-signed OTC orders, meta-transactions)
takes a fixed `(type, v, r, s)` signature and accepts it only through `ecrecover` (PQ-1). A quantum attacker who
recovers a maker's or taker's key can sign orders or meta-transactions that spend that address's approvals to
`0xdef1c0de…`, also after the address moves to post-quantum authorisation. Post-quantum makers cannot sign at all.
The exposure is those approvals, which are not measured; the proxy itself holds about USD 2. Rated MEDIUM (step 4):
the 2-of-4 ZeroExGovernor can replace the features.

## Mechanism

- `LibSignature.getSignerOfHash` (in each feature) supports only `EIP712` and `ETHSIGN`, both `ecrecover`. The
  `Signature` struct is fixed at four words, so no longer signature and no ERC-1271 call fits.
- `NativeOrdersSettlement._fillLimitOrderPrivate` / `_fillRfqOrderPrivate`: the order is valid if the recovered signer
  is `order.maker` or a signer registered with `registerAllowedOrderSigner`. A contract maker, including a post-quantum
  account, can trade only by delegating to another ECDSA key.
- `OtcOrdersFeature.fillTakerSignedOtcOrder*` recovers the taker from a signature. `MetaTransactionsFeature` recovers
  `mtx.signer` and fills or runs `transformERC20` with that address as taker.
- Takers that call `fillLimitOrder` / `fillRfqOrder` directly are authorised by `msg.sender`, so a post-quantum
  account can take orders but not make them.

Pattern PQ-1. The proxy's own source has no signature code, so the excerpt file is empty; the feature sources are
summarised in [`notes.md`](#review-notes-review08-2026-11-17).

## Evidence

- CHECKED (`cast`, block 26,431,454): `getFunctionImplementation` maps the fill, OTC and meta-transaction selectors to
  NativeOrdersFeature `0x1fcc3e6f…`, OtcOrdersFeature `0x5ebac8db…` and MetaTransactionsFeature `0xf2a9f3a2…`.
- CHECKED (Sourcify exact matches of those three features): `LibSignature` and the call sites listed in `notes.md`.
- CHECKED (`cast`, block 26,431,454): `owner()` is ZeroExGovernor `0x618f9c67…`, a 2-of-4 multisig with a 172,800 s
  default time lock.
- CHECKED (on-chain read, block 26,431,214): the proxy holds 0.00006 ETH and about USD 2 of tokens
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v4-order-sig-ecdsa-only/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 13 transactions (7 direct), last on 2026-11-13
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v4-order-sig-ecdsa-only/activity.json)).
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 215,595 transactions with an `ecrecover`
  here; their transfers total USD 5.85B (`usd_tx_y1`, a flow).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xdef1c0de…` ZeroEx | yes | ~$2 (dust, not the exposure) | 2026-11-13 | 13 |

The exposure is every token allowance users have granted to `0xdef1c0de…`, capped by their balances. It is not
measured. The `held` value was removed because the proxy's dust is not what a forged signature releases. Use has
dropped sharply: 13 transactions in the 30-day window, against 215,595 signature-checked transactions in the year to
March 2026.

## Remediation

- 0x: ZeroExGovernor `0x618f9c67…` (2 of 4) migrates new NativeOrders, OtcOrders and MetaTransactions features that
  verify through ERC-1271 with the full signature (or ERC-7913), or rolls these selectors back to disable them.
  Registered order signers must not fall back to ECDSA.
- Users: revoke approvals to `0xdef1c0de…`, which the current 0x API no longer needs.
- Protocol: EIP-8151 would help migrated addresses with real code. It does not let post-quantum makers sign.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review08): MEDIUM unchanged (step 4: feature upgrade by ZeroExGovernor 0x618f9c67…, 2 of 4). Mechanism re-read in the feature implementations (the proxy excerpt was empty); `held` value removed (proxy dust is not the exposure); title widened from "market-maker quotes" to all signed order and meta-transaction paths.

# Source excerpts: 0x-v4-order-sig-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xdef1c0ded9bec7f1a1670819833240f027b25eff` — ZeroEx (verified source via sourcify)

# Review notes (Review08, 2026-11-17)

`0xdef1c0de…` is the ZeroEx feature router; its own verified source (`ZeroEx.sol`) has no signature code, so the
excerpt file is empty. Features resolved with `getFunctionImplementation(bytes4)` at block 26,431,454:

| Selector | Function | Feature implementation (Sourcify exact match) |
|---|---|---|
| `0xf6274f66` | `fillLimitOrder` | `0x1fcc3e6f76f7a96cd2b9d09f1d3c041ca1403c57` NativeOrdersFeature |
| `0xaa77476c` | `fillRfqOrder` | `0x1fcc3e6f…` NativeOrdersFeature |
| `0xea7faa61` | `registerAllowedOrderSigner` | `0x1fcc3e6f…` NativeOrdersFeature |
| `0xdac748d4` | `fillOtcOrder` | `0x5ebac8dbfbba22168471b0f914131d1976536a25` OtcOrdersFeature |
| `0x4f948110` | `fillTakerSignedOtcOrder` | `0x5ebac8db…` OtcOrdersFeature |
| `0x3d61ed3e` | `executeMetaTransaction` | `0xf2a9f3a29fc4c70d4518f1a46227e9b0a630cae2` MetaTransactionsFeature |
| `0x415565b0` | `transformERC20` | `0x44a6999ec971cfca458aff25a808f272f6d492a2` |

Source read:
- `LibSignature.sol`: `SignatureType { ILLEGAL, INVALID, EIP712, ETHSIGN }`; `Signature { signatureType, v, r, s }`
  (fixed size); `getSignerOfHash` (lines 67-111) is `ecrecover` for EIP712 and ETHSIGN. No ERC-1271, no pre-sign.
- `NativeOrdersSettlement.sol`: `_fillLimitOrderPrivate` line 396-400 and `_fillRfqOrderPrivate` lines 503-509:
  `signer = getSignerOfHash(orderHash, signature)`; accepted if `signer == order.maker` or
  `isValidOrderSigner(order.maker, signer)`. `registerAllowedOrderSigner` (line 611) lets `msg.sender` (a maker
  contract) delegate to another address, which must itself produce an ECDSA signature.
- `OtcOrdersFeature.sol`: lines 251, 297 (`taker = getSignerOfHash(...)` for taker-signed OTC orders) and 467 (maker).
- `MetaTransactionsFeature.sol` line 340: `getSignerOfHash(state.hash, state.signature) != mtx.signer` reverts; the
  meta-transaction then fills or transforms with `mtx.signer` as taker (lines 426, 487, 516).

On-chain (block 26,431,454):

| Call | Result |
|---|---|
| ZeroEx `owner()` | `0x618f9c67ce7bf1a50afa1e7e0238422601b0ff6e` (Blockscout name `ZeroExGovernor`) |
| `0x618f9c67…` `getOwners()` | `0x5ee2a00f…`, `0x257619b7…`, `0x2b3c8b68…`, `0x269984c9…` |
| `required()` / `secondsTimeLocked()` | 2 / 172,800 s |
| ZeroEx holdings | ETH 0.00006 + about USD 2 of tokens (onchain.json, block 26,431,214): dust, not the exposure |
