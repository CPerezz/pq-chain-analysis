---
id: injective-peggy-valset
title: "Injective Peggy bridge: a quantum attacker who recovers the Ethereum keys of validators holding over 2/3 of power (14 of 45 today) can sign batches that release the USD 657M locked in Peggy"
project: injective
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3"
  implementation: "0x100dcb8b78c608d148cb207ac3875935dfe6abdc"
  name: Peggy (TransparentUpgradeableProxy)
  upgradeable: "yes"
  admin: ProxyAdmin 0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb owned by Safe 0x545a65a9d36ecedceeb7162574859a2a50ecf9ed (v1.1.1, 3 of 5); Peggy's own owner (pause) has expired and is zero (read at block 26,431,526)
  value_usd: 657038370
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 376
families: []
fix:
  layer: contract-upgrade
  who_acts: Safe 0x545a65a9d36ecedceeb7162574859a2a50ecf9ed (3 of 5) upgrades Peggy through ProxyAdmin 0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb, together with an Injective chain upgrade (governance) so that validators' orchestrators sign with a post-quantum scheme
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/injective-peggy-valset/classification.jsonl
  - evidence/injective-peggy-valset/onchain.json
  - evidence/injective-peggy-valset/activity.json
  - evidence/injective-peggy-valset/source-excerpts.md
  - evidence/injective-peggy-valset/admin-reads.json
  - evidence/injective-peggy-valset/valset.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

Peggy (`0xf955c57f…`) is Injective's Ethereum bridge: it locks ERC-20s sent to Injective and releases them when the
Injective validator set signs a withdrawal batch. Each validator signs with a secp256k1 Ethereum key, checked with
`ecrecover`, and signatures must cover more than 2/3 of voting power (PQ-5). A CRQC holder who recovers those keys
(their signatures are in every `updateValset` and `submitBatch` call) can sign batches that pay out everything Peggy
holds, USD 657M on 2026-11-17, or install their own valset. Peggy is behind a proxy whose admin is a 3-of-5 Safe, so the
check can be replaced by an upgrade. Rated MEDIUM, step 4: fix by a contract upgrade (with an Injective chain upgrade).

## Mechanism

- `submitBatch(currentValset, v[], r[], s[], amounts[], destinations[], fees[], batchNonce, token, batchTimeout)`
  checks the supplied valset against `state_lastValsetCheckpoint`, then `checkValidatorSignatures` over
  `keccak256(abi.encode(peggyId, "transactionBatch", amounts, destinations, fees, batchNonce, token, timeout))`, and
  transfers `amounts[i]` of `token` to `destinations[i]`.
- `updateValset(newValset, currentValset, v[], r[], s[])` uses the same check to replace the stored checkpoint, so a
  forged quorum can also hand the bridge to attacker keys permanently.
- `checkValidatorSignatures` sums the power of validators whose `verifySig` passes and requires it to exceed
  `state_powerThreshold`; `verifySig` is `_signer == ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s)`
  (`Peggy.sol` lines 1253–1264, 1296–1336).
- Pattern PQ-5. Excerpts: [`source-excerpts.md`](../evidence/injective-peggy-valset/source-excerpts.md).

## Evidence

- CHECKED (Sourcify, implementation `0x100dcb8b…`, fetched 2026-11-17): `Peggy.sol` `verifySig`,
  `checkValidatorSignatures`, `updateValset`, `submitBatch`; `emergencyPause` is `onlyOwner`.
- CHECKED (on-chain read at block 26,431,526): EIP-1967 implementation `0x100dcb8b…`, admin ProxyAdmin `0x4b5dec94…`
  whose `owner()` is Safe `0x545a65a9…` (v1.1.1, threshold 3, 5 owners); Peggy `owner()` zero and
  `isOwnershipExpired()` true, so nobody can pause; `state_powerThreshold` 2,863,311,530 (2/3 of 2^32)
  ([`admin-reads.json`](../evidence/injective-peggy-valset/admin-reads.json)).
- CHECKED (Blockscout logs): the latest `ValsetUpdatedEvent` (block 26,412,687, valset nonce 191,686,186, which matches
  `state_lastValsetNonce`) lists 45 validators; the 14 largest exceed the threshold
  ([`valset.json`](../evidence/injective-peggy-valset/valset.json)).
- CHECKED (on-chain read at block 26,431,214): holdings USD 657.0M, of which INJ USD 652.4M, USDT USD 4.0M
  ([`onchain.json`](../evidence/injective-peggy-valset/onchain.json)).
- CHECKED (Xatu, any function): 376 transactions 2026-10-16 to 2026-11-16, last on 2026-11-15
  ([`activity.json`](../evidence/injective-peggy-valset/activity.json)); 4,767 transactions with an `ecrecover` call in
  the year to March 2026 (`txs_y1`, `data/report/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf955c57f…` Peggy (TransparentUpgradeableProxy) | yes | $657.0M | 2026-11-15 | 376 |

The exposure is Peggy's own balance (basis `held`): locked Ethereum-side INJ and bridged ERC-20s. A forged valset
update would also let the attacker release any future deposits. The upgrade path itself rests on the Safe's five owners,
all code-less EOAs at block 26,431,526 (PQ-12), which is a separate wallet exposure.

## Remediation

- Upgrade Peggy's implementation (Safe `0x545a65a9…` through ProxyAdmin `0x4b5dec94…`) to verify a post-quantum
  attestation: per-validator post-quantum signatures (with a power-weighted threshold) or a STARK over the Injective
  validator signatures. Injective's peggy module and orchestrators must change at the same time (chain governance).
- Rotating validator Ethereum keys through `updateValset` does not help; the scheme must change.
- Moving the Safe's owners to post-quantum signers protects the upgrade path. No Ethereum protocol change needed.
- Users can only reduce exposure by not keeping assets bridged through Peggy.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM kept, step 4. Source re-read; proxy admin and Safe re-read at block 26,431,526; Peggy owner found expired (no pause); current valset decoded (45 validators, 14 for a quorum).
