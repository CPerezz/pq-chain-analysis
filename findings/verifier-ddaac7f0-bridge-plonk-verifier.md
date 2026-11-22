---
id: verifier-ddaac7f0-bridge-plonk-verifier
format: 2
title: Vara bridge verifier accepts PLONK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 setup; the fix is a MessageQueue upgrade by Vara governance; this retired
  verifier needs none.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xddaac7f0814368d58d40216c6391a5e40a8cd47e'
  name: Verifier
  project: vara
  code: verified
  code_url: https://etherscan.io/address/0xddaac7f0814368d58d40216c6391a5e40a8cd47e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: source
checks:
- id: c1
  source: '0xddaac7f0814368d58d40216c6391a5e40a8cd47e'
  file: src/Verifier.sol
  line: 17
  has: try IPlonkVerifier(address(this)).verifyProof(proof, publicInputs) returns (bool success) {
  says: safeVerifyProof forwards to the PLONK verifyProof
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xddaac7f0814368d58d40216c6391a5e40a8cd47e'
  file: src/libraries/PlonkVerifier.sol
  line: 191
  has: function verifyProof(bytes calldata proof, uint256[] calldata publicInputs) public view returns (bool success)
    {
  says: verifyProof is the gnark PLONK verifier entry point
  for:
  - evidence-1
  - what
- id: c3
  source: '0xddaac7f0814368d58d40216c6391a5e40a8cd47e'
  file: src/libraries/PlonkVerifier.sol
  line: 850
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: final KZG check uses the BN254 pairing precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xddaac7f0814368d58d40216c6391a5e40a8cd47e'
  file: src/libraries/PlonkVerifier.sol
  line: 798
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: KZG folding uses BN254 scalar multiplication with the setup point
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (MessageQueue source on Blockscout; queue, governance and escrow reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks gnark PLONK proofs for the Vara bridge: safeVerifyProof calls verifyProof, which ends in a BN254 pairing check. A quantum attacker who recovers the setup trapdoor can make a proof of a false statement pass this check.

## Evidence

- [safeVerifyProof](https://etherscan.io/address/0xddaac7f0814368d58d40216c6391a5e40a8cd47e#code) returns the result of the PLONK verifyProof.
- [verifyProof](https://etherscan.io/address/0xddaac7f0814368d58d40216c6391a5e40a8cd47e#code) finishes with a call to the BN254 pairing precompile (address 8) in check_pairing_kzg.
- [batch_verify_multi_points](https://etherscan.io/address/0xddaac7f0814368d58d40216c6391a5e40a8cd47e#code) uses BN254 scalar multiplication (precompile 7) with the setup point.

## Reviewer notes

### Mechanism

Verifier.safeVerifyProof (src/Verifier.sol line 17) calls PlonkVerifier.verifyProof (line 191). That function derives challenges and checks the quotient evaluation. batch_verify_multi_points (line 798) folds the KZG openings using ecmul/ecadd (lines 1213-1253). check_pairing_kzg then calls the ecpairing precompile (line 850) against fixed G2 setup points. Security rests on the KZG setup's discrete-log trapdoor, which a quantum attacker could recover in order to forge proofs. MessageQueue used this verifier to accept Vara Merkle roots. It has since been replaced twice, so this contract is retired and holds nothing.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds.
- Ruled out: Retired: MessageQueue now points at a newer verifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
