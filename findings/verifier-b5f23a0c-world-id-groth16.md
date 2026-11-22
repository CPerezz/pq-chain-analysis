---
id: verifier-b5f23a0c-world-id-groth16
format: 2
title: World ID insertion verifier trusts a Groth16 setup a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: A recovered setup trapdoor forges insertion proofs; only the owner Safe can swap this verifier out.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258'
  name: Verifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1594
impact: liveness
action: Replace this verifier through the lookup table with a post-quantum proof verifier once one is available.
evidence_level: source
checks:
- id: c1
  source: '0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258'
  file: src/insertion_b100t30_verifier.sol
  line: 479
  has: function verifyProof(
  says: verifyProof is the Groth16 verification entry point
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair
  source: '0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258'
  file: src/insertion_b100t30_verifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 518
  says: pairing check via the BN254 precompile
  for:
  - evidence-2
  - justification
  - what
- id: rev
  source: '0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258'
  file: src/insertion_b100t30_verifier.sol
  has: revert ProofInvalid();
  line: 466
  says: invalid proofs revert
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
  who: Review16 (verified source of WorldIDIdentityManagerImplV2, WorldIDRouterImplV1, VerifierLookupTable, SemaphoreVerifier;
    on-chain reads; Xatu scan for consumers)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies Groth16 proofs over BN254 for batch insertions of 100 identities into World ID group 1's tree. A quantum attacker who recovers the setup trapdoor can forge proofs that pass this check. Tree updates still require the identity operator.

## Evidence

- [verifyProof](https://etherscan.io/address/0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258#code) takes a Groth16 proof and one public input.
- [verifyProof](https://etherscan.io/address/0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258#code) checks the BN254 pairing equation with the precompile.

## Reviewer notes

### Mechanism

WorldIDIdentityManager.registerIdentities (onlyIdentityOperator) requires preRoot == latest root, hashes the batch, and calls batchInsertionVerifiers.getVerifierFor(100).verifyProof(proof, [inputHash mod r]), which resolves to this contract. verifyProof (line 479) computes the public-input MSM, writes A, B, C plus the hardcoded alpha, beta, gamma and delta constants, and calls the BN254 pairing precompile (line 518). It reverts unless the precompile returns 1. Groth16 soundness rests on the setup trapdoor staying unknown, and a quantum attacker could derive it from the public key. The verifier has no admin and cannot be changed. The Safe-owned VerifierLookupTable can replace or disable it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds.
- Ruled out: A forged proof alone does not move the root; the operator gate remains.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
