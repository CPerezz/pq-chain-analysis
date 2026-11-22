---
id: desertverifier-97521058-plonk-verifier
format: 2
title: Lighter DesertVerifier accepts BN254 PLONK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged exit proofs could drain the rollup in desert mode; Lighter can replace it via a gatekeeper-run
  upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x975210588389526a3a1def1628e7a4d7abdfd121'
  name: DesertVerifier
  project: lighter
  code: verified
  code_url: https://etherscan.io/address/0x975210588389526a3a1def1628e7a4d7abdfd121#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace this pairing-based verifier with a hash-based (STARK/FRI) verifier through a ZkLighter upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x975210588389526a3a1def1628e7a4d7abdfd121'
  file: contracts/DesertVerifier.sol
  line: 904
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: check_pairing_kzg calls the BN254 pairing precompile 0x08 to decide the proof.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x975210588389526a3a1def1628e7a4d7abdfd121'
  file: contracts/DesertVerifier.sol
  line: 860
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: KZG folding uses the BN254 scalar-multiplication precompile 0x07.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x975210588389526a3a1def1628e7a4d7abdfd121'
  file: contracts/DesertVerifier.sol
  line: 1269
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, mPtr, 0x40)
  says: point_acc_mul_calldata multiplies proof points on BN254 via precompile 0x07.
  for:
  - evidence-2
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

DesertVerifier is a gnark PLONK verifier on BN254 whose proof check ends in a pairing call to precompile 0x08. With the setup trapdoor, a quantum attacker can build a proof that this check accepts for a false statement.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x975210588389526a3a1def1628e7a4d7abdfd121#code) accepts a proof on the result of a BN254 pairing staticcall to precompile 8.
- [batch_verify_multi_points](https://etherscan.io/address/0x975210588389526a3a1def1628e7a4d7abdfd121#code) folds KZG openings with BN254 scalar multiplication (precompile 7).

## Reviewer notes

### Mechanism

Verify (DesertVerifier.sol line 188, per the finding) runs the gnark PLONK verification. batch_verify_multi_points (lines ~820-895) folds the claimed openings using BN254 EC_MUL/EC_ADD precompiles (line 860; point_acc_mul_calldata line 1269) and assembles the KZG pairing pair with G2 SRS points (lines 884-893). check_pairing_kzg (lines 901-910) does staticcall(gas(), 8, mPtr, 0x180, ...) at line 904 and stores the pairing result as STATE_SUCCESS. Soundness rests on the BN254 SRS trapdoor staying unknown; a quantum attacker who computes it can forge openings that pass. Per kev's finding, ZkLighter stores this verifier in slot 5 and uses it for desert-mode exits, so once desert mode is active, a forged exit proof could claim more than a user's balance from ZkLighter's escrow.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself holds no funds.
- Ruled out: The verifier has never been called.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
