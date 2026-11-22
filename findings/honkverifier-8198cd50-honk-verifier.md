---
id: honkverifier-8198cd50-honk-verifier
format: 2
title: ZKPassport Honk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged passport proofs release no funds via the known consumer; ZKPassport's admin can unmap this
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  name: HonkVerifier
  project: zkpassport
  code: verified
  code_url: https://etherscan.io/address/0x8198cd503cb522987d977784837be2a59e61f4ef#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Unmap this verifier's vkeyHash via removeProofVerifiers on the sub-verifier, and move passport circuits
  to a hash-based prover.
evidence_level: source
checks:
- id: c1
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  line: 4959
  has: let pairing_success := and(success, staticcall(gas(), 8, 0x00, 0x180, 0x00, 0x20))
  says: final BN254 pairing precompile call decides acceptance
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  line: 4144
  has: precomp_success_flag := staticcall(gas(), 7, G1_LOCATION, 0x60, ACCUMULATOR, 0x40)
  says: BN254 ecMul precompile on the shplonk commitment
  for:
  - evidence-2
- id: c4
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  line: 4156
  has: and(precomp_success_flag, staticcall(gas(), 6, ACCUMULATOR, 0x80, ACCUMULATOR, 0x40))
  says: BN254 ecAdd precompile accumulating commitments
  for:
  - evidence-2
- id: new-verify
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  has: function verify(bytes calldata, /*proof*/ bytes32[] calldata /*public_inputs*/ )
  line: 1288
  says: verify entry point taking a proof and public inputs
  for:
  - action
  - justification
  - what
- id: new-g2x
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  has: mstore(0x100, 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1)
  line: 4954
  says: fixed SRS G2 [x] point used in the pairing
  for:
  - what
- id: new-ret
  source: '0x8198cd503cb522987d977784837be2a59e61f4ef'
  file: src/ultra-honk-verifiers/OuterCount8.sol
  has: return(0x00, 0x20) // Proof succeeded!
  line: 4971
  says: returns success after the pairing check passes
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (verified registry source, event logs, consumer trace)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks ZKPassport's recursive passport proofs and accepts one only if a final BN254 pairing check succeeds. A quantum attacker who recovers the setup trapdoor can make it accept a proof about a passport that does not exist.

## Evidence

- [verify](https://etherscan.io/address/0x8198cd503cb522987d977784837be2a59e61f4ef#code) returns true after a BN254 pairing precompile call against fixed setup points.
- [verify](https://etherscan.io/address/0x8198cd503cb522987d977784837be2a59e61f4ef#code) builds the proof accumulator with BN254 elliptic-curve precompiles.

## Reviewer notes

### Mechanism

HonkVerifier.verify(bytes,bytes32[]) (line 1288) runs the UltraHonk/Shplemini check. It accumulates commitments with ecMul/ecAdd precompiles (lines 4144-4172), folds in the recursion pairing points (lines 4921-4945), loads the SRS G2 points [1] and [x] (lines 4948-4957), and calls the pairing precompile at address 8 (line 4959). It reverts on failure (line 4960) and otherwise returns 1 (line 4971). Whoever knows the trapdoor x behind G2 [x] can satisfy this pairing for false statements. ZKPassportSubVerifier.verify calls this contract through its proofVerifiers mapping.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no funds held by this contract.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
