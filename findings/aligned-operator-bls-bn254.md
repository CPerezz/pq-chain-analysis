---
id: aligned-operator-bls-bn254
title: "Aligned Layer service manager: a quantum attacker who recovers the operators' BN254 BLS keys (and the aggregator's ECDSA key) can mark false proof batches as verified; the only on-chain consumer seen holds nothing"
project: aligned
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xef2a435e5ee44b2041100ef8cbc8ae035166606c"
  implementation: "0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8"
  name: TransparentUpgradeableProxy → AlignedLayerServiceManager
  upgradeable: "yes"
  admin: ProxyAdmin 0x487e0347b96be3606845a3aadc7b0d8138952b47, owner Safe 0xfc135a861eff65b7644fb03d9f851251546c0835 (5 of 8); contract owner() is the same Safe (read at block 26431523)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-03
  txs_30d: 1
- address: "0x96b6a29d7b98519ae66e6398bd27a76b30a5dc3f"
  implementation: "0x32112b2c1a2cd002a8468fcd556e9010cd817ea1"
  name: TransparentUpgradeableProxy → AlignedLayerServiceManager (second deployment)
  upgradeable: "yes"
  admin: ProxyAdmin 0x0d16a82be664c337c615499f8775ef0431703dac, owner Safe 0x2106ac6fe9599f8a0710643c75661aaf8d8b1599 (1 of 1, owner 0xc79b49e7f011d69c71a83478829b3b7817a257f5) (read at block 26431523)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-21
  txs_30d: 0
families:
- code: "0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8"
  name: AlignedLayerServiceManager implementation
  instances: 2
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0x32112b2c1a2cd002a8468fcd556e9010cd817ea1"
  name: AlignedLayerServiceManager implementation (older)
  instances: 3
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: contract-upgrade
  who_acts: Aligned, through ProxyAdmin 0x487e0347b96be3606845a3aadc7b0d8138952b47 owned by Safe 0xfc135a861eff65b7644fb03d9f851251546c0835 (5 of 8); operators register post-quantum keys
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aligned-operator-bls-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review22)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aligned-operator-bls-bn254/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Aligned's service manager marks a proof batch as verified when the aggregator submits an EigenLayer BN254 BLS aggregate
signature from at least 67% of quorum-0 stake. A quantum attacker who recovers the operators' BLS secret keys, and the
aggregator EOA's ECDSA key (needed to call `respondToTaskV2`), can mark a batch of false proofs as verified. Any contract
that trusts `verifyBatchInclusion` would then accept them. The only on-chain consumer seen since March 2026, a demo
`VoteInbox`, holds nothing, and a forged quorum cannot take the batchers' 0.95 ETH deposit beyond capped fees. Rated LOW
(step 4: MEDIUM, a 5-of-8 Safe can upgrade; step 5: measured exposure under $50k).

## Mechanism

- `respondToTaskV2(batchMerkleRoot, senderAddress, nonSignerStakesAndSignature)` (`AlignedLayerServiceManager.sol`
  line 152) is `onlyAggregator` (line 369). It calls `BLSSignatureChecker.checkSignatures` (line 192), which aggregates
  the quorum APK minus non-signers and runs `trySignatureAndApkVerification` → `BN254.safePairing` (`BLSSignatureChecker.sol`
  lines 263-321). It then requires signed stake ≥ 67% of total stake (lines 198-210), sets `responded = true` and pays
  the aggregator its gas, capped at the batch's `respondToTaskFeeLimit`, from the batcher's balance.
- `verifyBatchInclusion(...)` (lines 256 and 302) returns true for any Merkle leaf of a responded batch. This is what
  a consumer checks before acting on a proof. PQ-6: BLS secret keys follow from the registered public keys.
- The contract has no other way to verify a batch; replacing the scheme needs a new implementation.

## Evidence

- CHECKED (verified source on Sourcify, implementation `0x4a5d61ab…`): the code path above.
- CHECKED (RPC at block 26,431,523; [`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aligned-operator-bls-bn254/review-reads.json)):
  EIP-1967 implementation `0x4a5d61ab…`, admin ProxyAdmin `0x487e0347…`, whose `owner()` is Safe `0xfc135a86…`
  (threshold 5, 8 owners), which is also the contract `owner()`; `alignedAggregator()` = `0xba9bae4c…` (EOA);
  `paused()` = 0; quorum count 1, 18 operators in quorum 0; balance 0.9487 ETH (batcher deposits). Second deployment
  `0x96b6a29d…`: implementation `0x32112b2c…`, ProxyAdmin `0x0d16a82b…` owned by a 1-of-1 Safe `0x2106ac6f…`, balance
  0.012 ETH.
- CHECKED (Xatu call frames since block 24,700,000): 152 direct transactions, the last `respondToTaskV2` on 2026-06-24
  (block 25,388,418). Internal calls came from BatcherPaymentService `0xb0567184…` (`createNewTask`, 152),
  RegistryCoordinator (operator (de)registration, 23; the 2026-11-03 transaction is one of these), VoteInbox
  `0x1870cfa5…` (`submitVote` → `verifyBatchInclusion`, 16) and a Safe (4). There were 9,042 pre-quantum calls in the
  year to March 2026 (`curated_contracts.csv`).
- CHECKED (Blockscout, verified source): VoteInbox `0x1870cfa5…` is a voting demo that holds 0 ETH and no tokens.
- INFERRED: off-chain users of Aligned results, and consumers that called before block 24,700,000, are not covered.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xef2a435e…` AlignedLayerServiceManager | yes (5/8 Safe) | $0 (escrow: consumers seen) | 2026-11-03 | 1 |
| `0x96b6a29d…` AlignedLayerServiceManager (second) | yes (1/1 Safe) | — | 2025-04-21 | 0 |

- Escrow: the only on-chain consumer of `verifyBatchInclusion` seen since block 24,700,000 is VoteInbox `0x1870cfa5…`,
  which holds $0 (2026-11-17). The service manager's own 0.9487 ETH (about $1.7k) belongs to batchers. A forged
  quorum releases only the aggregator's per-batch fee from it, and `withdraw` pays only the batcher itself, so it is
  not counted.
- Aligned's BatcherPaymentService `0xb0567184…` holds user deposits, but releases them on users' and the batcher's
  ECDSA signatures, not on this BLS check.
- The second deployment `0x96b6a29d…` has not been called since 2025-04-21 and holds 0.012 ETH (step 1 on its own:
  LOW).
- Proving and verification have been idle since 2026-06-24 (no `respondToTaskV2`).

## Remediation

- Upgrade the service manager (ProxyAdmin `0x487e0347…`, owner Safe `0xfc135a86…`, 5 of 8) to verify a post-quantum
  attestation, for example hash-based signatures aggregated in a STARK, with operators registering post-quantum keys in
  the registry contracts. The `onlyAggregator` gate should also move off a single ECDSA EOA.
- Consumers that act on `verifyBatchInclusion` should not secure value with it until then.
- Protocol change: not needed. Pausing `respondToTaskV2` (pause bit 1, pauser registry `0xbb8ff038…`) is the stop gap.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review22): MEDIUM -> LOW, step 5: exposure measured as escrow: the only on-chain consumer of `verifyBatchInclusion` seen (VoteInbox 0x1870cfa5) holds $0, and the 0.95 ETH of batcher deposits cannot be taken by a forged quorum. Step 4 alone would be MEDIUM (upgrade by the 5-of-8 Safe). Noted that the aggregator EOA's ECDSA key is also needed.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.
