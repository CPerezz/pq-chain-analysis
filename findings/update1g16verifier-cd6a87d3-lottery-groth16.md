---
id: update1g16verifier-cd6a87d3-lottery-groth16
format: 2
title: FOOM Update1 verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Fixed BN254 pairing check guards lottery tree updates; only a new FOOM deployment with post-quantum
  proofs fixes it
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  name: Update1G16Verifier
  project: foom
  code: verified
  code_url: https://etherscan.io/address/0xcd6a87d333c9c3bf9302b04ad36928eec5bba587#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new lottery whose update, withdraw and cancel proofs use a hash-based post-quantum proof system
  with replaceable verifiers
evidence_level: source
checks:
- id: c1
  source: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  file: src/Update1.sol
  line: 71
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[5] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof is the public Groth16 verification entry point
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  file: src/Update1.sol
  line: 88
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: ecMul precompile 0x07 is used to build vk_x
  for:
  - evidence-3
- id: c3
  source: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  file: src/Update1.sol
  line: 98
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: ecAdd precompile 0x06 is used to build vk_x
  for:
  - evidence-3
- id: c4
  source: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  file: src/Update1.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: the result comes from the BN254 pairing precompile 0x08
  for:
  - action
  - evidence-1
  - justification
  - what
- id: vk
  source: '0xcd6a87d333c9c3bf9302b04ad36928eec5bba587'
  file: src/Update1.sol
  has: uint256 constant deltax1
  line: 40
  says: the delta part of the verification key is a hard-coded constant
  for:
  - evidence-2
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
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs on BN254 for FoomLottery's single-bet tree updates, against a verification key that is hard-coded in the contract. With the trusted-setup trapdoor, a quantum attacker could make false update proofs pass and insert winning leaves into the lottery.

## Evidence

- [verifyProof](https://etherscan.io/address/0xcd6a87d333c9c3bf9302b04ad36928eec5bba587#code) returns the result of a BN254 pairing check through precompile 0x08.
- [The verification key](https://etherscan.io/address/0xcd6a87d333c9c3bf9302b04ad36928eec5bba587#code) is stored as compile-time constants, so it is fixed in the code.
- [g1_mulAccC](https://etherscan.io/address/0xcd6a87d333c9c3bf9302b04ad36928eec5bba587#code) folds the public signals into vk_x with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

verifyProof (line 71) takes _pA, _pB, _pC and 5 public signals. It range-checks the signals (lines 178-186), then checkPairing folds them into vk_x with g1_mulAccC (ecMul at line 88, ecAdd at line 98) over the constants IC0..IC5. It then runs the pairing precompile 0x08 (line 168) against the constants alpha, beta, gamma and delta (lines 30-43). FoomLottery.reveal() calls this verifier through its update1 immutable before it stores a new Merkle root. Anyone who holds the setup trapdoor, which a quantum attacker can obtain from the BN254 parameters, can make a proof of a false update verify. This lets the attacker insert winning leaves that collect() later pays out. The contract has no admin or upgrade path, and the key is fixed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself
- Ruled out: The verifier has no proxy and no owner

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
