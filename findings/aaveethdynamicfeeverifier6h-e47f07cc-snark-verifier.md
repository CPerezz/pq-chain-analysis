---
id: aaveethdynamicfeeverifier6h-e47f07cc-snark-verifier
format: 2
title: AAVE/ETH dynamic-fee verifier accepts KZG proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged proofs only steer a swap-fee setting, nothing can be taken; the owner can repoint the verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698'
  name: AAVEETHDynamicFeeVerifier6h
  code: verified
  code_url: https://etherscan.io/address/0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Point the fee managers at a post-quantum verifier instead of this pairing-based one, using updateVerifier.
evidence_level: source
checks:
- id: c1
  source: '0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h.sol
  line: 69
  has: function verifyProof(bytes calldata proof, uint256[] calldata instances) public returns (bool) {
  says: verifyProof is the entry point that accepts or rejects a proof.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h.sol
  line: 156
  has: ret := and(success, staticcall(gas(), 0x06, 0x00, 0x80, 0x00, 0x40))
  says: Uses the BN254 ecAdd precompile.
  for:
  - evidence-3
  - what
- id: c3
  source: '0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h.sol
  line: 162
  has: ret := and(success, staticcall(gas(), 0x07, 0x00, 0x60, 0x00, 0x40))
  says: Uses the BN254 ecMul precompile.
  for:
  - evidence-3
  - what
- id: c6
  source: '0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h.sol
  line: 195
  has: ret := and(success, staticcall(gas(), 0x08, 0x00, 0x180, 0x00, 0x20))
  says: The final decision comes from the BN254 pairing precompile.
  for:
  - action
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Halo2 proofs of an AAVE/ETH volatility fee using KZG commitments on BN254. Acceptance rests on a pairing check, so a quantum attacker with the setup trapdoor can forge proofs that pass.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698#code) takes a proof and public instances and returns a bool.
- [ec_pairing](https://etherscan.io/address/0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698#code) calls the BN254 pairing precompile 0x08 to decide the result.
- [ec_add_acc and ec_mul_acc](https://etherscan.io/address/0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698#code) use the BN254 curve precompiles 0x06 and 0x07.

## Reviewer notes

### Mechanism

verifyProof (line 69) is an EZKL-generated Halo2 verifier. It reads the instances and proof points (read_ec_point checks that each point is on BN254). It squeezes Fiat-Shamir challenges with keccak256. It accumulates the commitments with ec_add/ec_mul (precompiles 0x06/0x07, lines 156-177). It ends with one ec_pairing (precompile 0x08, line 195) against the G2 and -s*G2 setup points. Whoever knows the KZG trapdoor s, which a quantum computer can recover by solving the discrete log, can produce a proof that passes. In kev's finding, the FeeManagerV3 contracts call this as a retired build. They also need a Lit ECDSA signature before setting a Balancer swap fee, so no pool balance moves.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds.
- Ruled out: It is not upgradeable.
- Ruled out: A forged proof only sets a swap fee within Balancer bounds; no withdrawal path exists.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
