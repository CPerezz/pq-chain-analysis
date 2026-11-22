---
id: update3g16verifier-26fb9b04-lottery-groth16
format: 2
title: FOOM Update3 verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: 'Fixed BN254 Groth16 key: the setup trapdoor forges proofs; the code can''t change, so FOOM must
  deploy anew.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x26fb9b040a680e800db862d4b1479269a4cba356'
  name: Update3G16Verifier
  project: foom
  code: verified
  code_url: https://etherscan.io/address/0x26fb9b040a680e800db862d4b1479269a4cba356#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new lottery with hash-based (STARK/FRI or WHIR) proofs and replaceable verifier addresses.
evidence_level: source
checks:
- id: c1
  source: '0x26fb9b040a680e800db862d4b1479269a4cba356'
  file: src/Update3.sol
  line: 77
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[7] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof is the public entry taking a Groth16 proof and 7 public signals
  for:
  - evidence-1
  - what
- id: c4
  source: '0x26fb9b040a680e800db862d4b1479269a4cba356'
  file: src/Update3.sol
  line: 178
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: the proof is accepted via the BN254 pairing precompile 0x08
  for:
  - action
  - evidence-2
  - justification
  - what
- id: k-alpha
  source: '0x26fb9b040a680e800db862d4b1479269a4cba356'
  file: src/Update3.sol
  has: uint256 constant alphax  = 16428432848801857252194528405604668803277877773566238944394625302971855135431;
  line: 30
  says: alpha of the verification key is a compile-time constant
  for:
  - evidence-3
  - justification
  - what
- id: k-delta
  source: '0x26fb9b040a680e800db862d4b1479269a4cba356'
  file: src/Update3.sol
  has: uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
  line: 40
  says: delta of the verification key is a compile-time constant
  for:
  - action
  - evidence-3
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

This contract checks Groth16 proofs with a BN254 pairing against a verification key fixed in its code. A quantum attacker who recovers the setup trapdoor can build proofs of false statements that this check accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x26fb9b040a680e800db862d4b1479269a4cba356#code) takes proof points A, B, C and seven public signals and returns a bool.
- [checkPairing](https://etherscan.io/address/0x26fb9b040a680e800db862d4b1479269a4cba356#code) calls the BN254 pairing precompile 0x08 to accept or reject the proof.
- The [verification key](https://etherscan.io/address/0x26fb9b040a680e800db862d4b1479269a4cba356#code) (alpha, beta, gamma, delta) is a set of constants in the code.

## Reviewer notes

### Mechanism

verifyProof (line 77) range-checks the 7 public signals (lines 188-200), then checkPairing folds them into vk_x with ecMul (precompile 7, line 94) and ecAdd (precompile 6, line 104) over constants IC0..IC7. It writes -A, B, alpha, beta, vk_x, gamma, C and delta (key constants, lines 30-43) and calls the pairing precompile 0x08 (line 178). It returns success AND result. Per kev, FoomLottery holds this address as an immutable and calls it in reveal() to accept tree-update roots. A trapdoor recovered from the BN254 setup lets an attacker forge proofs that pass this check, so they can insert winning leaves and later pay them out through collect().

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy, owner or admin: the contract code has no setter for the key.
- Ruled out: The verifier itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
