---
id: verifier-23369a60-zktrueup-groth16-verifier
format: 2
title: zkTrue-up rollup trusts a Groth16 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a recovered setup trapdoor; Term Structure's Safe can repoint the rollup
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  name: Verifier
  project: term-structure
  code: verified
  code_url: https://etherscan.io/address/0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Point the rollup diamond at a hash-based (STARK/FRI) verifier and replace the evacuation verifier if the
  rollup resumes.
evidence_level: source
checks:
- id: c1
  source: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  file: contracts/zkTrueUp/verifier/Verifier.sol
  line: 62
  has: function verifyProof(
  says: verifyProof is the public proof-checking entry point.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  file: contracts/zkTrueUp/verifier/Verifier.sol
  line: 155
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: The proof is accepted through the BN254 pairing precompile.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  file: contracts/zkTrueUp/verifier/Verifier.sol
  line: 85
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: The public-input term uses the BN254 ecmul precompile.
  for:
  - evidence-3
  - what
- id: c4
  source: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  file: contracts/zkTrueUp/verifier/Verifier.sol
  line: 95
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: The public-input term uses the BN254 ecadd precompile.
  for:
  - evidence-3
- id: vk
  source: '0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce'
  file: contracts/zkTrueUp/verifier/Verifier.sol
  has: uint256 constant deltax1 =
  line: 45
  says: The trusted-setup delta point is hard-coded in the verification key.
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
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs for zkTrue-up rollup blocks with a pairing check on BN254 against a fixed verification key. A quantum attacker who recovers the setup trapdoor can make proofs of false states that this check accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce#code) returns the result of a BN254 pairing check through precompile 8.
- [The verification key](https://etherscan.io/address/0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce#code) is embedded as constants, including the delta point from the trusted setup.
- [g1_mulAccC](https://etherscan.io/address/0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce#code) builds the public-input term with the ecmul and ecadd precompiles.

## Reviewer notes

### Mechanism

verifyProof (line 62) runs checkField on the single public signal (line 164), then checkPairing (line 167). checkPairing computes vk_x = IC0 + IC1*pubSignals[0] via g1_mulAccC (ecmul precompile 7 at line 85, ecadd precompile 6 at line 95), negates A, and calls the ecpairing precompile 8 at line 155 with A, B, alpha, beta, vk_x, gamma, C and delta (constants lines 35-54). The result is returned at line 170. Whoever knows the setup toxic waste (recoverable by discrete log with a quantum computer) can produce a valid-looking proof for any public input. Kev's finding: the ZkTrueUp diamond calls this verifier from verifyBlocks; executed blocks allow withdrawals, so a forged state could release the rollup's tokens. Block submission requires the committer role, and Term Structure's 4-of-6 Safe can swap the verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier has no owner or storage; it cannot be upgraded itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
