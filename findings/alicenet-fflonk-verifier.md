---
id: alicenet-fflonk-verifier
title: "AliceNet validium (Polygon CDK): its fflonk BN254 verifiers (live 0xf2f73b87, retired 0x0c166845) would accept forged state proofs, but the bridge they secure holds $0"
project: alicenet
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26"
  implementation: null
  name: FflonkVerifier
  upgradeable: "no"
  admin: "none on the verifier; consumer rollup manager 0x8da537b4806962951de147880f15d87e9a761a7d (rollup type 1) is administered by PolygonZkEVMTimelock 0xec607225abc934ba2c1f887ae6b5805003a207df (1 h delay)"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-01-07
  txs_30d: 0
- address: "0xf2f73b87e97730dca6558dd71c0b1c945ca38096"
  implementation: null
  name: FflonkVerifier_12 (live verifier of rollup 1)
  upgradeable: "no"
  admin: "none on the verifier; consumer rollup manager 0x8da537b4806962951de147880f15d87e9a761a7d (rollup type 2, rollup 1) is administered by PolygonZkEVMTimelock 0xec607225abc934ba2c1f887ae6b5805003a207df (1 h delay)"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 23
families: []
fix:
  layer: onchain-config
  who_acts: "AliceNet: timelock 0xec607225abc934ba2c1f887ae6b5805003a207df adds a rollup type with a hash-based verifier on rollup manager 0x8da537b4806962951de147880f15d87e9a761a7d and updates rollup 0x3072b4227656d5e9770d35713d10549d202b9749 to it"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/alicenet-fflonk-verifier
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
  who: Review17 (on-chain reads of the rollup manager, rollup and bridge)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/alicenet-fflonk-verifier/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

AliceNet is a private Polygon CDK validium (network name "Alicenet", chain id 1042) with its own rollup manager and
bridge. Its state proofs are checked by snarkJS fflonk verifiers on BN254: `FflonkVerifier_12` `0xf2f73b87…` for the
live rollup, and `0x0c166845…` for the retired rollup type 1. With the setup trapdoor a quantum attacker could make
the live verifier accept a false state transition, which in a CDK chain lets the bridge pay out on a forged exit
root; but the AliceNet bridge holds $0. The timelock can switch verifiers, so the fix is MEDIUM (step 4), lowered to
LOW (step 5: under $50k exposed).

## Mechanism

- `FflonkVerifier.verifyProof(bytes32[24] proof, uint256[1] pubSignals)` (`0x0c166845…`, lines 162-1242) and
  `FflonkVerifier_12.verifyProof` (`0xf2f73b87…`, `contracts/verifiers/FflonkVerifier_12.sol` 186-2152) end in
  `checkPairing`, a BN254 pairing check against the fflonk setup (PQ-7).
- In a CDK rollup manager, `verifyBatches…` calls the rollup type's verifier with the hash of the new state and exit
  roots; an accepted proof updates the exit root that the bridge `0xf2ac62e8…` uses for `claimAsset`.
- The verifier is fixed per rollup type. `0x0c166845…` is rollup type 1 (forkID 9), no longer used; rollup 1 uses type
  2 (forkID 12) with `0xf2f73b87…`. Batches are verified with `verifyBatchesTrustedAggregator` by the trusted
  aggregator `0x13b3eb34…`.

## Evidence

