---
id: scroll-blob-kzg
title: "Scroll: a forged KZG blob opening lets a prover finalize ScrollChain batches against data it withholds, locking the bridge's ~USD 26M"
project: scroll
status: confirmed
severity: MEDIUM
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0xa13baf47339d63b743e7da8741db5456dac1e556"
  implementation: "0x0a20703878e68e587c59204cc0ea86098b8c3ba7"
  name: TransparentUpgradeableProxy → ScrollChain
  upgradeable: "yes"
  admin: ProxyAdmin 0xeb803eb3f501998126bf37bb823646ed3d59d072, owned by ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 (DEFAULT_ADMIN_ROLE held by TimelockController 0x3f9041350b661c74c6cbe440c8bd6bc4c168a9fd, 3-day delay)
  value_usd: 26002361
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 2607
families: []
fix:
  layer: contract-upgrade
  who_acts: "Scroll: ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 (via ProxyAdmin 0xeb803eb3f501998126bf37bb823646ed3d59d072, timelock 0x3f9041350b661c74c6cbe440c8bd6bc4c168a9fd) upgrades ScrollChain to a calldata batch codec, with matching circuits and verifier; or Ethereum adopts post-quantum data availability"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/scroll-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review14 (ScrollChain source, zkvm-prover source, on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/scroll-blob-kzg/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [scroll-plonk-verifier-bn254]
---

## Summary

Scroll batches are posted only as EIP-4844 blobs; ScrollChain records each blob's versioned hash, and the zkVM batch
circuit proves that the blob's KZG commitment opens to the data it executed. With the KZG ceremony trapdoor, a prover
can open a posted commitment to data other than the blob's, so batches finalize while the state they produce cannot be
rebuilt from the published data: users cannot construct withdrawal proofs, and the L1 bridge's ~USD 26.0M (measured
2026-11-17) stays locked. ScrollChain has no calldata fallback today, but it is upgradeable by Scroll's timelocked
owner, so the dependency can be removed without a protocol change: rated MEDIUM (step 4: fix by a contract upgrade).

## Mechanism

- `ScrollChain.commitBatches(version, parentBatchHash, lastBatchHash)` (OnlySequencer) and
  `commitAndFinalizeBatch` (anyone, once enforced mode is on) call `_commitBatchesFromV7`, which reads
  `blobhash(i)` for each blob of the transaction (`_getBlobVersionedHash`), stores it in the batch header
  (`BatchHeaderV7Codec.storeBlobVersionedHash`) and reverts with `ErrorBatchIsEmpty` when the transaction carries
  no blob. Only versions >= 7 are accepted: there is no calldata batch path.
- `finalizeBundlePostEuclidV2` (OnlyProver) hashes the batch (including the versioned hash) into the public input of
  `IRollupVerifier(verifier).verifyBundleProof(...)`.
