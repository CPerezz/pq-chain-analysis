---
id: rhinofi-starkex-dac-signers
title: "rhino.fi (ex-DeversiFi) StarkEx data availability committee: availability attestations are ECDSA signatures, but the exchange it serves has been retired and emptied"
project: rhino-fi
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x28780349a33eee56bb92241baab8095449e24306"
  implementation: null
  name: Committee (StarkWare_Committee_2019_1)
  upgradeable: "no"
  admin: members and threshold fixed at deployment, no admin; consumer StarkExchange 0x5d22045daceab03b158031ecb7d9d06fad24609b governance can register another availability verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-03-05
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: rhino.fi, as governor of 0x5d22045daceab03b158031ecb7d9d06fad24609b (RhinofiAdminMultisig 0xcca5de1e10c05c50c51ac551d9182cd31aca1889); nothing is needed
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431780
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rhinofi-starkex-dac-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rhinofi-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of rhino.fi (ex-DeversiFi)'s StarkEx exchange `0x5d22045d…`: each state update needs 4 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so a forged quorum (with the operator key) could only let through a state whose data is withheld, locking users out of the escape hatch. The exchange is deprecated: its implementation was replaced by `ConstantRetrieverRestricted`, and L2BEAT reports the admin multisig withdrew all funds; it holds $0. Rated LOW (step 1: no committee activity since 2025-03-05 and the exchange holds nothing).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](#source-excerpts-rhinofi-starkex-dac-signers)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0x8a6c80aa…`, which submits the committee calls); both are ECDSA keys with public signatures.
- The 2019 `Committee` has no admin functions: members and threshold are fixed at deployment.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x28780349…` as above; `identify()` returns the version string in [`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rhinofi-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 4; `isMember(0x0)` false; exchange `0x5d22045d…`: implementation `0x57998f22…` (ConstantRetrieverRestricted); isFrozen() false; StarkEx getters revert (implementation replaced); proxy governor RhinofiAdminMultisig 0xcca5de1e10c05c50c51ac551d9182cd31aca1889 (4 of 6; proxyIsGovernor true).
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0x8a6c80aa…`, the last on 2025-03-05; the exchange holds 0.000 ETH ($0 at $1,814.71) and $0 of priced ERC-20 tokens (no priced holdings); NFTs: none listed.
- CHECKED (precompile trace): 0 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- CHECKED (external, L2BEAT): DAC threshold 4/7.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x28780349…` Committee | no | $0 (StarkExchange `0x5d22045d…`) | 2025-03-05 | 0 |

- Escrow: StarkExchange `0x5d22045daceab03b158031ecb7d9d06fad24609b`, $0 on 2026-11-17 (ETH $0 plus priced tokens $0; no priced holdings). The committee cannot move or lock it in the exchange's current state, so `value_usd` is left null.
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- Nothing is needed while the exchange stays in this state. If state updates resume, the governor should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated LOW (step 1: no committee activity since 2025-03-05 and the exchange holds nothing).

# Source excerpts: rhinofi-starkex-dac-signers

Committee `0x28780349a33eee56bb92241baab8095449e24306` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x28780349a33eee56bb92241baab8095449e24306)

```solidity
   63      function verifyAvailabilityProof(
   64          bytes32 claimHash,
   65          bytes calldata availabilityProofs
   66      )
   67          external
   68      {
   69          require(
   70              availabilityProofs.length >= signaturesRequired * SIGNATURE_LENGTH,
   71              "INVALID_AVAILABILITY_PROOF_LENGTH");
   72  
   73          uint256 offset = 0;
   74          address prevRecoveredAddress = address(0);
   75          for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
   76              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   77              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   78              uint8 v = uint8(availabilityProofs[offset + 64]);
   79              offset += SIGNATURE_LENGTH;
   80              address recovered = ecrecover(
   81                  claimHash,
   82                  v,
   83                  r,
   84                  s
   85              );
   86              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   87              // check on-chain.
   88              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   89              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
   90              prevRecoveredAddress = recovered;
   91          }
   92          registerFact(claimHash);
   93      }
   94  
   95      function bytesToBytes32(bytes memory array, uint256 offset)
   96          private pure
```

