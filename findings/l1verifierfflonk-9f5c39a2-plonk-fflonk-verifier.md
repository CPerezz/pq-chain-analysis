---
id: l1verifierfflonk-9f5c39a2-plonk-fflonk-verifier
format: 2
title: ZKsync L1VerifierFflonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based BN254 proof check breaks with the setup trapdoor; MEDIUM as ZKsync governance can repoint
  chains.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9f5c39a2790f38542065e7854b90407371923375'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x9f5c39a2790f38542065e7854b90407371923375#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with a hash-based STARK/FRI verifier and repoint chains through a protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x9f5c39a2790f38542065e7854b90407371923375'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x9f5c39a2790f38542065e7854b90407371923375'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x9f5c39a2790f38542065e7854b90407371923375'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile.
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

This contract is an fflonk leg that checks ZK Stack batch proofs with BN254 elliptic-curve precompiles and a final pairing check. A quantum attacker who recovers the setup trapdoor could make a false proof pass the pairing check.

## Evidence

- [pairing_check](https://etherscan.io/address/0x9f5c39a2790f38542065e7854b90407371923375#code) calls the BN254 pairing precompile (address 8) to accept the proof.
- [point_mul and point_add](https://etherscan.io/address/0x9f5c39a2790f38542065e7854b90407371923375#code) use the BN254 ecMul and ecAdd precompiles (7 and 6).

## Reviewer notes

### Mechanism

The fflonk verifier rebuilds the proof's commitments with point_mul (line 1501, precompile 7), point_add (line 1520, precompile 6) and point_sub (line 1541), then pairing_check (line 1576, precompile 8) pairs the aggregated point and proof commitment 3 against the verification key's G2 elements. Soundness rests on the BN254 KZG setup; anyone holding the trapdoor (recoverable with a quantum computer) can produce commitments that pass. Per kev, this leg sits behind DualVerifier 0x47fc5273 (fflonk, type 0) used by chains 543210 and 320, whose verified batches authorise withdrawals from the shared L1NativeTokenVault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract itself is not upgradeable and holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
