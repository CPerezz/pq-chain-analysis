---
id: blockverifier-e3b7fe3c-groth16-verifier
format: 2
title: DeGate BlockVerifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Forged block proofs release pooled exchange funds; the keys are fixed and need an exchange upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  name: BlockVerifier
  project: degate
  code: verified
  code_url: https://etherscan.io/address/0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6#code
  copies: 1
  upgradeable: 'no'
  admin: '0xacd3a62f3eed1bfe4ff0ec8240d645c1f5477f82'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: source
checks:
- id: c1
  source: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  file: ./contracts/thirdparty/verifiers/Verifier.sol
  line: 60
  has: check_1 = pairing(proof_B, proof_A)
  says: Pairing equation term e(proof_B, proof_A) in the reference Groth16 check.
  for:
  - what
- id: c2
  source: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  file: ./contracts/thirdparty/verifiers/Verifier.sol
  line: 61
  has: check_2 = pairing(vk_beta, neg(vk_alpha))
  says: Pairing term with the verification key's alpha and beta points.
  for:
  - what
- id: c3
  source: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  file: ./contracts/thirdparty/verifiers/Verifier.sol
  line: 62
  has: check_3 = pairing(vk_gamma, neg(vk_x))
  says: Pairing term with vk_x and the gamma key point.
  for:
  - justification
  - what
- id: c4
  source: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  file: ./contracts/thirdparty/verifiers/Verifier.sol
  line: 63
  has: check_4 = pairing(vk_delta, neg(proof_C))
  says: Pairing term with proof_C and the delta key point.
  for:
  - evidence-2
  - justification
  - what
- id: c7
  source: '0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6'
  file: ./contracts/thirdparty/verifiers/Verifier.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, input, 768, out, 0x20)
  says: Verify calls the BN254 pairing precompile 0x08 to accept the proof.
  for:
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
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Groth16 block proofs for DeGate's exchange with a BN254 pairing check against fixed verification keys. An attacker who recovers the setup trapdoor with a quantum computer forges proofs that pass this check, so blocks that move user balances verify.

## Evidence

- [Verify](https://etherscan.io/address/0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6#code) accepts a proof when the BN254 pairing precompile returns true.
- [The pairing equation](https://etherscan.io/address/0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6#code) multiplies e(vk_delta, -proof_C) with the key terms alpha, beta and gamma.

## Reviewer notes

### Mechanism

ExchangeBlocks.submitBlocks requires blockVerifier.verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs). BlockVerifier looks up the circuit's verification key and calls Verifier.Verify or BatchVerifier.BatchVerify. Verify computes vk_x using ECMUL and ECADD (lines 100, 108). It then calls the pairing precompile 0x08 (line 135) on e(A,B)·e(-alpha,beta)·e(-vk_x,gamma)·e(-C,delta). BatchVerify does the same at line 269. Anyone who knows the toxic-waste trapdoor (alpha, beta, gamma, delta exponents), recoverable from the BN254 key points by a quantum discrete-log attack, can construct A, B and C satisfying the equation for arbitrary public inputs. Accepted blocks update balances and authorize withdrawals that the deposit contract pays out. The exchange sets the verifier at genesis and has no function to change it, and it is currently shut down.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself holds no funds.
- Ruled out: No admin function in this contract changes an existing circuit's key to fix the issue.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
