---
id: fflonkverifier-13-455ac63e-fflonk-verifier
format: 2
title: Polygon FflonkVerifier_13 accepts fflonk proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A BN254 pairing check falls to a setup trapdoor; Polygon's timelock can obsolete the rollup type
  that uses this verifier
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab'
  name: FflonkVerifier_13
  project: polygon
  code: verified
  code_url: https://etherscan.io/address/0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Obsolete the rollup type that uses this verifier and move chains to a type with a hash-based verifier
evidence_level: source
checks:
- id: c1
  source: '0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab'
  file: contracts/verifiers/FflonkVerifier_13.sol
  line: 162
  has: function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool)
    {
  says: verifyProof takes the proof and one public signal and returns bool
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab'
  file: contracts/verifiers/FflonkVerifier_13.sol
  line: 1090
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: ecmul precompile (7) applied to proof points
  for:
  - evidence-3
  - what
- id: c4
  source: '0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab'
  file: contracts/verifiers/FflonkVerifier_13.sol
  line: 1100
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: ecadd precompile (6) accumulates points
  for:
  - evidence-3
- id: c7
  source: '0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab'
  file: contracts/verifiers/FflonkVerifier_13.sol
  line: 1199
  has: let success := staticcall(sub(gas(), 2000), 8, mIn, 384, mIn, 0x20)
  says: BN254 pairing precompile (8) decides validity
  for:
  - action
  - evidence-2
  - justification
  - what
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

This contract verifies fflonk proofs for Polygon Agglayer rollups and accepts a proof when a BN254 pairing check passes. With the fflonk setup trapdoor, a quantum attacker could build a proof that passes for a false state.

## Evidence

- [verifyProof](https://etherscan.io/address/0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab#code) takes a 24-word proof and one public signal and returns a bool.
- [checkPairing](https://etherscan.io/address/0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab#code) calls the BN254 pairing precompile (address 8) and returns its result.
- [g1_mulAcc](https://etherscan.io/address/0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab#code) combines proof points with BN254 ecmul and ecadd precompiles.

## Reviewer notes

### Mechanism

verifyProof (line 162) runs checkInput, computeChallenges, inversions, Lagrange, PI and R0-R2, then computeFEJ (lines 1134-1161) builds [F]_1, [E]_1 and [J]_1 with ecmul/ecadd precompiles (lines 1090, 1100, 1116, 1126). checkPairing (lines 1164-1202) forms F - E - J + y·W2 and calls the pairing precompile at line 1199; the result is returned as validity. Soundness rests on the BN254 KZG setup; anyone holding the trapdoor (recoverable with a CRQC) can make any public input pass. AgglayerManager calls this verifier for rollups of the type that points at it. Per the census, no chain currently uses that type, but the type is not obsoleted.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: The contract is not upgradeable; the fix is repointing at the rollup manager.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
