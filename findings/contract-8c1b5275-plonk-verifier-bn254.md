---
id: contract-8c1b5275-plonk-verifier-bn254
format: 2
title: Scroll version-4 verifier accepts BN254 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 KZG proofs are forgeable via the setup trapdoor; MEDIUM as Scroll's timelocked owner can register
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  project: scroll
  code: decompiled
  code_url: code/0x14fc3c8162cc5ead23a04f8221bbd7f18f21946a6e92df34831fab6482b19a37.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  has: 60055afa
  says: Runtime code calls the modexp precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  has: 60055afa
  says: Runtime code calls the modexp precompile again.
  for:
  - evidence-2
- id: b3
  bytecode: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  has: 60055afa
  says: Runtime code calls the modexp precompile a third time.
  for:
  - evidence-2
- id: b4
  bytecode: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  has: 60075afa
  says: Runtime code calls the BN254 multiplication precompile.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0x8c1b52757b5c571adcb5572e992679d4d48e30f7'
  is: contract
  bytes: 12846
  says: The address holds contract code.
  for:
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
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x9f66505c
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (0x9f66505c deployer, wrapper and caller trace; Scroll verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review14 (verified source of the current verifier, verifier registry and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x39854df3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review01 (0x39854df3 creator, last caller trace, bytecode constants, verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is a bytecode-only PLONK verifier on BN254 that Scroll registered for version-4 bundle proofs. It checks proofs with BN254 elliptic-curve precompiles, so a quantum attacker who recovers the setup trapdoor can make a false proof pass.

## Evidence

- [Runtime code](https://etherscan.io/address/0x8c1b52757b5c571adcb5572e992679d4d48e30f7#code) calls the BN254 multiplication precompile.
- [Runtime code](https://etherscan.io/address/0x8c1b52757b5c571adcb5572e992679d4d48e30f7#code) calls the modexp precompile for field arithmetic.

## Reviewer notes

### Mechanism

Fallback-only verifier (no verified source). Decompiled code reduces calldata words modulo the BN254 scalar field, derives Fiat-Shamir challenges with keccak256, evaluates the vanishing polynomial by repeated squaring, and uses modexp (offsets 4744, 8205, 8568) for inversions and ecMul (precompile 0x7, offset 10168) for the commitment MSM, consistent with a KZG-based PLONK verifier. Per kev, MultipleVersionRollupVerifier lists it as the verifier for version 4; ScrollChain reaches verifiers via getVerifier and verifyBundleProof, whose public inputs include the withdraw root. Whether a version-4 batch is still finalizable was not checked.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no ETH or tokens.
- Ruled out: Not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
