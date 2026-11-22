---
id: bscverifier1-6a928066-zkbridge-groth16
format: 2
title: Retired Polyhedra BSC Groth16 verifier accepts quantum-forgeable proofs
status: confirmed
severity: MEDIUM
justification: Soundness rests on a BN254 trapdoor; MEDIUM since Polyhedra's Safe can switch updaters to post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6a9280663511928342ca8d809d8553ae437a0706'
  name: BscVerifier1
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0x6a9280663511928342ca8d809d8553ae437a0706#code
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
- id: c4
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 132
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Pairing check uses the BN254 pairing precompile 8.
  for:
  - evidence-3
  - justification
  - what
- id: c5
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 166
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is hard-coded in the contract.
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 167
  has: vk.alfa1 = Pairing.G1Point(
  says: alfa1 setup point is fixed in the key.
  for:
  - evidence-2
  - what
- id: c7
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 171
  has: vk.beta2 = Pairing.G2Point(
  says: beta2 setup point is fixed in the key.
  for:
  - evidence-2
- id: c8
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  line: 181
  has: vk.gamma2 = Pairing.G2Point(
  says: gamma2 setup point is fixed in the key.
  for:
  - evidence-2
- id: vp
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  has: function verifyProof(
  line: 215
  says: Public Groth16 verification entry point.
  for:
  - what
- id: pair
  source: '0x6a9280663511928342ca8d809d8553ae437a0706'
  file: contracts/block/bsc/BscVerifier1.sol
  has: Pairing.pairing(Pairing.negate(proof.A), proof.B, vk.alfa1, vk.beta2, vk_x, vk.gamma2, proof.C, vk.delta2);
  line: 253
  says: Acceptance is the Groth16 pairing equation against the hard-coded key.
  for:
  - evidence-1
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

This contract checks Groth16 proofs for one public input against a hard-coded BN254 verifying key using the pairing precompile. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false statement.

## Evidence

- [verifyProof](https://etherscan.io/address/0x6a9280663511928342ca8d809d8553ae437a0706#code) returns the result of a pairing check of the proof against the verifying key.
- [verifyingKey](https://etherscan.io/address/0x6a9280663511928342ca8d809d8553ae437a0706#code) hard-codes the BN254 points alfa1, beta2 and gamma2 from the trusted setup.
- [pairing](https://etherscan.io/address/0x6a9280663511928342ca8d809d8553ae437a0706#code) calls the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 215) range-checks the proof points and the single public input. It builds vk_x = IC[0] + input*IC[1] with scalar_mul (precompile 7, line 87) and plus (precompile 6, line 63). It then returns Pairing.pairing(-A, B, alfa1, beta2, vk_x, gamma2, C, delta2) (line 253), which uses precompile 8 (line 132). The verifying key is hard-coded in verifyingKey() (lines 166-209). Anyone who knows the setup trapdoor (tau, alpha, beta, delta), which discrete logs of these points reveal to a quantum attacker, can build A, B and C for any input. Kev lists this address as a retired BscVerifier1 that is in no updater slot he read. A forged proof here reaches the zkBridge endpoint or the DVN only if an updater is pointed back at it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read.
- Ruled out: Holds no funds.
- Ruled out: Not in any updater verifier slot kev read (retired).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
