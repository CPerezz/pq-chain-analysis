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
  links:
  - evidence/0x-v4-order-sig-ecdsa-only/classification.jsonl
  - evidence/0x-v4-order-sig-ecdsa-only/onchain.json
  - evidence/0x-v4-order-sig-ecdsa-only/activity.json
  - evidence/0x-v4-order-sig-ecdsa-only/source-excerpts.md
  - evidence/0x-v4-order-sig-ecdsa-only/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (verified feature sources and on-chain reads)
  ref: evidence/0x-v4-order-sig-ecdsa-only/notes.md
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
summarised in [`notes.md`](../evidence/0x-v4-order-sig-ecdsa-only/notes.md).

## Evidence

- CHECKED (`cast`, block 26,431,454): `getFunctionImplementation` maps the fill, OTC and meta-transaction selectors to
  NativeOrdersFeature `0x1fcc3e6f…`, OtcOrdersFeature `0x5ebac8db…` and MetaTransactionsFeature `0xf2a9f3a2…`.
- CHECKED (Sourcify exact matches of those three features): `LibSignature` and the call sites listed in `notes.md`.
- CHECKED (`cast`, block 26,431,454): `owner()` is ZeroExGovernor `0x618f9c67…`, a 2-of-4 multisig with a 172,800 s
  default time lock.
- CHECKED (on-chain read, block 26,431,214): the proxy holds 0.00006 ETH and about USD 2 of tokens
  ([`onchain.json`](../evidence/0x-v4-order-sig-ecdsa-only/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 13 transactions (7 direct), last on 2026-11-13
  ([`activity.json`](../evidence/0x-v4-order-sig-ecdsa-only/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review08): MEDIUM unchanged (step 4: feature upgrade by ZeroExGovernor 0x618f9c67…, 2 of 4). Mechanism re-read in the feature implementations (the proxy excerpt was empty); `held` value removed (proxy dust is not the exposure); title widened from "market-maker quotes" to all signed order and meta-transaction paths.
