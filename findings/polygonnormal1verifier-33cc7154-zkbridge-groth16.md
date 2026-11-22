---
id: polygonnormal1verifier-33cc7154-zkbridge-groth16
format: 2
title: Polyhedra Polygon header verifier trusts a quantum-breakable Groth16 setup
status: confirmed
severity: MEDIUM
justification: Pairing-based Groth16 key; Polyhedra's Safe must repoint the updater to a post-quantum verifier.
  Not fixable here.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  name: PolygonNormal1Verifier
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0x33cc71549afd56c22c9ed1cede1e7e105f0891ff#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build hash-based post-quantum header proofs and have the owning Safe point the Polygon updater at the new
  verifier.
evidence_level: source
checks:
- id: c4
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: Calls the BN254 pairing precompile (address 8).
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  line: 167
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: Verifying key is hard-coded in the contract.
  for:
  - action
  - justification
  - what
- id: c6
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  line: 168
  has: vk.alfa1 = Pairing.G1Point(uint256(15367811235213202510716294331868001087045167198818790907682238376908161744257),
    uint256(1891697878455299824766164756792141289
  says: Hard-coded alpha point of the verifying key.
  for:
  - evidence-2
- id: c7
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  line: 169
  has: vk.beta2 = Pairing.G2Point([uint256(18795422112388727596912655063994588617644768585800467377051822143163846525150),
    uint256(114262505051787438663704047498853447
  says: Hard-coded beta point of the verifying key.
  for:
  - evidence-2
- id: c8
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  line: 170
  has: vk.gamma2 = Pairing.G2Point([uint256(10610052351921038769759514128371790534254289413635775780420406566381036333156),
    uint256(15105078406928121656754490267168453
  says: Hard-coded gamma point of the verifying key.
  for:
  - evidence-2
- id: vp
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  has: function verifyProof(
  line: 180
  says: Public entry point for checking a proof.
  for:
  - what
- id: ret
  source: '0x33cc71549afd56c22c9ed1cede1e7e105f0891ff'
  file: contracts/block/polygon/PolygonNormal1Verifier.sol
  has: return Pairing.pairing(
  line: 218
  says: The result of verifyProof is the pairing check.
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

This contract checks Groth16 proofs for Polygon block headers on BN254 against a hard-coded verifying key. A quantum attacker who recovers the setup trapdoor can make a false header proof pass.

## Evidence

- [verifyProof](https://etherscan.io/address/0x33cc71549afd56c22c9ed1cede1e7e105f0891ff#code) returns the result of a BN254 pairing check.
- [verifyingKey](https://etherscan.io/address/0x33cc71549afd56c22c9ed1cede1e7e105f0891ff#code) hard-codes the alpha, beta and gamma points of the setup.

## Reviewer notes

### Mechanism

verifyProof (line 180) builds the proof from a, b and c, then checks that each coordinate is below PRIME_Q (lines 198-208). It computes vk_x from the single public input with scalar_mul (precompile 7, line 92) and plus (precompile 6, line 70), using the IC points of verifyingKey (lines 167-174). It returns Pairing.pairing (line 218), which calls the ecpairing precompile 8 (line 135). Kev's finding states that PolygonBlockUpdater calls this verifier as blockVerifier(1) when it imports headers, and that the zkBridge endpoint and the LayerZero DVN then trust those headers. An attacker who knows the setup trapdoor (the discrete logs behind delta and gamma) can build A, B and C that satisfy the pairing for any input.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier is not upgradeable and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
