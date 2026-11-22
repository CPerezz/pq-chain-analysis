---
id: contract-96b3597f-groth16-verifiers
format: 2
title: Hinkal Groth16 verifier trusts a BN254 setup quantum attackers can break
status: candidate
severity: MEDIUM
justification: BN254 Groth16 proofs are forgeable with a recovered trapdoor; Hinkal owners must register post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546'
  project: hinkal
  code: decompiled
  code_url: code/0x2280d9bc05155b3f510d2369896172e2deec9ce8b8233f7c2e532237899420f2.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits and have each pool owner register their verifiers in place of the BN254 ones
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546'
  has: 60076107d05a03fa
  says: Code calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - justification
  - what
- id: b2
  bytecode: '0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546'
  has: 60066107d05a03fa
  says: Code calls the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546'
  has: 60086107d05a03fa
  says: Code calls the BN254 pairing precompile, the Groth16 check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546'
  is: contract
  bytes: 4016
  says: The address holds contract code.
  for:
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

This contract checks Groth16 proofs over BN254 using the elliptic-curve precompiles. A quantum attacker who recovers the circuit's setup trapdoor could make false proofs that pass this check.

## Evidence

- [Runtime code](https://etherscan.io/address/0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546#code) calls the BN254 pairing precompile.
- [Runtime code](https://etherscan.io/address/0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546#code) calls the BN254 addition and multiplication precompiles.

## Reviewer notes

### Mechanism

Hinkal.transact calls VerifierFacade.verifyProof, which resolves verifierMap[buildVerifierId(dimensions, externalActionId)] to a wrapper that forwards to a snarkjs-style Groth16 verifier like this one (29 public inputs per kev). The verifier computes the input linear combination with the BN254 add (0x06) and mul (0x07) precompiles and checks the pairing equation with precompile 0x08. Per kev, this verifier is retired: no registry entry on the three Hinkal pools has reached it since Hinkal re-registered every circuit, but the live replacements are BN254 Groth16 too. Pool owners switch verifiers through onlyOwner registerVerifiers/removeVerifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds and is not a proxy.
- Ruled out: No current pool registry entry reaches this verifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
