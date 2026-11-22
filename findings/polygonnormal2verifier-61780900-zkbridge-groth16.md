---
id: polygonnormal2verifier-61780900-zkbridge-groth16
format: 2
title: Polyhedra Polygon verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 Groth16 setup; Polyhedra's Safe must repoint the updater to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  name: PolygonNormal2Verifier
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build hash-based light-client proofs and deploy a post-quantum verifier, then have the Safe point the Polygon
  updater at it.
evidence_level: source
checks:
- id: c4
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: pairing check via ecpairing precompile 8
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  line: 167
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: verifying key is hard-coded
  for:
  - action
  - justification
  - what
- id: c6
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  line: 168
  has: vk.alfa1 = Pairing.G1Point(uint256(16527596929351435296462331592270746355215043872438478985076142613175080578907),
    uint256(1006027114734129250491848253225790052
  says: alpha point of the setup
  for:
  - evidence-2
  - what
- id: c7
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  line: 169
  has: vk.beta2 = Pairing.G2Point([uint256(3846614360437772900341571076658852390677411962381515896469495354673062052752),
    uint256(8026970464012544423650540721907620638
  says: beta point of the setup
  for:
  - evidence-2
- id: c8
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  line: 170
  has: vk.gamma2 = Pairing.G2Point([uint256(19048206525584107321491941720911992679860555782502690907342566397194865273914),
    uint256(17176761490359306758246550260902738
  says: gamma point of the setup
  for:
  - evidence-2
- id: vp
  source: '0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8'
  file: contracts/block/polygon/PolygonNormal2Verifier.sol
  has: function verifyProof(
  line: 180
  says: public verifyProof entry point
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

This contract checks Groth16 proofs for Polygon block headers against a hard-coded BN254 verifying key. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false header, which the Polygon updater then trusts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8#code) returns the result of a BN254 pairing check on the proof.
- [verifyingKey](https://etherscan.io/address/0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8#code) hard-codes the setup's alpha, beta, gamma and delta points.

## Reviewer notes

### Mechanism

verifyProof (line 180) builds vk_x from IC with scalar_mul (precompile 7, line 92) and plus (precompile 6, line 70), then calls Pairing.pairing (line 218), which runs the ecpairing precompile 8 (line 135) against the constant key from verifyingKey (lines 167-174). Kev's census records this address in PolygonBlockUpdater blockVerifier(2). Knowing the setup trapdoor (alpha, beta, delta discrete logs, recoverable with Shor) lets an attacker craft A, B, C satisfying the equation for any public input. That makes a false Polygon header importable. ZKBridge.validateTransactionProof and the LayerZero zkLightClient DVN then accept receipts against it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; fix is repointing in the updater

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
