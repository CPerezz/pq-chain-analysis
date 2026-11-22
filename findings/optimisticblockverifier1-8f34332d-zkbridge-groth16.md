---
id: optimisticblockverifier1-8f34332d-zkbridge-groth16
format: 2
title: Polyhedra zkBridge verifier accepts Groth16 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: A recovered Groth16 trapdoor forges optimistic-chain headers; Polyhedra's Safe can repoint the router
  to a PQ verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  name: OptimisticBlockVerifier1
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0x8f34332dec0c624c3ccf3733d0998d5aee92800f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a hash-based post-quantum block verifier and have the Safe repoint the router's blockVerifier slot
  to it.
evidence_level: source
checks:
- id: c4
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  line: 132
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Calls the BN254 ecpairing precompile.
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  line: 166
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is hard-coded in the contract.
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  line: 167
  has: vk.alfa1 = Pairing.G1Point(
  says: Hard-coded alpha point.
  for:
  - evidence-2
- id: c7
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  line: 171
  has: vk.beta2 = Pairing.G2Point(
  says: Hard-coded beta point.
  for:
  - evidence-2
- id: c8
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  line: 181
  has: vk.gamma2 = Pairing.G2Point(
  says: Hard-coded gamma point.
  for:
  - evidence-2
- id: vp
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  has: function verifyProof(
  line: 215
  says: Public Groth16 proof verification entry point.
  for:
  - action
  - what
- id: ret
  source: '0x8f34332dec0c624c3ccf3733d0998d5aee92800f'
  file: contracts/block/optimistic/OptimisticBlockVerifier1.sol
  has: Pairing.pairing(Pairing.negate(proof.A), proof.B, vk.alfa1, vk.beta2, vk_x, vk.gamma2, proof.C, vk.delta2)
  line: 253
  says: Result is the Groth16 pairing equation over the hard-coded key.
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

This contract checks Groth16 proofs over BN254 against a hard-coded verifying key for the zkBridge optimistic-chain block router. It accepts a proof when the BN254 pairing check passes, so a quantum attacker who recovers the setup trapdoor can prove false block headers.

## Evidence

- [verifyProof](https://etherscan.io/address/0x8f34332dec0c624c3ccf3733d0998d5aee92800f#code) returns the result of a BN254 pairing check on the proof and the verifying key.
- [verifyingKey](https://etherscan.io/address/0x8f34332dec0c624c3ccf3733d0998d5aee92800f#code) hard-codes the Groth16 alpha, beta, gamma and delta points.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 215) range-checks the proof points, then builds vk_x from IC[0] and IC[1]·input[0] with the ecmul (scalar_mul, line 87) and ecadd (plus, line 63) precompiles. It returns Pairing.pairing(-A, B, alfa1, beta2, vk_x, gamma2, C, delta2) (line 253), which calls the ecpairing precompile 0x08 (line 132) against the constant key from verifyingKey (lines 166-209). Kev's finding states that OptimisticBlockRouter.importBlock calls blockVerifier[1].verifyProof, that this address sits in that slot, and that imported headers feed ZKBridge.checkBlock and the LayerZero DVN's checkBlockConfirmation. Whoever knows the setup trapdoor (toxic waste) can produce a valid-looking proof for any public input. The contract itself is not upgradeable, but the router owner (Polyhedra 3-of-5 Safe) can repoint the slot.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself
- Ruled out: No admin or upgrade path in this contract

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
