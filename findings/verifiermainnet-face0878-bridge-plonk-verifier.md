---
id: verifiermainnet-face0878-bridge-plonk-verifier
format: 2
title: Vara bridge PLONK verifier trusts a BN254 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Forged proofs pass this check; Vara governance must upgrade the bridge queue to a post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  name: VerifierMainnet
  project: vara
  code: verified
  code_url: https://etherscan.io/address/0xface08781c083588ef0569ec1b497aab67b2a18f#code
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
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/VerifierMainnet.sol
  line: 17
  has: try IPlonkVerifier(address(this)).verifyProof(proof, publicInputs) returns (bool success) {
  says: safeVerifyProof forwards to the PLONK verifyProof and returns its result
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 191
  has: function verifyProof(bytes calldata proof, uint256[] calldata publicInputs) public view returns (bool success)
    {
  says: verifyProof is the gnark PLONK verification entry point
  for:
  - evidence-1
  - what
- id: c3
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 850
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: the final success flag comes from the BN254 ecpairing precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 798
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: KZG folding uses BN254 ecmul
  for:
  - evidence-3
  - what
- id: c5
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 1213
  has: let l_success := staticcall(gas(), 6, mPtr, 0x80, dst, 0x40)
  says: point_add uses BN254 ecadd
  for:
  - evidence-3
- id: c7
  source: '0xface08781c083588ef0569ec1b497aab67b2a18f'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 1240
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, dst, 0x40)
  says: point_mul uses BN254 ecmul
  for:
  - evidence-3
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

This contract checks gnark PLONK proofs for the Vara–Ethereum bridge and accepts a proof when its BN254 pairing check passes. A quantum attacker who recovers the setup trapdoor can make it accept proofs of false statements.

## Evidence

- [safeVerifyProof](https://etherscan.io/address/0xface08781c083588ef0569ec1b497aab67b2a18f#code) returns the result of the PLONK verifyProof.
- [check_pairing_kzg](https://etherscan.io/address/0xface08781c083588ef0569ec1b497aab67b2a18f#code) decides success with the BN254 ecpairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0xface08781c083588ef0569ec1b497aab67b2a18f#code) folds the KZG openings with BN254 ecmul and ecadd.

## Reviewer notes

### Mechanism

VerifierMainnet.safeVerifyProof (src/VerifierMainnet.sol line 17) calls PlonkVerifierMainnet.verifyProof (line 191). verifyProof derives Fiat-Shamir challenges, computes the public-input contribution, checks the quotient evaluation, folds commitments (fold_state, batch_verify_multi_points using ecmul at line 798 and point_add/point_mul at lines 1213-1253), and sets success from the KZG pairing in check_pairing_kzg (staticcall to precompile 8, line 850). Soundness rests on the BN254 SRS trapdoor staying unknown. Recovering it with a quantum computer allows proving any statement. In kev's finding, the statement is a Vara Merkle root that MessageQueue would accept before processMessage releases ERC20Manager tokens or mints WVARA. According to kev's finding, this verifier is retired, and the MessageQueue now points at a different verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
