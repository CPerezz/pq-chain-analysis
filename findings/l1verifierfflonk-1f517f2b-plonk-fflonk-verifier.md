---
id: l1verifierfflonk-1f517f2b-plonk-fflonk-verifier
format: 2
title: ZKsync fflonk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: The proof check rests on BN254 pairings that quantum can break; MEDIUM as ZKsync governance can repoint
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1f517f2bab178add6e282297a4728bcc50e9f6cf'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x1f517f2bab178add6e282297a4728bcc50e9f6cf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 fflonk wrapper with an on-chain STARK/FRI verifier of the underlying proof.
evidence_level: source
checks:
- id: c1
  source: '0x1f517f2bab178add6e282297a4728bcc50e9f6cf'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1483
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x1f517f2bab178add6e282297a4728bcc50e9f6cf'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1502
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x1f517f2bab178add6e282297a4728bcc50e9f6cf'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1558
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

This contract verifies fflonk batch proofs for ZK Stack chains using the BN254 elliptic-curve precompiles and a final pairing check. With the setup trapdoor, a quantum attacker could build a proof of a false batch that passes this pairing check.

## Evidence

- [pairing_check](https://etherscan.io/address/0x1f517f2bab178add6e282297a4728bcc50e9f6cf#code) calls the BN254 pairing precompile against fixed G2 setup elements.
- [point_mul and point_add](https://etherscan.io/address/0x1f517f2bab178add6e282297a4728bcc50e9f6cf#code) use the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

L1VerifierFflonk is a fflonk leg behind a DualVerifier, which the diamond's ExecutorFacet calls when batch proofs are submitted. The verifier's assembly combines commitments with point_mul (staticcall to precompile 7, line 1483), point_add (precompile 6, line 1502) and point_sub (line 1523). It then calls pairing_check (precompile 8, line 1558) with the setup's VK_G2 elements. Knowing the KZG setup trapdoor, which a quantum computer recovers from the public BN254 points, lets an attacker forge openings that pass this check. Per kev, this leg last served ZERO Network and Memento via DualVerifier 0x079004d9 and no registered chain points at it now.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read.
- Ruled out: Holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
