---
id: gasp-finalizer-bls-bn254
title: "Gasp finalizer AVS: a forged BN254 BLS quorum lets the aggregator post a false withdrawal root to Rolldown (USD 15k); the owner Safe can swap the checker"
project: gasp
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xc7bf5248bd4e4e618b01414600d48530e677ca0d"
  implementation: null
  name: BLSSignatureChecker
  upgradeable: config-only
  admin: "none on the checker (registryCoordinator 0x9a986296d45c327daa5998519ae1b3757f1e6ba1 fixed); consumer FinalizerTaskManager 0x150fe8dbb943c372f3e8c31d9c89f1e6a13cbbfd can updateBlsSignatureCheckerAddress (owner Safe 0xfc8151f19e338c509d1f5b8c981249324014b6b7, 4 of 7; read at block 26431796)"
  value_usd: 14925
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-01-21
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Gasp: owner Safe 0xfc8151f19e338c509d1f5b8c981249324014b6b7 (4 of 7) points FinalizerTaskManager 0x150fe8dbb943c372f3e8c31d9c89f1e6a13cbbfd at a post-quantum attestation checker, or upgrades it through ProxyAdmin 0x00c62fbf897069e635d808a0c5cd4f36c33538cd (same owner)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gasp-finalizer-bls-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review01)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gasp-finalizer-bls-bn254/consumer.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`0xc7bf5248…` is the EigenLayer `BLSSignatureChecker` of Gasp's finalizer AVS (PQ-6). Gasp's `FinalizerTaskManager`
accepts a batch of L2→L1 updates when operators holding enough stake sign it with BN254 BLS, and then writes the
batch's Merkle root into Gasp's L1 bridge `Rolldown`, from which withdrawals are paid against that root. A quantum
attacker who recovers enough operators' BLS keys and controls the aggregator can post a false root and withdraw what
Rolldown holds: USD 14.9k on 2026-11-17. The task manager's owner Safe can point it at another checker. Rated LOW
(step 4: MEDIUM, a new checker the owner points at; step 5: under USD 50k exposed; was MEDIUM).

## Mechanism

- `FinalizerTaskManager.respondToRdTask(task, taskResponse, nonSignerStakesAndSignature)` (implementation
  `0xb3a2481e…`, `onlyAggregator`, `src/FinalizerTaskManager.sol` line 283) calls `_checkTaskResponse` →
  `blsSignatureChecker.checkSignatures(message, quorumNumbers, referenceBlock, …)` (line 446) and compares signed stake
  with the task's quorum threshold. If reached and the chain is Ethereum, it calls
  `rolldown.update_l1_from_l2(taskResponse.rdUpdate, range)`.
- `BLSSignatureChecker.checkSignatures` (excerpt) subtracts non-signers from the aggregate key and calls
  `trySignatureAndApkVerification`, a BN254 pairing (`staticcall(pairingGas, 8, …)`, excerpt line 262). BLS secret
  keys follow from public keys, so a quorum signature can be forged.
- `Rolldown.update_l1_from_l2` (implementation `0xeafc65d0…`, `onlyRole(UPDATER_ROLE)`, held only by the task
  manager) stores the root; `close_withdrawal(withdrawal, merkleRoot, proof)` pays a withdrawal proven against it.
- `FinalizerTaskManager.updateBlsSignatureCheckerAddress` (`onlyOwner`, line 144) replaces the checker.

## Evidence

- CHECKED (verified source, Sourcify): `BLSSignatureChecker`, `FinalizerTaskManager` and `Rolldown` as quoted.
- CHECKED (precompile corpus): last pairing call in tx `0x6cddb27c…` (block 24,283,072, 2026-01-21), a
  `respondToRdTask` sent by aggregator `0x3f261ad6…` to `0x150fe8db…`; 2,220 transactions in the trace year
  (`txs_y1`).
- CHECKED (block 26,431,796, [`consumer.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gasp-finalizer-bls-bn254/consumer.json)): task manager
  `blsSignatureChecker()` = `0xc7bf5248…`, `rolldown()` = `0x79d968d9…`, `registryCoordinator()` = `0x9a986296…`,
  aggregator and generator `0x3f261ad6…`, not paused, last completed RD task 4,902 at block 24,283,072; proxy admin
  `0x00c62fbf…` and `owner()` both Safe `0xfc8151f1…` (4 of 7), which also holds Rolldown's `DEFAULT_ADMIN_ROLE`;
  `UPDATER_ROLE` on Rolldown held only by the task manager (RoleGranted logs since creation, `hasRole`).
- CHECKED (block 26,431,796): Rolldown `0x79d968d9…` holds 2.67 ETH and USD 10.1k of tokens (USDT 7.5k, USDC 2.2k,
  EIGEN), USD 14,925 in total, not paused.
- CHECKED (attribution): `0x9a986296…` is the mainnet "Gasp AVS Registry Contract" in Gasp's operator documentation
  (github.com/gasp-xyz/avs-operator-setup).
- INFERRED: no finalization since 2026-01-21 suggests the L2 is idle, but the path is open and Rolldown still holds
  funds.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xc7bf5248…` BLSSignatureChecker | config-only (consumer repoints) | USD 14.9k (escrow: Rolldown) | 2026-01-21 | 0 |

Escrow: Gasp `Rolldown` `0x79d968d9017b96f202ad4673a2c1bbbdc905a4ca` (ETH and ERC-20 deposits), USD 14,925 at block
26,431,796. The attacker must also act as the aggregator (`onlyAggregator`); the aggregator is an ECDSA EOA that a CRQC
could also forge, which is a separate exposure.

## Remediation

- Replacement: a post-quantum operator attestation (hash-based signatures aggregated in a STARK, or a validity proof
  of the L2 state) behind the same `checkSignatures` call site, or an upgraded task manager.
- Who acts: Gasp's owner Safe `0xfc8151f19e338c509d1f5b8c981249324014b6b7` (4 of 7) calls
  `updateBlsSignatureCheckerAddress` on `0x150fe8dbb943c372f3e8c31d9c89f1e6a13cbbfd`, or upgrades it via ProxyAdmin
  `0x00c62fbf897069e635d808a0c5cd4f36c33538cd`. Rotating operator BLS keys does not help.
- No protocol change is needed. Depositors can withdraw from Rolldown.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review01): MEDIUM -> LOW, step 5: escrow measured (Gasp Rolldown, USD 14.9k at block 26,431,796); step 4 stays MEDIUM because the consumer's owner Safe can repoint the checker (the draft's "key-rotation-only, no admin" was wrong); project identified as Gasp.
- 2026-11-17 integration: id renamed from `unidentified-c7bf5248-bls` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.
