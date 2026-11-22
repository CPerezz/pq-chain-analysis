---
id: optimisticblockverifier4-00c8972e-zkbridge-groth16
format: 2
title: Polyhedra zkBridge Groth16 header verifier lets a quantum attacker forge proofs
status: confirmed
severity: MEDIUM
justification: Groth16 setup trapdoor falls to a quantum computer; Polyhedra's Safe can repoint updaters to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  name: OptimisticBlockVerifier4
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a hash-based post-quantum header verifier and have the owner Safe point the updaters at it instead
  of this one.
evidence_level: source
checks:
- id: c4
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  line: 132
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Calls the BN254 pairing precompile (address 8).
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  line: 166
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is hard-coded in the contract.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: c6
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  line: 167
  has: vk.alfa1 = Pairing.G1Point(
  says: Hard-coded alfa1 G1 point.
  for:
  - evidence-3
- id: c7
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  line: 171
  has: vk.beta2 = Pairing.G2Point(
  says: Hard-coded beta2 G2 point.
  for:
  - evidence-3
- id: c8
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  line: 181
  has: vk.gamma2 = Pairing.G2Point(
  says: Hard-coded gamma2 G2 point.
  for:
  - evidence-3
- id: vp
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  has: function verifyProof(
  line: 215
  says: Public Groth16 proof verification entry point.
  for:
  - evidence-1
  - what
- id: ret
  source: '0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c'
  file: contracts/block/optimistic/OptimisticBlockVerifier4.sol
  has: Pairing.pairing(Pairing.negate(proof.A), proof.B, vk.alfa1, vk.beta2, vk_x, vk.gamma2, proof.C, vk.delta2)
  line: 253
  says: The result is the Groth16 pairing equation against the fixed key.
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
  who: Review18 (updater verifier slots, ZKBridge endpoint and ZkBridgeOracleV2 sources, owner reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs over BN254 for Polyhedra's zkBridge block headers, using a pairing check against a hard-coded verifying key. A quantum attacker who recovers the setup trapdoor can produce proofs this verifier accepts for false statements.

## Evidence

- [verifyProof](https://etherscan.io/address/0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c#code) returns the result of a BN254 pairing check on the proof.
- [pairing](https://etherscan.io/address/0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c#code) calls the BN254 pairing precompile at address 8.
- [verifyingKey](https://etherscan.io/address/0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c#code) hard-codes the Groth16 key points alfa1, beta2, gamma2 and delta2.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 215) builds vk_x from the hard-coded IC points with scalar_mul (precompile 7, line 87) and plus (precompile 6, line 63), then returns Pairing.pairing(-A, B, alfa1, beta2, vk_x, gamma2, C, delta2) (line 253), which calls precompile 8 (line 132). Soundness rests on the secrecy of the setup trapdoor behind the key in verifyingKey() (lines 166-209); discrete logs in BN254 are recoverable with a quantum computer, letting an attacker craft accepting proofs for any public input. Per kev, OptimisticBlockRouter.importBlock calls blockVerifier[4].verifyProof (this address), so forged Optimism/Arbitrum-type headers would reach the ZKBridge endpoint and the LayerZero zkLightClient DVN.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; the fix is repointing the router's verifier slot.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
