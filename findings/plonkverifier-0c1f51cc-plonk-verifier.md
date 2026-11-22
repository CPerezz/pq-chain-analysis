---
id: plonkverifier-0c1f51cc-plonk-verifier
format: 2
title: Rarimo rollup PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A recovered BN254 setup trapdoor forges proofs; Rarimo's admin can unregister this verifier, so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074'
  name: PlonkVerifier
  project: rarimo
  code: verified
  code_url: https://etherscan.io/address/0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Unregister this unused proof type and move to a hash-based verifier.
evidence_level: source
checks:
- id: c1
  source: '0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074'
  file: src/verifiers/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The pairing check calls BN254 precompile 0x08.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074'
  file: src/verifiers/PlonkVerifier.sol
  line: 852
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: The KZG folding uses BN254 scalar multiplication via precompile 0x07.
  for:
  - evidence-2
  - what
- id: code
  code: '0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074'
  is: contract
  bytes: 10624
  says: The address holds contract code.
  for:
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

This gnark PLONK verifier is registered as proof type 0 on Rarimo's rollup and accepts a proof when a BN254 pairing check passes. A quantum attacker who recovers the setup trapdoor can make a proof for any public input pass this check.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074#code) calls the BN254 pairing precompile 0x08 to decide whether a proof is valid.
- [batch_verify_multi_points](https://etherscan.io/address/0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074#code) folds the KZG openings with the G1 SRS point through precompile 0x07.

## Reviewer notes

### Mechanism

Verify ends in batch_verify_multi_points (lines 813-891). This function folds the KZG openings: it multiplies the G1 SRS point by the folded evaluations through precompile 7 (line 852) and uses point_acc_mul_calldata (line 1304). It then calls check_pairing_kzg (line 898). That function runs staticcall to precompile 8 (line 901) with the G2 SRS points and stores the result as STATE_SUCCESS. The soundness of this check rests on the discrete-log hardness of the BN254 SRS trapdoor, which a CRQC breaks. That lets an attacker build a proof for any public input. In kev's finding, LineaRollup.finalizeBlocks accepts proof type 0 (this verifier) as well. A forged finalization would set L2 message roots that release the rollup's bridged ETH.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; the contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
