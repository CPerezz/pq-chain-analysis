---
id: contract-39854df3-plonk-verifier-bn254
format: 2
title: Scroll Halo2 verifier trusts BN254 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A forged BN254 proof can pass this verifier; MEDIUM because Scroll's timelocked owner can register
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  project: scroll
  code: decompiled
  code_url: code/0x30af8474d8e13b8ce6a96eae63293310e7c1072b890bde77f96786497a9e5f4b.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a hash-based verifier in MultipleVersionRollupVerifier to replace the BN254 verifiers for all versions.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  has: 60055afa
  says: the code calls the modexp precompile
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  has: 60055afa
  says: the code calls the modexp precompile
  for:
  - evidence-2
- id: b3
  bytecode: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  has: 60055afa
  says: the code calls the modexp precompile
  for:
  - evidence-2
- id: b4
  bytecode: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  has: 60075afa
  says: the code calls the BN254 multiplication precompile
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x39854df30b3482ef546f68b8981fae5a2c426ea4'
  is: contract
  bytes: 18498
  says: the address holds 18498 bytes of contract code
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

This contract is a bytecode-only Halo2/PLONK proof verifier that runs BN254 elliptic-curve and modexp precompile arithmetic. A quantum attacker who recovers the BN254 setup trapdoor can produce proofs of false statements that this kind of verifier accepts.

## Evidence

- [Runtime code](https://etherscan.io/address/0x39854df30b3482ef546f68b8981fae5a2c426ea4#code) calls the BN254 multiplication precompile.
- [Runtime code](https://etherscan.io/address/0x39854df30b3482ef546f68b8981fae5a2c426ea4#code) calls the modexp precompile used in field arithmetic.

## Reviewer notes

### Mechanism

Per kev: ScrollChain.finalizeBundlePostEuclidV2 calls MultipleVersionRollupVerifier.verifyBundleProof, which uses latestVerifier[version]. For versions 7 and 8 that is a ZkEvmVerifier wrapper whose plonkVerifier() is this contract. This contract's fallback runs a snark-verifier Halo2 check on BN254, using ecmul (offset 15529) and modexp (offsets 7598, 13129, 13690), and ends with an ecpairing call. A forged proof would let a false withdraw root be finalized. Whether a version-7 or version-8 batch can still be finalized at the current index was not checked.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: The contract is not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
