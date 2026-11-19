---
id: manta-finality-bls-bn254
title: "Manta finality AVS: forged BN254 BLS quorums in its two BLSApkRegistry deployments no longer shorten any withdrawal window (oracle hook removed, or oracle unused)"
project: manta
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: none
alternative: sole
role: core
contracts:
- address: "0xa80f2401c8ae7d95c7995295dc2c0d651f25fd60"
  implementation: "0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f"
  name: BLSApkRegistry (TransparentUpgradeableProxy; production, Manta Pacific)
  upgradeable: "yes"
  admin: "ProxyAdmin 0xab64a3da57886cd4205176c72b8be63c34e46366, owner EOA 0xbfda2df9cd91cf7a3e794edb9c268588d42d7c01 (read at block 26431575)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-10
  txs_30d: 0
- address: "0x33ade04d39283dd7105e2961621f204a5bc2620d"
  implementation: "0x2423a4a6e9020fec543e46f27fcb1806a569d002"
  name: BLSApkRegistry (TransparentUpgradeableProxy; 2025 deployment with an unused oracle)
  upgradeable: "yes"
  admin: "ProxyAdmin 0xcfd3871e84d84d2b2ec74e1ca728abcef05081ff owned by EOA 0x4e3321e3e2a6b032b07e20637d7f10fd77272cb4, also owner() (read at block 26431811)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-08-28
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Manta: EOA 0xbfda2df9cd91cf7a3e794edb9c268588d42d7c01 (production registry, FinalityRelayerManager 0x8e132b3bd37f3f6e223cd23add390111e674c94e and their ProxyAdmin) and EOA 0x4e3321e3e2a6b032b07e20637d7f10fd77272cb4 (2025 registry and FinalityRelayerManager 0x3df6605c93fc786773900d19239a4508d0ab6bb9); nothing is needed while no oracle that a portal reads calls back into them"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0xa80f2401
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review21 (0xa80f2401 registry, manager and Manta Pacific L2OutputOracle reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/consumer-a80f2401.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  study: top-callers-classification
  who: review (Review01)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/consumer.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Manta's MANTA/BTC-staked finality operators sign output roots with BN254 BLS, checked by `BLSApkRegistry` (PQ-6);
an accepted signature lets `FinalityRelayerManager` shorten the finalization (challenge) period of an
`L2OutputOracle`. There are two deployments. The production one (`0xa80f2401…`) targets Manta Pacific's oracle
`0x30c78967…`, whose current implementation has removed the hook, so a forged quorum now reverts; it last ran in
2026-06. The 2025 one (`0x33ade04d…`) targets oracle `0x9dac8be6…`, which no portal reads; it last ran on 2025-08-28.
Nothing is held and nothing can be taken through either. Rated LOW (step 4: the path is dormant and holds nothing).

## Mechanism

- `BLSApkRegistry.checkSignatures` (`src/bls/BLSApkRegistry.sol` lines 130–157 in `0x8ad2384a…`, 133–150 in
  `0x2423a4a6…`) subtracts non-signer keys from the aggregate key and calls `trySignatureAndApkVerification`
  (line 165), a BN254 pairing; `registerBLSPublicKey` (line 71) checks a proof of possession with a pairing.
  Recovering BLS secret keys from the registered public keys forges any quorum.
- `FinalityRelayerManager.VerifyFinalitySignature(finalityBatch, sigs, minGas)` (`onlyOperatorWhitelistManager`)
  calls `checkSignatures`, computes a reduced period from the signing MANTA and BTC stake and calls
  `L2OutputOracle.proposalChangeFinalizationPeriodSeconds(stateRoot, period)` with `require(success)`.
- Production: manager `0x8e132b3b…` (whitelist manager EOA `0xfdad88ae…`) → oracle `0x30c78967…`, read by Manta
  Pacific's portal `0x9168765e…`. The oracle's current implementation `0xc9e9b111…` (Blockscout verified) has
  `proposalChangeFinalizationPeriodSeconds` and `setFinalityProvider` commented out and selector `0xbd05743b` absent
  from its bytecode, so every call reverts.
- 2025 deployment: manager `0x3df6605c…` (whitelist manager EOA `0xe63c14b9…`) → oracle `0x9dac8be6…`, whose
  implementation `0x8a6e0334…` still has the hook, but the portal reads `0x30c78967…`, not this oracle.

Excerpts (both implementations): [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/source-excerpts.md). For
`0x33ade04d…` the proxy section shows unrelated sources (`CubeCore`, VRF) that Blockscout returned for the proxy
address; the implementation section is the relevant code.

## Evidence

- CHECKED (verified source, Blockscout/Sourcify): both `BLSApkRegistry` implementations, `FinalityRelayerManager`
  (`0x9d6def8b…`) and Manta Pacific's current `L2OutputOracle` as above.
- CHECKED (Review21, block 26,431,575, [`consumer-a80f2401.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/consumer-a80f2401.json)):
  registry implementation `0x8ad2384a…`, ProxyAdmin `0xab64a3da…` whose `owner()` is EOA `0xbfda2df9…` (nonce 153),
  also owner of the registry and of manager `0x8e132b3b…`; manager `l2OutputOracle()` = `0x30c78967…`,
  `confirmBatchId()` = 13,890; oracle `FINALIZATION_PERIOD_SECONDS` = 259,200, outputs still proposed (last
  2026-11-16); last `VerifyFinalitySig` event at block 25,286,243; 9,361 BN254 calls in the trace year.
- CHECKED (Review01, block 26,431,811, [`consumer.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/consumer.json)):
  `0x33ade04d…` implementation `0x2423a4a6…`, `owner()` of registry, manager `0x3df6605c…` and ProxyAdmin
  `0xcfd3871e…` = EOA `0x4e3321e3…` (nonce 550); manager `l2OutputOracle()` = `0x9dac8be6…`; oracle `PROPOSER()` =
  `CHALLENGER()` = `0x4e3321e3…`, `finalityProvider()` = `0x3df6605c…`, last output 483 at L2 block 6,213,240
  (2025-08-28); Manta Pacific portal `0x9168765e…` `L2_ORACLE()` = `0x30c78967…`. Precompile corpus: 401 pairing
  calls, blocks 23,180,179–23,237,330; the last (tx `0x45a75d97…`) is `VerifyFinalitySignature` to `0x3df6605c…`.
- CHECKED (Blockscout, contracts created by `0x4e3321e3…`): an earlier registry/manager pair (`0x5a5c1dfb…`,
  `0x496f02f6…`, block 23,159,620) has no precompile calls.
- CHECKED: registries, managers and the 2025 oracle hold no ETH or tokens
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/manta-finality-bls-bn254/onchain.json)).
- INFERRED: `0x9dac8be6…` is a staging or abandoned oracle; no consumer reading it was found, but not every contract on
  mainnet was checked.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa80f2401…` BLSApkRegistry (production) | yes (EOA owner) | 0 | 2026-06-10 | 0 |
| `0x33ade04d…` BLSApkRegistry (2025) | yes (EOA owner) | 0 | 2025-08-28 | 0 |

No escrow is reachable. While the production hook existed, a forged quorum (submitted by the whitelist-manager EOA)
could cut the 3-day window in which Manta's challenger can delete a bad output root, for withdrawals through Manta
Pacific's portal (8,206 ETH). With the hook removed the call reverts, and the 2025 deployment points at an oracle the
portal does not read.

## Remediation

- If Manta re-enables the finality shortcut: operator attestations in a post-quantum scheme (hash-based signatures
  aggregated in a STARK, or a stake-weighted count of post-quantum signatures) in a new `BLSApkRegistry`
  implementation, by EOA `0xbfda2df9cd91cf7a3e794edb9c268588d42d7c01` (production) or
  `0x4e3321e3e2a6b032b07e20637d7f10fd77272cb4` (2025 deployment).
- Until then nobody needs to act; Manta should not re-add `proposalChangeFinalizationPeriodSeconds` to an oracle that
  a portal reads while the registry verifies BLS. Retiring the registries and managers closes the path. No protocol
  change is needed. Users can do nothing here.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1: no activity in the last 12 months and nothing held).
- 2026-11-17 review (Review01): LOW kept, step 1: last use 2025-08-28, nothing held; consumer traced to FinalityRelayerManager 0x3df6605c… and an L2OutputOracle 0x9dac8be6… that Manta Pacific's portal does not read, so impact set to none; production registry 0xa80f2401… belongs here.
- 2026-11-17 merge (Review01): `unidentified-a80f2401-bls` merged into this finding on Main's instruction: contract `0xa80f2401…`, its evidence (classification row, on-chain and activity entries, source-excerpt section, `consumer.json` as `consumer-a80f2401.json`) and sources moved here. Its history: 2026-11-04 classified (hand classification pass); 2026-11-17 created by `scripts/15_findings.py`, rated MEDIUM (step 4); 2026-11-17 review (Review21): MEDIUM -> LOW, step 4: Manta's L2OutputOracle implementation `0xc9e9b111…` no longer has the finality hook, so the BLS check releases nothing (dormant path, holds nothing); impact funds-loss -> none; identified as Manta. With both registries the rating is LOW (step 4: dormant path, holds nothing).
- 2026-11-19: LOW kept, step 1 removed (dormancy no longer lowers a rating); step 4 also gives LOW: the check no longer releases anything.
