---
id: update5g16verifier-ad61d88f-lottery-groth16
format: 2
title: FOOM Update5 verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Hard-coded BN254 setup; its trapdoor forges lottery tree updates. Only a new deployment by the FOOM
  team fixes it.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  name: Update5G16Verifier
  project: foom
  code: verified
  code_url: https://etherscan.io/address/0xad61d88f29dd1c598dd683ad69375cdf45fbf769#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new lottery whose update proofs use a hash-based post-quantum proof system and replaceable verifiers.
evidence_level: source
checks:
- id: c1
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  line: 83
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[9] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof takes a Groth16 proof and nine public signals.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  line: 100
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: vk_x uses the ecMul precompile 7.
  for:
  - evidence-2
- id: c3
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  line: 110
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: vk_x uses the ecAdd precompile 6.
  for:
  - evidence-2
- id: c4
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  line: 188
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: The result comes from the BN254 pairing precompile 8.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: vk-alpha
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  has: uint256 constant alphax  = 16428432848801857252194528405604668803277877773566238944394625302971855135431;
  line: 30
  says: The verification key alpha is a compile-time constant.
  for:
  - evidence-3
  - justification
  - what
- id: vk-delta
  source: '0xad61d88f29dd1c598dd683ad69375cdf45fbf769'
  file: src/Update5.sol
  has: uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
  line: 40
  says: The verification key delta is a compile-time constant.
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

This contract checks Groth16 proofs for FOOM lottery tree updates with a BN254 pairing against a hard-coded verification key. A quantum attacker who recovers the setup trapdoor can make false update proofs pass, letting forged winning leaves into the tree.

## Evidence

- [verifyProof](https://etherscan.io/address/0xad61d88f29dd1c598dd683ad69375cdf45fbf769#code) takes nine public signals and returns the result of a BN254 pairing check.
- [verifyProof](https://etherscan.io/address/0xad61d88f29dd1c598dd683ad69375cdf45fbf769#code) folds the signals into vk_x with the ecMul and ecAdd precompiles.
- The [verification key](https://etherscan.io/address/0xad61d88f29dd1c598dd683ad69375cdf45fbf769#code) is compiled in as constants, so it does not change.

## Reviewer notes

### Mechanism

Update5G16Verifier.verifyProof (line 83) range-checks the nine public signals (lines 198-214). It builds vk_x from IC0..IC9 via g1_mulAccC, using precompile 7 (line 100) and precompile 6 (line 110). It then calls the pairing precompile 8 (line 188) on -A,B / alpha,beta / vk_x,gamma / C,delta. The constants are hard-coded at lines 30-74. FoomLottery calls this contract from reveal() when the queue size selects N=5, and stores the new root only if verifyProof returns true. With the setup trapdoor, which is the discrete log of the CRS elements, a quantum attacker can produce A,B,C for any public signals. The reviewer should note that gamma2 (lines 36-39) and delta2 (lines 40-43) are identical constants in this key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; the code holds no funds and has no owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
