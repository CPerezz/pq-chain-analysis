---
id: bscverifier1-bf9720de-zkbridge-groth16
format: 2
title: Polyhedra BSC verifier trusts a Groth16 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Groth16 BN254 trapdoor recovery lets forged BSC headers prove; Polyhedra's Safe must repoint to post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  name: BscVerifier1
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0xbf9720de605b7c3886bc151976a5140b1ae8a3e0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a post-quantum BSC header verifier and have the Safe point the BSC updater's blockVerifier at it.
evidence_level: source
checks:
- id: c4
  source: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  file: contracts/block/bsc/verify/52338000/BscVerifier1.sol
  line: 135
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: pairing uses the BN254 pairing precompile 8
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  file: contracts/block/bsc/verify/52338000/BscVerifier1.sol
  line: 167
  has: function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  says: verifying key is defined in the code
  for:
  - justification
  - what
- id: c6
  source: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  file: contracts/block/bsc/verify/52338000/BscVerifier1.sol
  line: 168
  has: vk.alfa1 = Pairing.G1Point(uint256(9492101525052878528858568419452118538405385613214348752963322344089703680033),
    uint256(34140113435458459266591349545510513880
  says: verifying key constants are fixed BN254 points
  for:
  - what
- id: vk-call
  source: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  file: contracts/block/bsc/verify/52338000/BscVerifier1.sol
  has: VerifyingKey memory vk = verifyingKey();
  line: 192
  says: verifyProof uses the hard-coded verifying key
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair-call
  source: '0xbf9720de605b7c3886bc151976a5140b1ae8a3e0'
  file: contracts/block/bsc/verify/52338000/BscVerifier1.sol
  has: return Pairing.pairing(
  line: 218
  says: verifyProof returns the Groth16 pairing check result
  for:
  - evidence-3
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

This contract checks Groth16 proofs over BN254 for Polyhedra's BSC block updater, using a hard-coded verifying key and the pairing precompile. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false BSC header.

## Evidence

- [verifyProof](https://etherscan.io/address/0xbf9720de605b7c3886bc151976a5140b1ae8a3e0#code) loads a verifying key that is fixed in the code.
- [pairing](https://etherscan.io/address/0xbf9720de605b7c3886bc151976a5140b1ae8a3e0#code) calls the BN254 pairing precompile at address 8.
- [verifyProof](https://etherscan.io/address/0xbf9720de605b7c3886bc151976a5140b1ae8a3e0#code) returns the result of the pairing check against that key.

## Reviewer notes

### Mechanism

verifyProof(a,b,c,input) (line 180) loads verifyingKey() (lines 167-174, constants alfa1/beta2/gamma2/delta2/IC). It computes vk_x from the inputs using scalar_mul (precompile 7, line 92) and plus (precompile 6, line 70). It then returns Pairing.pairing(-A, B, alfa1, beta2, vk_x, gamma2, C, delta2) (line 218), which runs precompile 8 (line 135). Groth16 soundness rests on the discrete-log hardness of the setup trapdoor. Per kev, the BscBlockUpdater's blockVerifier(1) is this contract. A proof forged with the trapdoor imports a fake BSC header whose receiptsRoot the ZKBridge endpoint and the LayerZero DVN then trust.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
