---
id: fflonkverifier-0775e113-fflonk-verifier
format: 2
title: Polygon fflonk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 pairing setup breaks under a CRQC; MEDIUM since Polygon's timelock can repoint the chains to
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  name: FflonkVerifier
  project: polygon
  code: verified
  code_url: https://etherscan.io/address/0x0775e11309d75aa6b0967917fb0213c5673edf81#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a rollup type with a hash-based verifier, move the chains on it with updateRollup, and obsolete types
  3 and 4.
evidence_level: source
checks:
- id: c1
  source: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 162
  has: function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool)
    {
  says: verifyProof takes a 24-word proof and one public signal.
  for:
  - action
  - evidence-1
  - what
- id: c3
  source: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1090
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: Scalar multiplication on BN254 via precompile 7.
  for:
  - evidence-3
  - what
- id: c4
  source: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1100
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: Point addition on BN254 via precompile 6.
  for:
  - evidence-3
- id: c7
  source: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1199
  has: let success := staticcall(sub(gas(), 2000), 8, mIn, 384, mIn, 0x20)
  says: Final check calls the BN254 pairing precompile 8.
  for:
  - evidence-2
  - justification
  - what
- id: c8
  source: '0x0775e11309d75aa6b0967917fb0213c5673edf81'
  file: contracts/verifiers/FflonkVerifier.sol
  has: let isValid := checkPairing(pMem)
  line: 1238
  says: verifyProof's result comes from the pairing check.
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (AgglayerManager and AgglayerBridge source, rollup registry and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies fflonk proofs for Agglayer chains with BN254 point operations and a final pairing check. With the setup trapdoor, a quantum attacker could forge a proof this verifier accepts and finalize a false exit root against the shared bridge.

## Evidence

- [verifyProof](https://etherscan.io/address/0x0775e11309d75aa6b0967917fb0213c5673edf81#code) returns the result of the pairing check over the proof and public signal.
- [checkPairing](https://etherscan.io/address/0x0775e11309d75aa6b0967917fb0213c5673edf81#code) calls the BN254 pairing precompile at address 8.
- [g1_mulAcc](https://etherscan.io/address/0x0775e11309d75aa6b0967917fb0213c5673edf81#code) uses the BN254 scalar-multiply and add precompiles.

## Reviewer notes

### Mechanism

AgglayerManager.verifyBatchesTrustedAggregator -> _verifyAndRewardBatches calls IVerifierRollup(rollup.verifier).verifyProof(proof,[inputSnark]); for rollup types 3/4 that is this contract. verifyProof (line 162) runs checkInput, computeChallenges, inversions, Lagrange, PI, R0-R2, computeFEJ (lines 1134-1161, ecmul/ecadd via precompiles 7/6 at lines 1090, 1100, 1116, 1126), then checkPairing (lines 1164-1202) calls precompile 8 at line 1199 and returns isValid (line 1238). Knowing the KZG setup trapdoor (recoverable with a CRQC via discrete log on BN254) lets an attacker craft commitments passing the pairing for an arbitrary public input, setting a false local exit root that AgglayerBridge claimAsset/claimMessage trust. Submitting also needs the trusted aggregator role, whose ECDSA key a CRQC also recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: Contract is not upgradeable; fix is repointing rollups in AgglayerManager.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
