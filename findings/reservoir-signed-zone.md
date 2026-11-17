---
id: reservoir-signed-zone
title: "Reservoir Seaport Oracle zone (SignedZoneV16): a quantum attacker who recovers one of the oracle's ECDSA co-signer keys can fill Seaport orders whose makers cancelled them off-chain"
project: reservoir
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x2d1a340cd83434243d090931afabf95b7d3078b0"
  implementation: null
  name: SignedZoneV16
  upgradeable: config-only
  admin: "SignedZoneControllerV16 0x77f48ccb3ede5bf4abfb8eefe61739ed01c240ce; zone owner 0xf3d63166f0ca56c3c1a3508fce03ff0cf3fb691e (EOA with EIP-7702 delegation) manages signers"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-10
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Reservoir: zone owner 0xf3d63166f0ca56c3c1a3508fce03ff0cf3fb691e removes the three active signers through SignedZoneControllerV16 0x77f48ccb3ede5bf4abfb8eefe61739ed01c240ce; a post-quantum co-signer would need a new zone"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/reservoir-signed-zone
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; controller, owner and signer reads; attribution)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/reservoir-signed-zone/zone.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [opensea-zone-and-drop-signers]
---

## Summary

Reservoir's Seaport Oracle lets NFT makers cancel or reprice Seaport orders off-chain: orders name this zone, and
Seaport fills them only with a fresh co-signature from one of the oracle's signer keys, checked with `ecrecover` only
(PQ-4). The keys have signed on-chain, so a quantum attacker can recover one and fill orders the oracle would refuse,
including orders their makers cancelled off-chain; the maker loses the gap between the stale order price and the market.
Nothing is pooled and the loss is not measurable; the zone has had no transaction since 2026-03-10. Rated LOW (step 4):
one known operator, the zone owner, can switch the exposure off by removing the signers.

## Mechanism

- `SignedZoneV16.authorizeOrder(zoneParameters)` (`contracts/seaport-oracle/zones/SignedZoneV16.sol` line 109), called
  by Seaport for restricted orders that name the zone, reads the expected fulfiller (`_getExpectedFulfiller`, line 209),
  expiration and context from `extraData`, derives the EIP-712 signed-order hash and recovers the signer with
  `_recoverSigner` (lines 434-524: inline `ecrecover` on a 64/65-byte signature, excerpt lines 501-509). It reverts with
  `SignerNotActive` unless `_signers[recoveredSigner]` (lines 230-234).
- Signers are changed only by the controller (`_updateSigner`, `_assertCallerIsController`, lines 315-317 and 631);
  the controller acts for the zone owner.
- The maker's own Seaport signature is still needed; the zone only decides whether a fill goes ahead.
- Pattern PQ-4. Excerpts: [`source-excerpts.md`](#source-excerpts-reservoir-signed-zone).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the path above.
- CHECKED (on-chain, block 26,431,214): no proxy or owner on the zone itself; holds nothing
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/reservoir-signed-zone/onchain.json)).
- CHECKED (on-chain, block 26,431,457, [`zone.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/reservoir-signed-zone/zone.json)): created by
  SignedZoneControllerV16 `0x77f48ccb…` (Blockscout); `ownerOf(zone)` = `0xf3d63166…`, an EOA with an EIP-7702
  delegation to `EIP7702StatelessDeleGator`; `getActiveSigners(zone)` returns three signers; `getSeaportMetadata()`
  returns `CancellationOracle`.
- CHECKED (attribution): the source tree `contracts/seaport-oracle/` and the `CancellationOracle` name match Reservoir's
  Seaport Oracle (github.com/reservoirprotocol/seaport-oracle; Reservoir's off-chain-cancellation docs).
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 25,587
  transactions. Xatu: no transaction 2026-10-16 to 2026-11-16, last 2026-03-10
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/reservoir-signed-zone/activity.json)).
- INFERRED: whether the three signers are still held by Reservoir's service, and how many open orders still name the
  zone; not established.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2d1a340c…` SignedZoneV16 | config-only | — | 2026-03-10 | 0 |

A forged co-signature only lets a fill go ahead; it releases the maker's offer items at the maker's own signed terms.
The exposure is open orders naming this zone that their makers cancelled off-chain only; not measurable from balances,
`value_usd` is `null`. Other Reservoir deployments were not searched.

## Remediation

- The zone owner removes the three ECDSA signers through SignedZoneControllerV16; open orders naming the zone then
  cannot be filled, which ends the exposure (and the service on this zone). A post-quantum version would be a new zone
  that verifies a post-quantum co-signer.
- Makers who rely on off-chain cancellation should cancel on-chain in Seaport (`cancel`/`incrementCounter`).
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: drafted by `scripts/15_findings.py` inside `opensea-zone-and-drop-signers`, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16; that finding was rated MEDIUM (step 4).
- 2026-11-17 review (Review13): split out of `opensea-zone-and-drop-signers` (the zone is Reservoir's, not OpenSea's). MEDIUM -> LOW, step 4: one known operator (the zone owner) removes the signers; nothing pooled, idle since 2026-03-10.

# Source excerpts: reservoir-signed-zone

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x2d1a340cd83434243d090931afabf95b7d3078b0` — SignedZoneV16 (verified source via sourcify)

### `contracts/seaport-oracle/zones/SignedZoneV16.sol`

```solidity
  501            // address if the signature is invalid.
  502            pop(
  503              staticcall(
  504                gas(),
  505                Ecrecover_precompile, // Call ecrecover precompile.
  506                wordBeforeSignaturePtr, // Use data memory location.
  507                Ecrecover_args_size, // Size of digest, v, r, and s.
  508                0, // Write result to scratch space.
  509                OneWord // Provide size of returned result.
  ...
```
