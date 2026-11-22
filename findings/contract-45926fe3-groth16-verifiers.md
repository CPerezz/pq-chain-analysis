---
id: contract-45926fe3-groth16-verifiers
format: 2
title: 'Retired Hinkal BN254 Groth16 verifier: proofs a quantum attacker could forge'
status: candidate
severity: MEDIUM
justification: BN254 pairing check fails once a setup trapdoor is recovered; fixing it needs new circuits and owner
  re-registration
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3'
  project: hinkal
  code: decompiled
  code_url: code/0x4f2cef82a077bb031af5e9cc854627c6ee17f8b17f688f57ca972aea2e7235e3.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits and have each pool owner register their verifiers with registerVerifiers, removing
  BN254 ones
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3'
  has: 60076107d05a03fa
  says: code calls the BN254 multiplication precompile
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3'
  has: 60066107d05a03fa
  says: code calls the BN254 addition precompile
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3'
  has: 60086107d05a03fa
  says: code calls the BN254 pairing precompile
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel
  selector: '0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3'
  fn: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[4])
  says: the 4-input Groth16 verifyProof selector is in the code
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs for Hinkal with the BN254 addition, multiplication and pairing precompiles. A quantum attacker who recovers the circuit's setup trapdoor can make a false proof pass this check.

## Evidence

- [Runtime code](https://etherscan.io/address/0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3#code) calls the BN254 pairing precompile.
- [Runtime code](https://etherscan.io/address/0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3#code) calls the BN254 addition and multiplication precompiles.
- [Code](https://etherscan.io/address/0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3#code) exposes a Groth16 verifyProof with four public inputs.

## Reviewer notes

### Mechanism

Bytecode-only snarkjs-style verifier: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[4]) (calldata length check 0x184) combines the public inputs with ecMul (precompile 0x07, offset 173) and ecAdd (0x06, offset 221), then calls the pairing precompile 0x08 (offset 1366) and returns the result. Hinkal pool 0x25e5e82f… reached it through a wrapper registered in VerifierFacade.verifierMap inside Hinkal.transact until mid-2026; per kev's review no registry entry points to it now, and the live replacement verifiers are BN254 Groth16 too. Forging a proof with a recovered trapdoor would let transact release pool tokens.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; holds no funds itself.
- Ruled out: No pool registry currently routes to this verifier (kev's review).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
