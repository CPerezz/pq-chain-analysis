---
id: eraverifierplonk-0daab2b7-plonk-fflonk-verifier
format: 2
title: ZKsync EraVerifierPlonk accepts BN254 PLONK proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Pairing-based PLONK breaks with the setup trapdoor; ZKsync governance can repoint chains to a new
  verifier, so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  name: EraVerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x0daab2b7b38ab48712996e760152c569fa356dbf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 11973
impact: funds-loss
action: Repoint chains to a verifier that checks the hash-based STARK proof on-chain instead of the BN254 PLONK
  wrapper.
evidence_level: source
checks:
- id: c1
  source: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile call in pointMulIntoDest.
  for:
  - what
- id: c2
  source: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile call in pointAddIntoDest.
  for:
  - what
- id: c5
  source: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul precompile call in pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c6
  source: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd precompile call in pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c7
  source: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: BN254 pairing precompile call in finalPairing.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x0daab2b7b38ab48712996e760152c569fa356dbf'
  is: contract
  bytes: 17228
  says: Address holds deployed verifier code.
  for:
  - justification
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

This contract is the PLONK leg of a ZK Stack DualVerifier and accepts a batch proof if a BN254 pairing check passes. With the setup trapdoor, a quantum attacker can build a false proof that passes this check and so get a forged batch accepted.

## Evidence

- [finalPairing](https://etherscan.io/address/0x0daab2b7b38ab48712996e760152c569fa356dbf#code) calls the BN254 pairing precompile (address 8) and reverts unless it returns true.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0x0daab2b7b38ab48712996e760152c569fa356dbf#code) builds the pairing inputs with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verifier's main assembly block runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703), then returns true (1705-1706). Point operations use precompiles 7 (ecMul, line 394, 437) and 6 (ecAdd, lines 405, 416, 427, 441). finalPairing (lines 1657-1679) places the aggregated points with the G2 verification-key elements and calls precompile 8 (line 1673), reverting on failure. Soundness depends on the KZG/BN254 trusted setup; anyone holding the trapdoor (recoverable by a quantum computer) can satisfy the pairing for false public inputs. Per kev, this leg sits behind DualVerifier 0xcef0218c… (chains 388, 325, 1345), and verified batches authorise withdrawals from the shared L1NativeTokenVault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin or proxy slots.
- Ruled out: Holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
