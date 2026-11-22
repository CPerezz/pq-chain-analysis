---
id: verifiermainnet-b7142e82-bridge-plonk-verifier
format: 2
title: Vara bridge verifier accepts PLONK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 KZG setup trapdoor is quantum-recoverable; Vara governance can fix it by upgrading the queue's
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  name: VerifierMainnet
  project: vara
  code: verified
  code_url: https://etherscan.io/address/0xb7142e82ceead0df5d0b3507240a503e99e1881e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 133
impact: funds-loss
action: Upgrade MessageQueue through Vara governance to a post-quantum (hash-based) verifier; halt root submission
  meanwhile.
evidence_level: source
checks:
- id: c1
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/VerifierMainnet.sol
  line: 17
  has: try IPlonkVerifier(address(this)).verifyProof(proof, publicInputs) returns (bool success) {
  says: safeVerifyProof forwards to the PLONK verifyProof.
  for:
  - action
  - evidence-1
  - what
- id: c2
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 193
  has: function verifyProof(bytes calldata proof, uint256[] calldata publicInputs) public view returns (bool success)
    {
  says: verifyProof is the gnark PLONK verifier entry point.
  for:
  - evidence-1
  - what
- id: c3
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 852
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Final KZG check uses the BN254 pairing precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 800
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: KZG folding uses BN254 ecmul on the SRS point.
  for:
  - evidence-3
  - what
- id: c7
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 1242
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, dst, 0x40)
  says: point_mul uses the BN254 ecmul precompile.
  for:
  - justification
- id: c8
  source: '0xb7142e82ceead0df5d0b3507240a503e99e1881e'
  file: src/libraries/PlonkVerifierMainnet.sol
  line: 1255
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, dst, 0x40)
  says: point_mul_calldata uses the BN254 ecmul precompile.
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

This contract checks gnark PLONK proofs for the Vara bridge's MessageQueue using BN254 pairing and curve operations. A quantum attacker who recovers the setup trapdoor can make a proof for a false Vara root that this verifier accepts.

## Evidence

- [safeVerifyProof](https://etherscan.io/address/0xb7142e82ceead0df5d0b3507240a503e99e1881e#code) returns the result of the PLONK verifyProof.
- [check_pairing_kzg](https://etherscan.io/address/0xb7142e82ceead0df5d0b3507240a503e99e1881e#code) decides success with the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0xb7142e82ceead0df5d0b3507240a503e99e1881e#code) folds the KZG openings with BN254 scalar multiplication.

## Reviewer notes

### Mechanism

MessageQueue.submitMerkleRoot packs the block number and Merkle root into public inputs and requires _verifier.safeVerifyProof (this contract). safeVerifyProof (VerifierMainnet.sol line 17) calls PlonkVerifierMainnet.verifyProof (line 193), which derives challenges, checks the quotient, folds commitments with ecmul/ecadd (point_mul line 1242, point_add line 1215, batch_verify_multi_points line 800) and finishes with a KZG pairing check via precompile 8 (check_pairing_kzg line 852) against the fixed G2 SRS points. Whoever knows the SRS trapdoor (recoverable by discrete log with a quantum computer) can forge openings, so a false root is stored and processMessage can deliver forged messages to ERC20Manager (release/mint) or GovernanceAdmin. The verifier itself is not upgradeable; changing it needs a MessageQueue upgrade held by GovernanceAdmin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: Retired verifiers are not in use.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