- CHECKED (Sourcify source, both verifiers; `FflonkVerifier_12` is an exact match): fflonk BN254 pairing verifiers
  ([`source-excerpts.md`](#source-excerpts-alicenet-fflonk-verifier),
  [`review-notes.md`](#review-reads-alicenet-fflonk-verifier-2026-11-17-review17)).
- CHECKED (on-chain, latest blocks 26,431,551-26,431,725): `rollupTypeMap(1)` verifier = `0x0c166845…`;
  `rollupCount()` = 1 and that rollup's verifier = `0xf2f73b87…`; ProxyAdmin `0xa5050ef4…` owned by
  PolygonZkEVMTimelock `0xec607225…` (1 h delay), which holds the rollup manager's admin roles
  ([`review-notes.md`](#review-reads-alicenet-fflonk-verifier-2026-11-17-review17)).
- CHECKED (2026-11-17): bridge `0xf2ac62e8…` holds 0 ETH, no priced ERC-20 (Blockscout) and 0 ALCB (gas token).
- CHECKED (Blockscout): the verifier, PolygonValidiumEtrog `0x524cf915…` and `FflonkVerifier_12` were all created by
  EOA `0x3dfb4aea…`, which is `admin()` of the "Alicenet" rollup.
- CHECKED (precompile trace): 144 BN254 transactions in the yearly window (`studies/top-callers-classification/results/curated_contracts.csv`); last
  2026-01-07, none 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/alicenet-fflonk-verifier/activity.json)).
- CHECKED (Blockscout, 2026-11-17): the rollup manager received 23 `verifyBatchesTrustedAggregator` transactions
  2026-10-16 to 2026-11-16, last 2026-11-16 (block 26,427,564). INFERRED: each calls `0xf2f73b87…`, the only verifier in
  use, so those are its 30-day transactions; it is not in the precompile-trace or Xatu data of this registry.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf2f73b87…` FflonkVerifier_12 | no (consumer configurable) | $0; escrow $0 (AliceNet bridge) | 2026-11-16 | 23 |
| `0x0c166845…` FflonkVerifier | no (consumer configurable) | $0; escrow $0 (AliceNet bridge) | 2026-01-07 | 0 |

Escrow: AliceNet bridge `0xf2ac62e8ec641c327eabf02a2bbc5bd820c18bd4`, $0 on 2026-11-17, shared by both verifiers (the
same $0 is recorded on each entry).

## Remediation

- AliceNet's timelock `0xec607225…` adds a rollup type with a hash-based (STARK/FRI) verifier and updates rollup 1 to
  it; rollup type 1 can be marked obsolete so `0x0c166845…` cannot be used again.
- The timelock's proposers and the rollup admin `0x3dfb4aea…` are ECDSA accounts (PQ-12) and need post-quantum
  signers too.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment). (Line reconstructed by Review17 from `scripts/15_findings.py` `rate()` after the draft was overwritten.)
- 2026-11-17 review (Review17): MEDIUM -> LOW, step 5: the escrow (AliceNet bridge `0xf2ac62e8…`) holds $0, measured; step 4 stays MEDIUM (the timelock can repoint the verifier). Project identified as AliceNet (rollup `networkName()`); the consumer is a private rollup manager `0x8da537b4…` (rollup type 1, unused since rollup 1 moved to `0xf2f73b87…`), not PolygonValidiumEtrog as drafted; status candidate -> confirmed and evidence bytecode -> source-read (the verifier source is on Sourcify).
- 2026-11-17 review (Review17, follow-up): LOW kept, step 5: the live verifier `FflonkVerifier_12` `0xf2f73b87…` added to `contracts[]`; it secures the same bridge, which holds $0, and step 4 is still MEDIUM (timelock can switch rollup type).
- 2026-11-17 integration: id renamed from `unidentified-0c166845-snark-verifier` (project identified).

# Source excerpts: alicenet-fflonk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26` — FflonkVerifier (verified source via sourcify)

### `contracts/verifiers/FflonkVerifier.sol`

```solidity
  158      
  159      uint16 constant lastMem = 1920;
  160       
  161  
  162      function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool) {
  163          assembly {
  164              // Computes the inverse of an array of values
  165              // See https://vitalik.ca/general/2018/07/21/starks_part_3.html in section where explain fields operations
  166              // To save the inverse to be computed on chain the prover sends the inverse as an evaluation in commits.eval_inv
  ...
 1160                  g1_mulAcc(add(pMem, pJ), pW1, numerator)
 1161              }
 1162  
 1163              // Validate all evaluations with a pairing checking that e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)
 1164              function checkPairing(pMem) -> isOk {
 1165                  let mIn := mload(0x40)
 1166  
 1167                  // First pairing value
 1168                  // Compute -E
  ...
 1234              // Compute full batched polynomial commitment [F]_1, group-encoded batch evaluation [E]_1 and the full difference [J]_1
 1235              computeFEJ(pMem)
 1236  
 1237              // Validate all evaluations
 1238              let isValid := checkPairing(pMem)
 1239  
 1240              mstore(0, isValid)
 1241              return(0, 0x20)
 1242          }
  ...
```

# Review reads: alicenet-fflonk-verifier (2026-11-17, Review17)

Verifier `0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26`: Sourcify-verified `contracts/verifiers/FflonkVerifier.sol`
(snarkJS fflonk on BN254; `verifyProof(bytes32[24], uint256[1])` ends in `checkPairing`). Blockscout: created
2024-08-02 by EOA `0x3dfb4aea2f723a5ee8d8c2a74ff38d8813063f3c`; no other direct transactions.

Consumer, read at latest blocks 26,431,551-26,431,725 (2026-11-17):

- Rollup manager `0x8da537b4806962951de147880f15d87e9a761a7d`: EIP-1967 proxy, implementation `0xe47c3eff…`
  (Sourcify name `PolygonRollupManagerNotUpgraded`), EIP-1967 admin = ProxyAdmin `0xa5050ef49e8a3d6adb0bd55c37b8efb05ff619a9`.
  `rollupTypeCount()` = 2, `rollupCount()` = 1.
  - `rollupTypeMap(1)` = consensus `0x5f360ad3…`, verifier `0x0c166845…` (this finding), forkID 9.
  - `rollupTypeMap(2)` = consensus `0x524cf915…` (PolygonValidiumEtrog), verifier `0xf2f73b87e97730dca6558dd71c0b1c945ca38096`
    (Blockscout name `FflonkVerifier_12`, same deployer), forkID 12.
  - `rollupIDToRollupData(1)`: rollup contract `0x3072b4227656d5e9770d35713d10549d202b9749`, chain id 1042, verifier
    `0xf2f73b87…`, forkID 12. No rollup uses `0x0c166845…` any more.
  - The timelock (below) holds DEFAULT_ADMIN_ROLE, ADD_ROLLUP_TYPE_ROLE and UPDATE_ROLLUP_ROLE.
    TRUSTED_AGGREGATOR_ROLE is held by `0x13b3eb34ff65e7f612e195023c8f68dfee610c57`, which calls
    `verifyBatchesTrustedAggregator` (latest 2026-11-16, Blockscout).
- ProxyAdmin `0xa5050ef4…` `owner()` = `0xec607225abc934ba2c1f887ae6b5805003a207df` (Sourcify:
  `PolygonZkEVMTimelock`, `getMinDelay()` = 3600 s). The deployer EOA is not a proposer or executor; proposers were
  not enumerated.
- Rollup `0x3072b422…`: `networkName()` = "Alicenet", `admin()` = `0x3dfb4aea…`, `trustedSequencer()` =
  `0x48d51a36…`, `dataAvailabilityProtocol()` = `0xbbef2b8f…`, `gasTokenAddress()` = `0xf6299720f0482c8ff96968a667035a5dbfd571cb` (ALCB).
- Bridge `0xf2ac62e8ec641c327eabf02a2bbc5bd820c18bd4` (EIP-1967 proxy, admin = same ProxyAdmin): ETH balance 0;
  Blockscout ERC-20 list empty (remote box, 2026-11-17); ALCB `balanceOf(bridge)` = 0.

## Follow-up: live verifier `0xf2f73b87e97730dca6558dd71c0b1c945ca38096` (2026-11-17)

- Sourcify exact match `contracts/verifiers/FflonkVerifier_12.sol:FflonkVerifier_12`: `verifyProof(bytes32[24],
  uint256[1])` at line 186, `checkPairing` at 2065, `isValid := checkPairing(pMem)` at 2152. Runtime code differs from
  `0x0c166845…` (22,983 vs 13,967 bytes); no constructor admin or setter.
- Blockscout `/addresses/0x8da537b4…/transactions` (remote box): 23 transactions 2026-10-16 to 2026-11-16, last
  `verifyBatchesTrustedAggregator` at block 26,427,564 (2026-11-16) from `0x13b3eb34…` (holds TRUSTED_AGGREGATOR_ROLE).
