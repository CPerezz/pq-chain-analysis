---
id: update11g16verifier-dbf505b7-lottery-groth16
format: 2
title: FOOM Update11 verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: 'Fixed BN254 Groth16 key: setup trapdoor forges tree updates; only a new FOOM lottery deployment
  fixes it.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  name: Update11G16Verifier
  project: foom
  code: verified
  code_url: https://etherscan.io/address/0xdbf505b7f76075f699efc66ab0868e6bbce4084c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new FOOM lottery whose update proofs use a hash-based post-quantum proof system with replaceable
  verifiers.
evidence_level: source
checks:
- id: c1
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  line: 101
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[15] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof takes Groth16 points A, B, C and 15 public signals.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  line: 118
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: Uses the ecMul precompile (0x07) on BN254.
  for:
  - evidence-2
- id: c3
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  line: 128
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: Uses the ecAdd precompile (0x06) on BN254.
  for:
  - evidence-2
- id: c4
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  line: 218
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Calls the BN254 pairing precompile (0x08) to accept the proof.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: vk-alpha
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  has: uint256 constant alphax  = 16428432848801857252194528405604668803277877773566238944394625302971855135431;
  line: 30
  says: Verification key alpha is a compile-time constant.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: vk-delta
  source: '0xdbf505b7f76075f699efc66ab0868e6bbce4084c'
  file: src/Update11.sol
  has: uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
  line: 40
  says: Verification key delta is a compile-time constant.
  for:
  - evidence-3
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

This contract checks Groth16 proofs of FOOM lottery tree updates for 11 queued bets, using a BN254 pairing check against hard-coded verification-key constants. A quantum attacker who recovers the setup trapdoor can forge update proofs it accepts, letting winning leaves into the lottery tree.

## Evidence

- [verifyProof](https://etherscan.io/address/0xdbf505b7f76075f699efc66ab0868e6bbce4084c#code) takes proof points A, B, C and 15 public signals.
- [verifyProof](https://etherscan.io/address/0xdbf505b7f76075f699efc66ab0868e6bbce4084c#code) folds signals with the ecMul and ecAdd precompiles and calls the pairing precompile 0x08.
- The [verification key](https://etherscan.io/address/0xdbf505b7f76075f699efc66ab0868e6bbce4084c#code) (alpha, beta, gamma, delta) is stored as constants in the code.

## Reviewer notes

### Mechanism

Update11G16Verifier.verifyProof (line 101) range-checks the 15 public signals (lines 228-256). It then builds vk_x from the IC constants via g1_mulAccC, which uses ecMul precompile 7 (line 118) and ecAdd precompile 6 (line 128). It writes -A, B, alpha1, beta2, vk_x, gamma2, C and delta2 and calls pairing precompile 8 (line 218), returning success AND the result. The key constants (lines 30-43) are compiled in, so nothing can change them. FoomLottery.reveal calls this verifier for 11-bet queues and stores _newRoot when it returns true. Knowing the trusted-setup trapdoor, which a quantum attacker could derive from the BN254 key, lets the attacker produce accepted proofs for false tree updates.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not a proxy and has no owner or admin.
- Ruled out: The verifier itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
