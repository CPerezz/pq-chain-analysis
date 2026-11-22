---
id: contract-749fc77a-plonk-verifier-bn254
format: 2
title: Scroll's version-9 BN254 proof verifier can be fooled by a quantum attacker
status: candidate
severity: MEDIUM
justification: BN254 checks fall to a recovered setup trapdoor; Scroll's timelocked owner can register a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  project: scroll
  code: decompiled
  code_url: code/0xf86ce35d4f5b1478f21194d9c6fc825f8d8afc0468425c981dc017149f0cac5e.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a hash-based verifier in MultipleVersionRollupVerifier through the timelocked ScrollOwner, replacing
  this BN254 verifier.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
- id: b3
  bytecode: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
- id: b4
  bytecode: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  has: 60075afa
  says: Code calls the BN254 multiplication precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x749fc77a1a131632a8b88e8703e489557660c75e'
  is: contract
  bytes: 18513
  says: Address holds 18,513 bytes of contract code.
  for:
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

This contract checks Scroll rollup proofs with BN254 elliptic-curve arithmetic. A quantum attacker who recovers the setup trapdoor forges a proof that it accepts.

## Evidence

- [Runtime code](https://etherscan.io/address/0x749fc77a1a131632a8b88e8703e489557660c75e#code) calls the BN254 multiplication precompile.
- [Runtime code](https://etherscan.io/address/0x749fc77a1a131632a8b88e8703e489557660c75e#code) calls the modexp precompile at several offsets for field arithmetic.

## Reviewer notes

### Mechanism

Bytecode-only, fallback-only snark-verifier contract (18,513 bytes). Per kev's finding it is registered in MultipleVersionRollupVerifier for version 9; ScrollChain.finalizeBundlePostEuclidV2 calls verifyBundleProof, which routes through the version wrapper's plonkVerifier() to this contract. The fallback performs BN254 ecmul (precompile 0x07, offset 15544) and modexp (0x05, offsets 7613, 13144, 13705) for KZG/PLONK verification. A forged proof over a false withdrawRoot lets the L1 bridge pay out against it, if a version-9 batch is still finalizable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: Not upgradeable; fix is repointing the router.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
