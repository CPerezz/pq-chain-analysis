---
id: bscverifier1-cc381170-zkbridge-groth16
format: 2
title: Polyhedra BSC verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 rests on a BN254 setup trapdoor a quantum computer can recover; Polyhedra must deploy post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  name: BscVerifier1
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0xcc381170112c2b831ad1be361ed385cf2e572b12#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: source
checks:
- id: c3
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 102
  has: function pairing(
  says: Pairing check function.
  for:
  - evidence-3
- id: c4
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 132
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Calls BN254 pairing precompile 8.
  for:
  - evidence-3
  - justification
  - what
- id: c5
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 166
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is hard-coded.
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 167
  has: vk.alfa1 = Pairing.G1Point(
  says: alfa1 is a fixed G1 point.
  for:
  - evidence-2
  - what
- id: c7
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 171
  has: vk.beta2 = Pairing.G2Point(
  says: beta2 is a fixed G2 point.
  for:
  - evidence-2
- id: c8
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 181
  has: vk.gamma2 = Pairing.G2Point(
  says: gamma2 is a fixed G2 point.
  for:
  - evidence-2
- id: v-fn
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  has: function verifyProof(
  line: 215
  says: Public Groth16 proof verification entry point.
  for:
  - evidence-1
  - what
- id: v-pair
  source: '0xcc381170112c2b831ad1be361ed385cf2e572b12'
  file: contracts/block/bsc/BscVerifier1.sol
  has: Pairing.pairing(Pairing.negate(proof.A), proof.B, vk.alfa1, vk.beta2, vk_x, vk.gamma2, proof.C, vk.delta2);
  line: 253
  says: The result is the Groth16 pairing equation over the fixed key.
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
  who: Review18 (updater verifier slots, ZKBridge endpoint and ZkBridgeOracleV2 sources, owner reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs for BSC block headers against a hard-coded BN254 verifying key, using the pairing precompile. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false header.

## Evidence

- [verifyProof](https://etherscan.io/address/0xcc381170112c2b831ad1be361ed385cf2e572b12#code) returns the Groth16 pairing check against the fixed key.
- [verifyingKey](https://etherscan.io/address/0xcc381170112c2b831ad1be361ed385cf2e572b12#code) hard-codes alfa1, beta2 and gamma2 as BN254 points.
- [pairing](https://etherscan.io/address/0xcc381170112c2b831ad1be361ed385cf2e572b12#code) calls precompile 8, the BN254 pairing check.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) at line 215 range-checks the proof points, then builds vk_x from IC with scalar_mul (precompile 7, line 87) and plus (precompile 6, line 63). At line 253 it returns pairing(-A,B, alfa1,beta2, vk_x,gamma2, C,delta2), which calls precompile 8 at line 132. The key comes from verifyingKey() at line 166. Soundness depends on the secrecy of the setup trapdoor, which discrete log on BN254 exposes to a quantum attacker. Kev records this address as a retired BscVerifier1: it was in no updater slot he read, and its exposure is none. The live BSC verifier is a different address.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Kev read no updater slot pointing to this address; he lists its exposure as none.
- Ruled out: The contract holds about $0 and has no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
