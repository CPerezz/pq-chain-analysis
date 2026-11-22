---
id: l1verifierplonk-5bafef67-plonk-fflonk-verifier
format: 2
title: ZKsync L1VerifierPlonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proof with a BN254 setup trapdoor; MEDIUM since ZKsync governance can repoint chains
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5bafef6729228add8775af4cecd2e68a51424ee1'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x5bafef6729228add8775af4cecd2e68a51424ee1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with a hash-based STARK/FRI verifier and repoint chains via a protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x5bafef6729228add8775af4cecd2e68a51424ee1'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile call on proof points
  for:
  - evidence-2
  - what
- id: c2
  source: '0x5bafef6729228add8775af4cecd2e68a51424ee1'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile call on proof points
  for:
  - evidence-2
- id: c7
  source: '0x5bafef6729228add8775af4cecd2e68a51424ee1'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: final BN254 pairing precompile call decides acceptance
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

This PLONK verifier is the plonk leg of a ZK Stack DualVerifier and accepts a batch proof when a BN254 pairing check passes. With the setup trapdoor, a quantum attacker could make a false batch proof pass this check, which could authorise fake withdrawals.

## Evidence

- [finalPairing](https://etherscan.io/address/0x5bafef6729228add8775af4cecd2e68a51424ee1#code) accepts the proof when the BN254 pairing precompile returns true.
- [pointMulIntoDest and pointAddIntoDest](https://etherscan.io/address/0x5bafef6729228add8775af4cecd2e68a51424ee1#code) combine proof points with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verifier's main body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703), then returns true. The G1 arithmetic uses the ecMul precompile (7) at lines 394 and 437 and the ecAdd precompile (6) at lines 405, 416, 427 and 441. finalPairing calls the pairing precompile (8) at line 1673 against the fixed G2 setup elements, and it reverts on failure (lines 1674-1679). Someone who knows the BN254 KZG setup trapdoor, which a quantum computer could recover by solving the discrete log, can build openings that satisfy this pairing for false public inputs. The DualVerifier routes type-1 proofs to this leg. In kev's census it is the plonk leg of DualVerifier 0x53f5de9d, which serves chains 9637 and 2904. Verified batches authorise withdrawals from the shared L1NativeTokenVault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read on this contract.
- Ruled out: The contract itself holds about $0.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
