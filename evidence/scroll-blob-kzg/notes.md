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
