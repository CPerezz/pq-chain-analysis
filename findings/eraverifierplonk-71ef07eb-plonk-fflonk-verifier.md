---
id: eraverifierplonk-71ef07eb-plonk-fflonk-verifier
format: 2
title: ZKsync EraVerifierPlonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proof check breaks with the setup trapdoor; ZKsync governance can repoint chains to
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  name: EraVerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with an on-chain STARK/FRI verifier and repoint chains to it via a protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used for point multiplication.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used for point addition.
  for:
  - evidence-2
  - what
- id: c5
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul in pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c6
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd in pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c7
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: Final check is a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is the PLONK leg of a ZK Stack DualVerifier and accepts a batch proof only if a BN254 pairing check passes. A quantum attacker who recovers the setup trapdoor can make false batch proofs pass this check, opening withdrawals that never happened.

## Evidence

- [finalPairing](https://etherscan.io/address/0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001#code) calls the BN254 pairing precompile and reverts unless it returns true.
- [Point helpers](https://etherscan.io/address/0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001#code) build the pairing inputs with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The DualVerifier routes proof type 1 to this immutable PLONK_VERIFIER. Its verification runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703). Commitments are combined with ecMul/ecAdd precompiles (pointMulIntoDest line 394, pointAddIntoDest line 405, pointMulAndAddIntoDest lines 437/441), and finalPairing calls precompile 8 at line 1673, reverting on failure (1674-1679) and returning true otherwise (1705-1706). Soundness rests on the KZG setup over BN254; with the trapdoor (discrete log recoverable by a quantum computer) a forged proof satisfies the pairing. The verified batch's L2->L1 logs then authorise withdrawals from the shared L1NativeTokenVault for chains whose DualVerifier uses this leg.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
