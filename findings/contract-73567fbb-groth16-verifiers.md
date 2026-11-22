---
id: contract-73567fbb-groth16-verifiers
format: 2
title: Hinkal BN254 Groth16 verifier accepts proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 Groth16 falls to a recovered setup trapdoor; the fix is new circuits that pool owners register
  as verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b'
  project: hinkal
  code: decompiled
  code_url: code/0xf6cb455a5e7bd917a7afdd647f5f5c2102610585ea1c7768cffda47779afdee4.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits and have each pool owner register their verifiers in place of BN254 Groth16
  ones.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b'
  has: 60076107d05a03fa
  says: Code calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - justification
  - what
- id: b2
  bytecode: '0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b'
  has: 60066107d05a03fa
  says: Code calls the BN254 addition precompile.
  for:
  - evidence-2
  - justification
  - what
- id: b3
  bytecode: '0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b'
  has: 60086107d05a03fa
  says: Code calls the BN254 pairing precompile.
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is a Groth16 proof verifier for Hinkal that checks proofs with the BN254 curve precompiles. A quantum attacker who recovers the circuit's setup trapdoor can build false proofs that pass its pairing check.

## Evidence

- The [runtime code](https://etherscan.io/address/0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b#code) calls the BN254 pairing precompile to accept or reject a proof.
- The [runtime code](https://etherscan.io/address/0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b#code) calls the BN254 addition and multiplication precompiles to build the pairing inputs.

## Reviewer notes

### Mechanism

Hinkal.transact on a pool calls VerifierFacade.verifyProof, which looks up verifierMap[buildVerifierId(dimensions, externalActionId)] and calls a small wrapper that forwards to a snarkjs-style verifier like this one: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[18]) (calldata length 0x344 matches 18 public inputs). The verifier computes the linear combination of inputs with ecMul/ecAdd (precompiles 0x07/0x06) and checks the pairing equation with precompile 0x08. Pool tokens move only if it returns true. A recovered BN254 setup trapdoor lets an attacker satisfy the equation for false statements. Per kev's review, this verifier is retired: the wrapper pointing to it was used by pool 0x25e5e82f… until 2026-06 and no current verifierMap entry reaches it. The live replacements are still BN254 Groth16. Pool owners can swap verifiers via the onlyOwner registerVerifiers/removeVerifier functions.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; holds no funds itself.
- Ruled out: Not reachable from any current pool registry entry, per kev's review.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
