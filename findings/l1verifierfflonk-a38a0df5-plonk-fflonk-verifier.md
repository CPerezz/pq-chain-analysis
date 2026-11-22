---
id: l1verifierfflonk-a38a0df5-plonk-fflonk-verifier
format: 2
title: ZKsync Gateway fflonk verifier trusts a BN254 setup quantum attackers can break
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum attacker; MEDIUM as ZKsync governance can repoint the chain
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xa38a0df579f9eca29fba560b9885b1113b1df442#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Move the Gateway to a verifier that checks the hash-based STARK proof directly, through a ZKsync protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: Scalar multiplication uses the BN254 ecMul precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: Point addition uses the BN254 ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c3
  source: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1541
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: Point subtraction uses the BN254 ecAdd precompile.
  for:
  - evidence-2
- id: c4
  source: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: The final check is a BN254 pairing via precompile 8.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  is: contract
  bytes: 14703
  says: The address holds deployed verifier code.
  for:
  - what
- id: vk-g2
  source: '0xa38a0df579f9eca29fba560b9885b1113b1df442'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  has: mstore(0xc0, VK_G2_ELEMENT_0_X1)
  line: 1562
  says: The pairing uses a fixed G2 element from the verification key.
  for:
  - evidence-1
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

This contract is the fflonk leg that checks batch proofs for the ZKsync Gateway through its DualVerifier. It accepts a proof when a BN254 pairing check against its fixed setup passes, so a quantum attacker with the setup trapdoor could forge proofs of false batches.

## Evidence

- [pairing_check](https://etherscan.io/address/0xa38a0df579f9eca29fba560b9885b1113b1df442#code) calls the BN254 pairing precompile with the proof commitment and fixed G2 setup points.
- [point_mul and point_add](https://etherscan.io/address/0xa38a0df579f9eca29fba560b9885b1113b1df442#code) use the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The ExecutorFacet of the Gateway diamond (chain 9075) calls DualVerifier 0xcd279bd5…, which routes proofs of type 0 to this immutable fflonk leg. The leg builds a Keccak transcript (update_transcript, get_challenge), combines the commitments with point_mul (line 1501, precompile 7), point_add (line 1520) and point_sub (line 1541, precompile 6), and finishes with pairing_check (line 1576, precompile 8) against VK_G2_ELEMENT_0/1. Its soundness rests on the BN254 KZG setup. Someone who recovers the trapdoor can produce passing proofs for false batches. Kev reports the Gateway's escrow as $0 and no recent calls to this leg.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and has no admin.
- Ruled out: The inner Boojum/Airbender STARK is hash-based; only this wrapper is pre-quantum.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
