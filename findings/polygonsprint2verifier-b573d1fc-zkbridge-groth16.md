---
id: polygonsprint2verifier-b573d1fc-zkbridge-groth16
format: 2
title: Polyhedra Polygon verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A recovered setup trapdoor forges proofs; MEDIUM as Polyhedra's Safe can repoint updaters to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  name: PolygonSprint2Verifier
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0xb573d1fcd7f1a8528033d58998d931670a717e6d#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build hash-based light-client proofs and have the Safe point the Polygon updater at a post-quantum verifier.
evidence_level: source
checks:
- id: c4
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: calls the BN254 ecpairing precompile
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  line: 167
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: verifying key is hard-coded
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c6
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  line: 168
  has: vk.alfa1 = Pairing.G1Point(uint256(1941789669819617054705373364194110412258959111063554830602029142190854266111),
    uint256(20264386154329418376063881863713475387
  says: alfa1 constant point
  for:
  - evidence-2
  - what
- id: c7
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  line: 169
  has: vk.beta2 = Pairing.G2Point([uint256(4262593247738971675994574344829676954435587189106617223136900014281055401679),
    uint256(1158508333556143251133667805841277440
  says: beta2 constant point
  for:
  - evidence-2
- id: c8
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  line: 170
  has: vk.gamma2 = Pairing.G2Point([uint256(8200679851427566300945996482884976002816928494205439385328981011034885203749),
    uint256(549276063699851254633751168289448416
  says: gamma2 constant point
  for:
  - evidence-2
- id: vp
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  has: function verifyProof(
  line: 180
  says: public verifyProof entry
  for:
  - what
- id: ret
  source: '0xb573d1fcd7f1a8528033d58998d931670a717e6d'
  file: contracts/block/polygon/PolygonSprint2Verifier.sol
  has: return Pairing.pairing(
  line: 218
  says: result is the pairing check
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

This contract checks Groth16 proofs over BN254 for Polyhedra's Polygon validator-set updates against a hard-coded verifying key. A quantum attacker who recovers the setup trapdoor can produce proofs it accepts for false statements, letting forged validator sets and Polygon headers through.

## Evidence

- [verifyProof](https://etherscan.io/address/0xb573d1fcd7f1a8528033d58998d931670a717e6d#code) returns the result of a BN254 pairing check of the proof against the verifying key.
- [verifyingKey](https://etherscan.io/address/0xb573d1fcd7f1a8528033d58998d931670a717e6d#code) hard-codes the setup's alfa, beta and gamma points.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 180) loads the constant verifying key from verifyingKey() (lines 167-174), computes vk_x = IC[0] + input[0]*IC[1] via the ecmul (line 92) and ecadd (line 70) precompiles, then returns Pairing.pairing (line 218), which calls the ecpairing precompile (line 135) on e(-A,B)e(alfa,beta)e(vk_x,gamma)e(C,delta). Anyone knowing the setup toxic waste (recoverable by a discrete-log quantum attack on the key points) can produce A,B,C satisfying this for any input. Per kev's finding, PolygonBlockUpdater uses this contract as validatorVerifier(2); a forged validator-set update installs attacker keys, after which forged Polygon headers prove honestly and reach zkBridge endpoint zkReceive and the LayerZero zkLightClient DVN.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds and has no owner or upgrade path; it is fixed by repointing the updater.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
