---
id: l1verifierplonk-8f870cf6-zk-verifiers
format: 2
title: Retired ADI Chain verifier trusts a BN254 setup a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum attacker with the setup trapdoor; ADI governance can swap
  verifiers, so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  name: L1VerifierPlonk
  project: adi-chain
  code: verified
  code_url: https://etherscan.io/address/0x8f870cf6621aeaf6026dffc77f484fdab370c4ba#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep this verifier unregistered and register a post-quantum verifier of the ZKsync OS proof in place of
  the BN254 legs.
evidence_level: source
checks:
- id: c1
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used for point multiplication.
  for:
  - evidence-2
  - justification
- id: c2
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used for point addition.
  for:
  - evidence-2
- id: c5
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul inside pointMulAndAddIntoDest.
  for:
  - evidence-2
  - what
- id: c6
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd inside pointMulAndAddIntoDest.
  for:
  - evidence-2
  - what
- id: c7
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: BN254 pairing precompile call decides the proof.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair-fail
  source: '0x8f870cf6621aeaf6026dffc77f484fdab370c4ba'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  has: 'revertWithMessage(29, "finalPairing: pairing failure")'
  line: 1678
  says: The proof is rejected when the pairing result is false.
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This retired ADI Chain verifier accepts a batch proof when a BN254 pairing check passes. A quantum attacker who recovers the setup trapdoor can build proofs of false batches that pass this check.

## Evidence

- [finalPairing](https://etherscan.io/address/0x8f870cf6621aeaf6026dffc77f484fdab370c4ba#code) calls the BN254 pairing precompile (0x08) and reverts unless it returns true.
- [Point helpers](https://etherscan.io/address/0x8f870cf6621aeaf6026dffc77f484fdab370c4ba#code) aggregate commitments with the ecMul (0x07) and ecAdd (0x06) precompiles.

## Reviewer notes

### Mechanism

The verifier body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703), then returns true (1705-1706). Commitments are combined with ecMul/ecAdd via pointMulIntoDest (394), pointAddIntoDest (405), pointSubAssign (416), pointAddAssign (427) and pointMulAndAddIntoDest (437, 441). finalPairing calls precompile 8 at line 1673 against fixed G2 elements and reverts on failure (1677-1678). Soundness rests on the BN254 KZG setup; the trapdoor, derivable with a quantum computer, lets an attacker forge passing proofs. The contract is retired (no calls in the window); a router that registered it would accept forged batches.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; holds no funds itself.
- Ruled out: No calls in the study's 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
