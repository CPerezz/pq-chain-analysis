# Review notes: scroll-plonk-verifier-bn254 (2026-11-17, Review14)

## Current verifier: OpenVmHalo2Verifier `0x0d2a59fd7060460f07c30c2817b4e79576da01c6`

Verified on Blockscout (`src/v2.0-deferral/OpenVmHalo2Verifier.sol`, solc 0.8.19), created 2026-09-15 (block 25,979,805)
by `0xff78606a67582974bbe3cfc5d5afb56485671cda`. Read from `/api/v2/smart-contracts/0x0d2a…`:

- `OpenVmHalo2Verifier.verify(bytes publicValues, bytes proofData, bytes32 appExeCommit, bytes32 appVmCommit)` checks
  lengths and that both commits are below `BN254_SCALAR_MODULUS`, builds the full proof and self-calls the
  `Halo2Verifier` fallback (`staticcall(gas(), address(), proofPtr, fullProofLength, 0, 0)`); revert on failure.
- `Halo2Verifier.sol` (snark-verifier generated Yul): `ecadd` (0x6) / `ecmul` (0x7) MSMs and, line 2120,
  `success := and(eq(staticcall(gas(), 0x8, 0x64a0, 0x180, 0x64a0, 0x20), 1), success)`: the final BN254 pairing
  check of the KZG (PLONK/SHPLONK) accumulator. `proofData` starts with the 12-limb KZG accumulator.

## Path (block 26,431,492 unless stated)

- `ScrollChain(0xa13b…).finalizeBundlePostEuclidV2` → `_finalizeBundlePostEuclidV2` →
  `IRollupVerifier(verifier).verifyBundleProof(version, batchIndex, aggrProof, publicInputs)`; `verifier` is the
  immutable `0x4cea3e866e7c57fd75cb0ca3e9f5f1151d4ead3f` (MultipleVersionRollupVerifier).
- `MultipleVersionRollupVerifier.getVerifier(version, batchIndex)` returns `latestVerifier[version]` (or a legacy
  entry for older batch indices); `updateVerifier` is `onlyOwner`; `owner()` = ScrollOwner `0x7985…26a6`.
- `latestVerifier` and each wrapper's `plonkVerifier()`: see `escrow.json` (versions 7 and 8 → `0x39854df3…`,
  9 → `0x749fc77a…`, 10 → `0x0d2a59fd…`).
- Verifiers still registered in MultipleVersionRollupVerifier besides version 10: versions 4 (`0x8c1b5275…`),
  6 (`0xd1638c0c…`), 7 and 8 (`0x39854df3…`), 9 (`0x749fc77a…`); `0x7f1a3e12…` is not registered as a latest
  verifier for any version.
- Last finalize at the read: tx `0x19c969ef…` (block 26,431,001, 2026-11-16): ScrollChain → `0x4cea…` →
  ZkEvmVerifierPostFeynman `0xb1541712…` → `0x0d2a59fd…`. Earliest finalize in the window (block 26,208,020) used
  wrapper `0x7966fe0d…` and the same plonk verifier `0x0d2a59fd…`.
- ScrollOwner `DEFAULT_ADMIN_ROLE`: one member, `0x3f9041350b661c74c6cbe440c8bd6bc4c168a9fd`, `getMinDelay()` =
  259200 (3 days). The per-function role that may call `updateVerifier` through ScrollOwner was not read.

## Trace (data/agg/alltime_caller.parquet, to block 24,683,700)

| Verifier | ecpairing calls | first block | last block |
|---|---|---|---|
| `0x8c1b5275…` | 6,846 | 20,662,129 | 22,282,589 (2025-04-16) |
| `0xd1638c0c…` | 195 | 22,287,520 | 22,323,239 (2025-04-22) |
| `0x7f1a3e12…` | 476 | 22,566,395 | 23,098,699 (2025-08-08) |
| `0x39854df3…` | 4,367 | 23,105,047 | 24,023,851 (2025-12-16) |
| `0x749fc77a…` | 3,223 | 24,023,854 | 24,683,566 (2026-03-18); activity.json: last call 2026-06-25 |
| `0x0d2a59fd…` | not in trace (created 2026-09-15) | | |
