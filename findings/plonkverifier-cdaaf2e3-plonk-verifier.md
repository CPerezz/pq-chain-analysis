---
id: plonkverifier-cdaaf2e3-plonk-verifier
format: 2
title: Rarimo rollup verifier accepts PLONK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Registered rollup verifier relies on a BN254 KZG setup a CRQC breaks; Rarimo's admin can unset it.
  Small escrow.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcdaaf2e3756409c93635adc3940233640e3004c6'
  name: PlonkVerifier
  project: rarimo
  code: verified
  code_url: https://etherscan.io/address/0xcdaaf2e3756409c93635adc3940233640e3004c6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Remove this verifier's proof type from the rollup with unsetVerifierAddress and use a hash-based verifier
  instead.
evidence_level: source
checks:
- id: c1
  source: '0xcdaaf2e3756409c93635adc3940233640e3004c6'
  file: src/verifiers/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Final verification is a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xcdaaf2e3756409c93635adc3940233640e3004c6'
  file: src/verifiers/PlonkVerifier.sol
  line: 852
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Proof folding uses BN254 scalar multiplication with the G1 setup point.
  for:
  - evidence-2
  - what
- id: g2
  source: '0xcdaaf2e3756409c93635adc3940233640e3004c6'
  file: src/verifiers/PlonkVerifier.sol
  has: mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  line: 887
  says: The pairing input uses the fixed G2 setup point from the trusted setup.
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
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This gnark PLONK verifier accepts a proof when a BN254 pairing check against its setup points succeeds. A quantum attacker who recovers the setup trapdoor can make a proof for any public input pass this check.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0xcdaaf2e3756409c93635adc3940233640e3004c6#code) decides validity with a staticcall to the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0xcdaaf2e3756409c93635adc3940233640e3004c6#code) pairs the folded proof with the fixed G2 setup points.

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines 813-891) folds the proof commitments with EC mul/add precompile calls (line 852, point_acc_mul_calldata line 1304), then loads the G2 SRS points G2_SRS_0 and G2_SRS_1 (lines 881-890) and calls check_pairing_kzg, which staticcalls precompile 8 (line 901) and stores the pairing result as the verification outcome (line 906). Soundness rests on the secrecy of the KZG trapdoor; a CRQC recovering it from the public SRS can open commitments to arbitrary values, so a forged proof for any public input passes. Per the finding, this contract is registered as proof type 2 on Rarimo's LineaRollup, whose finalizeBlocks accepts it and whose stored message roots release bridged ETH.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin on this contract itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
