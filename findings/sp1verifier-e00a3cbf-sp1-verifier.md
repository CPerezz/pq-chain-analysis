---
id: sp1verifier-e00a3cbf-sp1-verifier
format: 2
title: SP1 Plonk verifier v4.0.0-rc.3 accepts BN254 proofs quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: 'MEDIUM: a BN254 setup trapdoor forges proofs; Succinct can freeze this gateway route and add a hash-based
  verifier.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Freeze this verifier's route in the SP1 Plonk gateway and route proofs to a hash-based STARK verifier.
evidence_level: source
checks:
- id: c1
  source: '0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63'
  file: src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  line: 39
  has: function verifyProof(
  says: verifyProof is the external entry point
  for:
  - what
- id: c4
  source: '0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63'
  file: src/v4.0.0-rc.3/PlonkVerifier.sol
  line: 886
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: KZG check uses the BN254 pairing precompile
  for:
  - evidence-2
  - justification
  - what
- id: c54
  source: '0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63'
  file: src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  has: bool success = this.Verify(proofBytes[4:], inputs);
  line: 54
  says: acceptance depends on Plonk Verify succeeding
  for:
  - evidence-1
  - justification
  - what
- id: c46
  source: '0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63'
  file: src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  has: if (receivedSelector != expectedSelector) {
  line: 46
  says: proof prefix must match this verifier's hash selector
  for:
  - action
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This immutable SP1 verifier accepts a program output when a Plonk proof on BN254 passes a pairing check. A quantum attacker who recovers the setup trapdoor can make a proof of any public values that this verifier accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63#code) reverts unless the Plonk Verify call on the proof succeeds.
- [check_pairing_kzg](https://etherscan.io/address/0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63#code) ends in the BN254 pairing precompile at address 8.
- [verifyProof](https://etherscan.io/address/0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63#code) requires the proof's first 4 bytes to match VERIFIER_HASH.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (SP1VerifierPlonk.sol line 39) checks the proof's 4-byte selector against VERIFIER_HASH (lines 44-48), hashes publicValues with sha256 masked to 253 bits (line 32), builds inputs [programVKey, digest] and calls this.Verify(proofBytes[4:], inputs) (line 54), reverting on failure. PlonkVerifier uses BN254 ecMul (precompile 7, lines 834, 1330, 1346) and the pairing precompile 8 in check_pairing_kzg (line 886). With the KZG setup trapdoor, which a quantum computer can recover through discrete logs, a proof for any vkey and public values passes. The contract is immutable. Per kev, it stays reachable through an open route in Succinct's Plonk gateway, which forwards on a prover-chosen selector.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No upgrade path in this contract
- Ruled out: Holds no funds itself

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
