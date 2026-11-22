---
id: verifier-43b68ccb-world-id-groth16
format: 2
title: World ID deletion verifier trusts a Groth16 setup quantum attackers could break
status: confirmed
severity: MEDIUM
justification: 'A setup trapdoor forges deletion proofs; the operator gate remains and only a Safe verifier swap
  fixes it: MEDIUM.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x43b68ccba7fc726540768fd1537c3179283140ed'
  name: Verifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0x43b68ccba7fc726540768fd1537c3179283140ed#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 172
impact: liveness
action: Replace this verifier in the deletion lookup table with one based on a post-quantum proof system.
evidence_level: source
checks:
- id: c1
  source: '0x43b68ccba7fc726540768fd1537c3179283140ed'
  file: src/deletion_b100t30_verifier.sol
  line: 479
  has: function verifyProof(
  says: The verifyProof entry point takes a Groth16 proof and one public input.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair
  source: '0x43b68ccba7fc726540768fd1537c3179283140ed'
  file: src/deletion_b100t30_verifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 518
  says: The proof is accepted through a BN254 pairing precompile call.
  for:
  - evidence-2
  - justification
  - what
- id: key
  source: '0x43b68ccba7fc726540768fd1537c3179283140ed'
  file: src/deletion_b100t30_verifier.sol
  has: mstore(add(f, 0x280), GAMMA_NEG_X_1)
  line: 512
  says: The verification key comes from hardcoded constants.
  for:
  - evidence-2
  - what
- id: rev
  source: '0x43b68ccba7fc726540768fd1537c3179283140ed'
  file: src/deletion_b100t30_verifier.sol
  has: revert ProofInvalid();
  line: 466
  says: The verifier reverts only when the pairing check fails.
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

This contract checks Groth16 proofs for World ID batch deletions with a BN254 pairing check against a fixed verification key. A quantum attacker who recovers the setup trapdoor could forge proofs that this check accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x43b68ccba7fc726540768fd1537c3179283140ed#code) takes eight proof words and one public input.
- [The pairing check](https://etherscan.io/address/0x43b68ccba7fc726540768fd1537c3179283140ed#code) calls the BN254 precompile with the proof and the hardcoded gamma and delta points.
- [The check reverts](https://etherscan.io/address/0x43b68ccba7fc726540768fd1537c3179283140ed#code) on a failed pairing; otherwise the proof counts as valid.

## Reviewer notes

### Mechanism

verifyProof (line 479) computes the public input commitment with publicInputMSM. It copies the proof points (A, B, C) to memory and writes the hardcoded verification key constants: DELTA_NEG, ALPHA, BETA_NEG and GAMMA_NEG (lines 500-516). It then calls the BN254 pairing precompile with staticcall (line 518). The compressed path does the same at line 461 and reverts with ProofInvalid at line 466. According to kev's finding, the group 1 WorldIDIdentityManager deleteIdentities function (onlyIdentityOperator) calls this verifier through the batchDeletionVerifiers lookup table and then sets _latestRoot = postRoot. A setup trapdoor lets an attacker forge proofs, but the operator EOA gate remains. The owner Safe can swap the verifier with updateVerifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds held by this contract
- Ruled out: Tree updates still require the identity-operator caller

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
