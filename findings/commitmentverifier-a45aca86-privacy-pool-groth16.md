---
id: commitmentverifier-a45aca86-privacy-pool-groth16
format: 2
title: 0xbow ragequit verifier accepts proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Fixed BN254 Groth16 key backs pool ragequits; only 0xbow can replace it, via new pools users must
  move to.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  name: CommitmentVerifier
  project: 0xbow
  code: verified
  code_url: https://etherscan.io/address/0xa45aca8604a73d80c551faad6355a5c3a5565ec6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 57
impact: funds-loss
action: Register new pools with a hash-based (STARK/WHIR) ragequit verifier and wind down the pools that use this
  one.
evidence_level: source
checks:
- id: c1
  source: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  file: src/contracts/verifiers/CommitmentVerifier.sol
  line: 69
  has: function verifyProof(uint256[2] calldata _pA, uint256[2][2] calldata _pB, uint256[2] calldata _pC, uint256[4]
    calldata _pubSignals) public view returns (bool) {
  says: verifyProof takes a Groth16 proof and four public signals.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  file: src/contracts/verifiers/CommitmentVerifier.sol
  line: 86
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: The ecMul precompile is used to build vk_x.
  for:
  - evidence-3
- id: c3
  source: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  file: src/contracts/verifiers/CommitmentVerifier.sol
  line: 96
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: The ecAdd precompile is used to build vk_x.
  for:
  - evidence-3
- id: c4
  source: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  file: src/contracts/verifiers/CommitmentVerifier.sol
  line: 164
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: The BN254 pairing precompile decides validity.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: vk
  source: '0xa45aca8604a73d80c551faad6355a5c3a5565ec6'
  file: src/contracts/verifiers/CommitmentVerifier.sol
  has: uint256 constant deltax1
  line: 41
  says: The Groth16 verifying key (delta) is a hard-coded constant.
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
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
reviews: []
related: []
---

## What happens

This contract checks Groth16 ragequit proofs for 0xbow Privacy Pools against a verifying key hard-coded on BN254. A quantum attacker who recovers the setup trapdoor from that key can make proofs for any public signals, which the pools accept as valid ragequits.

## Evidence

- [verifyProof](https://etherscan.io/address/0xa45aca8604a73d80c551faad6355a5c3a5565ec6#code) returns true when a BN254 pairing check passes.
- [The verifying key](https://etherscan.io/address/0xa45aca8604a73d80c551faad6355a5c3a5565ec6#code) is stored as constants in the code, with no setter.
- [g1_mulAccC](https://etherscan.io/address/0xa45aca8604a73d80c551faad6355a5c3a5565ec6#code) folds the public signals into the key with BN254 precompiles.

## Reviewer notes

### Mechanism

verifyProof (line 69) range-checks the four public signals (lines 174-180). checkPairing (line 104) then builds vk_x from IC0..IC4 using the ecMul and ecAdd precompiles (lines 86, 96, 113-119). It then runs pairing precompile 8 (line 164) over -A, B, alpha1, beta2, vk_x, gamma2, C and delta2. All key points are constants (lines 31-60), so the key cannot be changed. With the trapdoor recovered from the key by discrete log on BN254, a prover can satisfy the pairing for arbitrary public signals. The pools then pay out the false value through ragequit. Per kev, these pools fix this verifier as an immutable at construction.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract has no proxy, owner or holdings of its own.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
