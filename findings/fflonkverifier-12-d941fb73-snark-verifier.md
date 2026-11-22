---
id: fflonkverifier-12-d941fb73-snark-verifier
format: 2
title: CDK validium verifier accepts fflonk proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: 'Proof soundness rests on BN254 pairings; the chain''s timelock can repoint the rollup to a hash-based
  verifier: MEDIUM.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd941fb73ac5bab219915c170f9355ac2f6ac7947'
  name: FflonkVerifier_12
  code: verified
  code_url: https://etherscan.io/address/0xd941fb73ac5bab219915c170f9355ac2f6ac7947#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a rollup type with a hash-based verifier and move rollup 1 to it, or retire the chain.
evidence_level: source
checks:
- id: c1
  source: '0xd941fb73ac5bab219915c170f9355ac2f6ac7947'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 186
  has: function verifyProof(
  says: verifyProof is the public proof-verification entry point.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xd941fb73ac5bab219915c170f9355ac2f6ac7947'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1918
  has: let success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: g1_acc adds BN254 points with precompile 6.
  for:
  - evidence-3
  - what
- id: c3
  source: '0xd941fb73ac5bab219915c170f9355ac2f6ac7947'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1934
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: g1_mulAcc multiplies a BN254 point with precompile 7.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xd941fb73ac5bab219915c170f9355ac2f6ac7947'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1944
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: g1_mulAcc adds BN254 points with precompile 6.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (deployer history, RollupManager and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies fflonk proofs for a standalone Polygon CDK validium's rollup state. It accepts a proof when BN254 curve operations and a final pairing check succeed, so an attacker who recovers the setup trapdoor forges proofs for false state.

## Evidence

- [verifyProof](https://etherscan.io/address/0xd941fb73ac5bab219915c170f9355ac2f6ac7947#code) takes a 24-word proof and one public input.
- [g1_mulAcc](https://etherscan.io/address/0xd941fb73ac5bab219915c170f9355ac2f6ac7947#code) uses the BN254 scalar-multiply and add precompiles.
- [g1_acc](https://etherscan.io/address/0xd941fb73ac5bab219915c170f9355ac2f6ac7947#code) adds BN254 points through precompile 6.

## Reviewer notes

### Mechanism

FflonkVerifier_12.verifyProof (line 186) runs snarkjs fflonk verification in assembly: g1_acc (line 1918), g1_mulAcc (lines 1934, 1944) and g1_mulAccC (lines 1960, 1970) call precompiles 7 and 6. computeFEJ then builds [F], [E] and [J]. checkPairing returns the result of a BN254 ecpairing against the fflonk SRS, and verifyProof returns that result (lines 2149-2155). Per kev, the chain's RollupManager calls verifyProof when it verifies batches; the verified state sets the local exit root that the chain's bridge honours for claims. Knowing the SRS trapdoor lets an attacker forge an accepting proof.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not used by Polygon's shared Agglayer RollupManager (per kev).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
