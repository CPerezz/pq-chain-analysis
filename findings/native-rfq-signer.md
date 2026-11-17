---
id: native-rfq-signer
title: "Native RFQ (CreditVault, routers, pools): a quantum attacker who recovers Native's ECDSA signer keys plus a market-maker or trader key can drain the $6.8M CreditVault"
project: native
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xe3d41d19564922c9952f692c5dd0563030f5f2ef"
  implementation: null
  name: CreditVault (treasury of the credit pools)
  upgradeable: config-only
  admin: "owner 0x9b9dc7c56e18cfda57d402ca7ded491b1544dc56 (unverified contract, block 26431766): setSigner, setCreditPool, setAllowance, setTrader, setLiquidator"
  value_usd: 6787698
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
- address: "0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00"
  implementation: null
  name: NativeRouter
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5): setSigner, setNativePool, pause"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 24381
- address: "0xc419e67388df0c0cfad15584fc5fc7e67a234c17"
  implementation: null
  name: NativeRFQPool
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5): setSigner (rfqSigners), setTreasury"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 24233
- address: "0xa540ec8c73322200d68e1b86c471a5c850854f22"
  implementation: null
  name: NativeRouter
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5): setSigner, setNativePool, pause"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 858
- address: "0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c"
  implementation: null
  name: NativeRFQPool
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5): setSigner (rfqSigners), setTreasury"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 857
- address: "0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf"
  implementation: null
  name: NativeRouter (paused)
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-08-11
  txs_30d: 0
- address: "0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c"
  implementation: null
  name: NativeRFQPool (no longer a vault credit pool)
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-10-26
  txs_30d: 0
- address: "0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa"
  implementation: null
  name: NativeRouter (paused)
  upgradeable: config-only
  admin: "owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-08-11
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "Native: owner Safe 0x83fc28e6962e41e38f7854308eff827e3f6b906b (3 of 5) deploys router and pools that verify post-quantum signatures and whitelists them; CreditVault owner 0x9b9dc7c56e18cfda57d402ca7ded491b1544dc56 deploys a vault whose settle/removeCollateral/liquidate checks are post-quantum and moves funds, creditPools and allowances to it"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/native-rfq-signer/classification.jsonl
  - evidence/native-rfq-signer/onchain.json
  - evidence/native-rfq-signer/activity.json
  - evidence/native-rfq-signer/source-excerpts.md
  - evidence/native-rfq-signer/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (Sourcify source, on-chain and Blockscout reads)
  ref: evidence/native-rfq-signer/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Native's RFQ system holds its liquidity in the CreditVault `0xe3d41d19…` ($6.79M). Three ECDSA signers guard it: a
trade needs Native's router signer (`widgetFeeSignature`) and a whitelisted market maker's quote signature, after
which the pool pays the taker from the vault; and the vault's own `signer` approves market makers' settlements,
collateral removals and liquidations, each paid out of the vault. A quantum attacker who recovers the router signer
and a market-maker key, or the vault signer and a whitelisted trader's key, can take vault funds. Nothing is a proxy,
so the fix is new vault, router and pool deployments; rated MEDIUM (step 4: new deployment).

## Mechanism

- `NativeRouter.tradeRFQT` requires `isNativePools[quote.pool]` and `_verifyRFQSignature`:
  `ECDSA.recover(digest, quote.widgetFeeSignature)` must be in `signers` (owner `setSigner`). `externalSwap` checks
  `params.signature` against the same set.
- `NativeRFQPool.tradeRFQT` (router only) calls `_verifyPMMSignature`: `rfqSigners[quote.signer]` and
  `quote.signer == ECDSA.recover(digest, quote.signature)`. It then calls `CreditVault.swapCallback` to book the trade
  to the signer's position and `safeTransferFrom(treasury, recipient, buyerTokenAmount)`.
- Both keys are single secp256k1 keys (PQ-4); the owner can rotate them but not change the scheme.
- `CreditVault.settle`, `removeCollateral` and `liquidate` (`src/CreditVault.sol` 171-290) require an
  `ECDSA.recover(digest, signature) == signer` approval (`_verifySettleSignature` 542, `_verifyRemoveCollateralSignature`
  566, `_verifyLiquidationSignature` 590) and then `safeTransfer` vault tokens to the trader's or liquidator's
  owner-set recipient. The caller must be a whitelisted trader (or its settler) or liquidator, so a forged vault
  signature also needs that party's key; per-trader daily rebalance caps, where set, limit each withdrawal.

## Evidence