- Since the EuclidV2 upgrade the KZG opening is no longer done with the 0x0a point-evaluation precompile (last call
  from ScrollChain at block 22,322,936, 2025-04-22); it is checked inside the zkVM batch circuit:
  `scroll-tech/zkvm-prover` `crates/types/batch/src/blob_consistency/openvm.rs` `verify_kzg_proof(z, y, commitment,
  proof)` runs a BLS12-381 pairing check against `KZG_G2_SETUP` (the EIP-4844 ceremony's G2 point) and
  `kzg_to_versioned_hash` binds the commitment to the on-chain versioned hash.
- Pattern PQ-8: the binding of posted data to the proven batch rests on the KZG trusted setup. The proof itself (BN254
  outer wrap) is covered by `scroll-plonk-verifier-bn254`.

## Evidence

- CHECKED (verified source of implementation `0x0a2070…3ba7`, Sourcify, read 2026-11-17): `_commitBatchesFromV7`,
  `_getBlobVersionedHash`, `_finalizeBundlePostEuclidV2`; no call to precompile 0x0a in the file
  ([`notes.md`](#review-notes-scroll-blob-kzg-2026-11-17-review14)).
- CHECKED (precompile trace, `data/agg/alltime_caller.parquet`): ScrollChain called `pointEval` 186,989 times between
  blocks 19,758,372 and 22,322,936; 1,368 of them in the trace year; none after 2025-04-22.
- CHECKED (GitHub `scroll-tech/zkvm-prover` master, read 2026-11-17): in-circuit `verify_kzg_proof` with
  `KZG_G2_SETUP`; INFERRED that the deployed circuit (app commits in the current verifier) is built from this code.
- CHECKED (cast at block 26,431,492): EIP-1967 implementation `0x0a2070…3ba7`, admin ProxyAdmin `0xeb80…d072` whose
  `owner()` is ScrollOwner `0x7985…26a6`; ScrollChain `owner()` = ScrollOwner; ScrollOwner `DEFAULT_ADMIN_ROLE` has
  one member, TimelockController `0x3f90…a9fd` with `getMinDelay()` = 259200 s.
- CHECKED (cast at block 26,431,492 and Blockscout, 2026-11-17): bridge escrow, see below
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/scroll-blob-kzg/escrow.json)).
- CHECKED (Xatu, any function): 2,607 transactions called ScrollChain 2026-10-16 to 2026-11-16; last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/scroll-blob-kzg/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa13baf47…` TransparentUpgradeableProxy → ScrollChain | yes (ScrollOwner, 3-day timelock) | USD 26.0M (2026-11-17) | 2026-11-15 | 2,607 |

ScrollChain holds nothing itself. The funds whose withdrawal depends on reconstructible L2 state sit in the L1 bridge
(routing read from L1GatewayRouter `0xf8b1…1fd6`): L1ScrollMessenger `0x6774bcbd…b367` (9,539.6 ETH, USD 17.31M),
L1StandardERC20Gateway `0xd8a791fe…f8f9` (USD 4.43M, mostly USDT), L1USDCGateway `0xf1af3b23…5c7b` (USD 3.91M),
wstETH gateway `0x6625c633…f504` (USD 0.30M), DAI gateway `0x67260a8b…f515` (USD 56k); total USD 26.0M, a lower bound.

Who can exploit it: committing a batch needs the sequencer role or enforced mode, and finalizing needs a valid bundle
proof. A forged opening changes which data the proof is about, not the validity rules of the L2: transactions in the
substituted data must still be valid L2 transactions, so the gain is data withholding (funds-locked), not theft. Theft
through a forged proof is the sibling finding `scroll-plonk-verifier-bn254`.

## Remediation

- No fallback exists in the current code: ScrollChain accepts blob batches only (`ErrorBatchIsEmpty` without a
  blob). Scroll ran calldata batches before EIP-4844 (batch version 0; `BatchHeaderV0Codec` is still decoded in
  `_loadBatchHeader`), so ScrollOwner
  `0x7985…26a6` can upgrade ScrollChain through ProxyAdmin `0xeb80…d072` (3-day timelock `0x3f90…a9fd`) to a calldata
  codec, with batch circuits and a verifier that hash the calldata instead of opening a KZG commitment. That removes
  the KZG dependency at higher data cost and needs no protocol change.
- A post-quantum data-availability scheme in Ethereum would let Scroll keep blobs (protocol change helps).
- Users cannot act on this themselves beyond withdrawing to L1.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review14): mechanism corrected: ScrollChain stopped calling the 0x0a precompile on 2025-04-22 (EuclidV2); the KZG opening is now checked in the zkVM batch circuit. Impact funds-loss -> funds-locked (a forged opening only hides the executed data); escrow measured at USD 26.0M.
- 2026-11-17 review (Review14): HIGH -> MEDIUM, step 4: no calldata fallback in the current ScrollChain, but its timelocked admin can upgrade it to calldata batches without a protocol change (rubric revision for PQ-8 fallbacks).

# Source excerpts: scroll-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xa13baf47339d63b743e7da8741db5456dac1e556` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x0a20703878e68e587c59204cc0ea86098b8c3ba7` — ScrollChain (verified source via sourcify)

# Review notes: scroll-blob-kzg (2026-11-17, Review14)

## ScrollChain implementation `0x0a20703878e68e587c59204cc0ea86098b8c3ba7` (Sourcify, `src/L1/rollup/ScrollChain.sol`)

- `commitBatches(uint8 version, bytes32 parentBatchHash, bytes32 lastBatchHash)` — `OnlySequencer whenNotPaused
  whenEnforcedBatchNotEnabled` → `_commitBatchesFromV7(version, parentBatchHash, lastBatchHash, false)`.
- `commitAndFinalizeBatch(uint8 version, bytes32 parentBatchHash, FinalizeStruct)` — `OnlyTopLevelCall`, usable by
  anyone once enforced mode is triggered (message-queue or finalization delay from `SystemConfig.enforcedBatchParameters`).
- `_commitBatchesFromV7`: rejects pre-V7 versions (`ErrorIncorrectBatchVersion`), then for each blob
  `_getBlobVersionedHash(i)` (`blobhash(index)`); `if (blobVersionedHash == bytes32(0)) { if (i == 0) revert
  ErrorBatchIsEmpty(); break; }`; `BatchHeaderV7Codec.storeBlobVersionedHash(batchPtr, blobVersionedHash)`.
- `_finalizeBundlePostEuclidV2`: public inputs = `layer2ChainId, messageQueueHash, numBatches, prevStateRoot,
  prevBatchHash, postStateRoot, batchHash, withdrawRoot`; `IRollupVerifier(verifier).verifyBundleProof(version,
  batchIndex, aggrProof, publicInputs)`.
- No `staticcall` to address 0x0a anywhere in the file. `_loadBatchHeader` still decodes versions 0 (calldata era),
  1–2, 3–6 and 7+.

## Trace

`data/agg/alltime_caller.parquet`: `pointEval` caller `0xa13baf47…`: 186,989 calls, blocks 19,758,372–22,322,936
(last call 2025-04-22, the EuclidV2 switch). `y1_caller`: 1,368 calls, blocks 22,100,124–22,322,936.

## In-circuit KZG check

`github.com/scroll-tech/zkvm-prover` (master, read 2026-11-17), `crates/types/batch/src/blob_consistency/openvm.rs`:
`verify_kzg_proof(z, y, commitment, proof)` builds `x_minus_z = msm([z], G2_GENERATOR) - KZG_G2_SETUP` and runs
`Bls12_381::pairing_check`; `kzg_to_versioned_hash` = `0x01 || sha256(commitment)[1..]`. `KZG_G2_SETUP_BYTES` is the
EIP-4844 ceremony's `[tau]G2`.

## Admin (cast, block 26,431,492)

- EIP-1967 implementation slot: `0x0a2070…3ba7`; admin slot: `0xeb803eb3f501998126bf37bb823646ed3d59d072`.
- ProxyAdmin `owner()` = ScrollChain `owner()` = `0x798576400f7d662961ba15c6b3f3d813447a26a6` (Blockscout name
  `ScrollOwner`).
- ScrollOwner `getRoleMemberCount(0x00)` = 1; member `0x3f9041350b661c74c6cbe440c8bd6bc4c168a9fd`,
  `getMinDelay()` = 259200.

Escrow reads: `escrow.json` (same reads as `evidence/scroll-plonk-verifier-bn254/escrow.json`).
