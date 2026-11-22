---
id: withdrawg16verifier-c043865f-lottery-groth16
format: 2
title: FOOM withdraw verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Lottery payouts rest on a fixed BN254 Groth16 key; the code has no upgrade path, so only a new deployment
  fixes it.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6'
  name: WithdrawG16Verifier
  project: foom
  code: verified
  code_url: https://etherscan.io/address/0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new lottery whose withdraw proofs use a hash-based proof system and whose verifiers can be replaced.
evidence_level: source
checks:
- id: c1
  source: '0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6'
  file: src/Withdraw.sol
  line: 77
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[7] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof entry point taking a Groth16 proof and 7 public signals.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6'
  file: src/Withdraw.sol
  line: 178
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Pairing check through the BN254 precompile 0x08.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: vk-const
  source: '0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6'
  file: src/Withdraw.sol
  has: uint256 constant alphax
  line: 30
  says: Verification key alpha is a hard-coded constant.
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
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
reviews: []
related: []
---

## What happens

This contract checks the Groth16 withdraw proofs that FOOM's lottery relies on before it pays out FOOM. It accepts a proof when a BN254 pairing check against hard-coded key constants passes. With the setup trapdoor, a quantum attacker forges proofs that pass this check.

## Evidence

- [verifyProof](https://etherscan.io/address/0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6#code) takes proof points A, B, C and seven public signals.
- [checkPairing](https://etherscan.io/address/0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6#code) calls the BN254 pairing precompile 0x08 and returns its result.
- [The verification key](https://etherscan.io/address/0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6#code) is stored as compile-time constants.

## Reviewer notes

### Mechanism

verifyProof (line 77) range-checks the seven public signals (lines 188-200). It folds them into vk_x through g1_mulAccC, which uses ecMul (precompile 7, line 94) and ecAdd (precompile 6, line 104). It then builds the pairing input from -A, B, alpha, beta, vk_x, gamma, C and delta, using the constants at lines 30-43, and calls precompile 8 at line 178. It returns the result. According to kev, FoomLottery.collect() calls this verifier through an immutable address and pays FOOM when the check passes. Anyone holding the BN254 setup trapdoor, which a quantum computer can recover, can make proofs of false withdraw statements verify.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself
- Ruled out: No proxy or owner on the verifier

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