- CHECKED (Sourcify source of router `0x8a2ddc04…` with bundled pool and vault, pool `0xc419e673…`, and CreditVault
  `0xe3d41d19…` itself, exact match): the checks and transfers above
  ([`review-notes.md`](../evidence/native-rfq-signer/review-notes.md),
  [`source-excerpts.md`](../evidence/native-rfq-signer/source-excerpts.md)).
- CHECKED (on-chain, latest blocks 26,431,551-26,431,705): no proxies; owner of all routers and pools = Safe
  `0x83fc28e6…` (3 of 5); pools' `treasury()` = CreditVault `0xe3d41d19…`; `creditPools` true for `0xc419e673…` and
  `0x5d1a3436…`, false for `0x9af2f3c0…`; vault USDC and WETH allowances to the two live pools are unlimited, to
  `0x9af2f3c0…` zero; routers `0x0f9f2366…` and `0xa42c9f74…` are paused.
- CHECKED (Blockscout token holdings, 2026-11-17): CreditVault holds $6.79M (WETH $2.16M, USDT $2.02M, USDC $1.74M,
  cbBTC $506k, WBTC $351k).
- CHECKED (block 26,431,214): routers and pools hold ~$0 ([`onchain.json`](../evidence/native-rfq-signer/onchain.json)).
- CHECKED (latest block 26,431,766): CreditVault has no EIP-1967 implementation; `signer()` = `0x0b89c5eb…`; `owner()`
  = `0x9b9dc7c5…`, an unverified contract that is not a Safe and has no `getMinDelay`.
- CHECKED (Blockscout, 2026-11-17): the vault's last direct transaction was `settle` on 2026-07-14; none
  2026-10-16 to 2026-11-16. INFERRED: it is called on every credit-pool trade through `swapCallback`, so its last
  call is the pools' last trade (2026-11-16); it is not in the Xatu activity data, so `txs_30d` is null.
- CHECKED (Xatu, any function): activity per contract in the table ([`activity.json`](../evidence/native-rfq-signer/activity.json));
  `ecrecover` transactions in the yearly window: router `0xa540ec8c…` 455,212, pool `0x5d1a3436…` 454,724, router
  `0x8a2ddc04…` 46,625, pool `0xc419e673…` 46,435 (`data/report/curated_contracts.csv`).
- INFERRED: the router signer and market-maker keys have signed on-chain-submitted quotes, so their public keys are
  recoverable from calldata.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe3d41d19…` CreditVault | config-only | $6.79M | 2026-11-16 (via pools) | — |
| `0x8a2ddc04…` NativeRouter | config-only | ~$0 | 2026-11-16 | 24,381 |
| `0xc419e673…` NativeRFQPool | config-only | ~$0 | 2026-11-16 | 24,233 |
| `0xa540ec8c…` NativeRouter | config-only | ~$0 | 2026-11-15 | 858 |
| `0x5d1a3436…` NativeRFQPool | config-only | ~$0 | 2026-11-15 | 857 |
| `0x0f9f2366…` NativeRouter (paused) | config-only | $0 | 2026-08-11 | 0 |
| `0x9af2f3c0…` NativeRFQPool (not a credit pool) | config-only | $0 | 2025-10-26 | 0 |
| `0xa42c9f74…` NativeRouter (paused) | config-only | $0 | 2026-08-11 | 0 |

The CreditVault `0xe3d41d19564922c9952f692c5dd0563030f5f2ef` holds $6.79M on 2026-11-17 (`held`); it is reachable
through both live pools and through its own signer-approved withdrawals.

## Remediation

- Native deploys a router and pools whose quote and widget-fee checks use a post-quantum scheme (ERC-7913 verifier
  with ML-DSA/Falcon keys, or ERC-1271 signer contracts holding post-quantum keys), and a CreditVault whose
  settlement, collateral and liquidation approvals do the same; the vault owner `0x9b9dc7c5…` moves funds and
  `creditPools` to it and revokes the old pools' allowances. The owner Safe `0x83fc28e6…` and the vault owner can
  rotate keys and pause routers today, but neither changes the scheme.
- The owner Safe itself has ECDSA owners (PQ-12) and must move to post-quantum signers.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review17): MEDIUM kept, step 4: fix by new router and pool deployments by the owner Safe. Escrow measured: CreditVault `0xe3d41d19…` $6.79M; noted that a trade needs both the router signer and a market-maker key.
- 2026-11-17 review (Review17, follow-up): MEDIUM kept, step 4: the CreditVault is not upgradeable either, so the fix is still a new deployment. CreditVault `0xe3d41d19…` added to `contracts[]`, with its own signer path (`settle`, `removeCollateral`, `liquidate`); the $6.79M moved from the router's `escrow` value to the vault's `held` value.
