---
id: polygonsprint1verifier-e14f9062-zkbridge-groth16
format: 2
title: Polyhedra Polygon validator-set verifier trusts quantum-forgeable Groth16
status: confirmed
severity: MEDIUM
justification: Forged validator-set proofs pass this BN254 Groth16 check; Polyhedra's Safe must repoint updaters
  to a PQ verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  name: PolygonSprint1Verifier
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0xe14f90620c30f932ca05ccc95a68d34ca340ea2f#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build hash-based post-quantum validator-set proofs and have the Safe repoint the Polygon updater to a matching
  verifier.
evidence_level: source
checks:
- id: c4
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Calls the BN254 pairing precompile (0x08).
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  line: 167
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is a hard-coded pure function.
  for:
  - justification
  - what
- id: c6
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  line: 168
  has: vk.alfa1 = Pairing.G1Point(uint256(20445225257951639210164300322713039037125058357840280348244036731397972602201),
    uint256(1665471107352509075162639907309602789
  says: Hard-coded alpha point of the key.
  for:
  - evidence-3
  - what
- id: c7
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  line: 169
  has: vk.beta2 = Pairing.G2Point([uint256(8448176353708371591840133514502437826324406893580568402043590246116166494036),
    uint256(1288840624396025834752183576949030984
  says: Hard-coded beta point of the key.
  for:
  - evidence-3
- id: c8
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  line: 170
  has: vk.gamma2 = Pairing.G2Point([uint256(21711715037016739631016085396948482131107174766229078942096539845532357130601),
    uint256(12998009207665664614179855792691690
  says: Hard-coded gamma point of the key.
  for:
  - evidence-3
- id: vp
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  has: function verifyProof(
  line: 180
  says: Public proof verification entry point.
  for:
  - action
  - justification
  - what
- id: pair
  source: '0xe14f90620c30f932ca05ccc95a68d34ca340ea2f'
  file: contracts/block/polygon/PolygonSprint1Verifier.sol
  has: return Pairing.pairing(
  line: 218
  says: Result is the Groth16 pairing check.
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

This contract checks Groth16 proofs for Polygon validator-set updates against a hard-coded BN254 verifying key. A quantum attacker who recovers the setup trapdoor can make a false proof pass this pairing check.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe14f90620c30f932ca05ccc95a68d34ca340ea2f#code) returns the result of a pairing check with the fixed verifying key.
- [pairing](https://etherscan.io/address/0xe14f90620c30f932ca05ccc95a68d34ca340ea2f#code) calls the BN254 pairing precompile at address 8.
- [verifyingKey](https://etherscan.io/address/0xe14f90620c30f932ca05ccc95a68d34ca340ea2f#code) hard-codes the alpha, beta, gamma and delta points of the setup.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 180) loads the constant key from verifyingKey() (lines 167-174), computes vk_x = IC[0] + input*IC[1] with scalar_mul (ecmul, line 92) and plus (ecadd, line 70), then returns Pairing.pairing(-A, B, alfa1, beta2, vk_x, gamma2, C, delta2) (line 218), which calls the ecpairing precompile (line 135). Per kev, PolygonBlockUpdater uses this as validatorVerifier(1); someone who knows the setup trapdoor (recoverable by a quantum attacker from the BN254 key) can forge a validator-set update, install attacker keys, then prove fake Polygon headers that the zkBridge endpoint and LayerZero zkLightClient DVN accept.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds and has no admin; it is repointable, not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
