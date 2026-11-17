---
id: pendle-limit-order-sig
title: "Pendle Limit Router: a quantum attacker can forge a maker's old ECDSA key to fill limit orders against that maker's approved tokens, even after the maker moves to a post-quantum smart account at the same address"
project: pendle
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x000000000000c9b3e2c3ec88b1b4c0cd853f4321"
  implementation: "0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b"
  name: TransparentUpgradeableProxy → PendleLimitRouter
  upgradeable: "yes"
  admin: "ProxyAdmin 0xa28c08f165116587d4f3e708743b4dee155c5e64, owned by Safe 0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1 (3 of 5); router owner() 0x2ad631f72fb16d91c4953a7f4260a97c2fe2f31e (PendleGovernanceProxy, admin role held by the same Safe); read at block 26431426"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 13318
families: []
fix:
  layer: contract-upgrade
  who_acts: "Pendle: Safe 0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1 (3 of 5) upgrades the router through ProxyAdmin 0xa28c08f165116587d4f3e708743b4dee155c5e64"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/pendle-limit-order-sig/classification.jsonl
  - evidence/pendle-limit-order-sig/onchain.json
  - evidence/pendle-limit-order-sig/activity.json
  - evidence/pendle-limit-order-sig/source-excerpts.md
  - evidence/pendle-limit-order-sig/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review23 (finding review)
  ref: evidence/pendle-limit-order-sig/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Pendle's limit-order router checks a maker's order signature with OpenZeppelin 4.9 `SignatureChecker`, which tries
`ecrecover` before ERC-1271 (PQ-2). Post-quantum smart accounts can already sign through ERC-1271 or pre-sign on
chain, but an address that migrates in place stays forgeable with its old secp256k1 key: a quantum attacker can sign
orders at any price for that maker and fill them, pulling whatever the maker has approved to the router. The exposure
is makers' approvals to the router, which was not measured (the router holds about $0). Rated MEDIUM (step 4): the
router is an upgradeable proxy controlled by Pendle's 3-of-5 Safe, so one upgrade removes the ECDSA-first path.

## Mechanism

- `fill(params, …)` → `_checkSig_updMakingAndStatus` → `_checkSig(order, signature)`: for an order that was not
  pre-signed, `SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature)` (`LimitRouterBase.sol` line
  297). The library (v4.9.0) returns true if `ECDSA.tryRecover(hash, signature) == signer`, and only otherwise calls
  `isValidSignature` on the maker.
- The fill then pulls the maker's tokens with `_transferIn(order.token, order.maker, makingAmount)` (SY or tokens
  converted to SY for `SY_FOR_PT`/`SY_FOR_YT` orders; PT/YT for the reverse), and pays the maker in the asset and at
  the rate the order states, so a forged order at a bad rate transfers the maker's value to the taker.
- Alternatives: `preSignSingle`/`preSignBatch` (`order.maker == msg.sender`) bypass the signature check, and ERC-1271
  works for makers with code, so post-quantum accounts are not locked out.
- A second, separate check: `MintSyHelper._verifyMintSyData` requires two operator signatures (`mintSySigner1/2`) for
  the optional mint-SY swap data. Both signers are `address(0)` on mainnet, so that option is disabled; when set, its
  effect is bounded per order by the maker's `failSafeRate`.
- Pattern PQ-2. Excerpt: [`source-excerpts.md`](../evidence/pendle-limit-order-sig/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0xc96ca8f0…`): `LimitRouterBase._checkSig`, OpenZeppelin
  `SignatureChecker` v4.9.0 body, `PendleLimitRouter.preSignSingle`, `MintSyHelper._verifyMintSyData`
  ([`notes.md`](../evidence/pendle-limit-order-sig/notes.md)).
- CHECKED (on-chain read, block 26,431,426): EIP-1967 implementation `0xc96ca8f0…`, admin `0xa28c08f1…`;
  `ProxyAdmin.owner()` = Safe `0x8119ec16…`; router `owner()` = `0x2ad631f7…` (PendleGovernanceProxy) whose
  `DEFAULT_ADMIN_ROLE` is held by the same Safe; `mintSySigner1/2` = zero.
- CHECKED (on-chain read, block 26,431,214): Safe threshold 3 of 5 owners; router holds about $0.06
  ([`onchain.json`](../evidence/pendle-limit-order-sig/onchain.json)).
- CHECKED (Xatu, any function): 13,318 transactions 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](../evidence/pendle-limit-order-sig/activity.json)). Pre-quantum use over a year
  (`curated_contracts.csv`): `txs_y1` 29,490 ecrecover transactions, `usd_tx_y1` $7.14B.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…4321` TransparentUpgradeableProxy → PendleLimitRouter | yes (Safe 3/5) | makers' approvals to the router, not measured; holds ~$0 | 2026-11-16 | 13,318 |

The router keeps no balances; what a forged signature can take is each affected maker's allowance (SY, PT, YT or the
input token) to `0x000000000000c9b3e2c3ec88b1b4c0cd853f4321`, capped by their balance. Measuring it needs an
Approval-event scan across Pendle tokens and was not done. Only makers whose address has migrated to post-quantum
code (or who still use their ECDSA key) are affected; EOA makers are as safe as their own key. No other Pendle
limit-router deployment is in the registry.

## Remediation

- Pendle upgrades the implementation to a signature check that looks at account code first (current OpenZeppelin
  `SignatureChecker` or Solady `SignatureCheckerLib`, PQ-13) and passes the full signature to ERC-1271 / ERC-7913.
  Acting party: Safe `0x8119ec16…` (3 of 5) through ProxyAdmin `0xa28c08f1…`. If the mint-SY signers are ever set, they should be
  post-quantum (ERC-1271/ERC-7913) signers.
- Users: post-quantum accounts can pre-sign orders on chain; any maker can revoke approvals to the router.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated accounts with code.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review23): MEDIUM kept, step 4: upgradeable proxy, one Safe (3/5) upgrade fixes it; something can still be taken (migrated makers' approvals), so the existing alternative does not lower it. Owner resolved to PendleGovernanceProxy under the same Safe; mint-SY operator signers read as zero (disabled).
