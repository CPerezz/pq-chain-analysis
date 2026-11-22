---
id: verifier-75cbc75e-world-id-groth16
format: 2
title: World ID group 3 insertion verifier trusts a quantum-breakable Groth16 setup
status: confirmed
severity: MEDIUM
justification: A quantum-recovered setup trapdoor forges these proofs; the Worldcoin owner Safe must swap the verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85'
  name: Verifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2163
impact: liveness
action: Replace this verifier through the lookup table with a post-quantum proof system before quantum attacks are
  practical.
evidence_level: source
checks:
- id: c1
  source: '0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85'
  file: src/verifiers/insertion/b100.sol
  line: 517
  has: function verifyProof(uint256[8] calldata proof, uint256[1] calldata input) public view {
  says: verifyProof takes an 8-word Groth16 proof and one public input.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c553
  source: '0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85'
  file: src/verifiers/insertion/b100.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 553
  says: The proof is checked with the BN254 pairing precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c557
  source: '0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85'
  file: src/verifiers/insertion/b100.sol
  has: if (!success) {
  line: 557
  says: Acceptance depends only on the pairing check result.
  for:
  - evidence-2
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

This contract verifies Groth16 proofs over BN254 for batch insertions into a World ID identity tree. It accepts a proof when the pairing check passes, so an attacker holding the setup trapdoor could produce proofs it accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85#code) takes a Groth16 proof and one public input.
- [verifyProof](https://etherscan.io/address/0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85#code) accepts the proof when the BN254 pairing precompile returns success.

## Reviewer notes

### Mechanism

verifyProof (line 517) computes the public-input point with publicInputMSM(input) (line 518). It copies proof points A, B and C into memory and appends the fixed verification key constants for delta, alpha, beta and gamma (lines 535-550). It then calls the BN254 pairing precompile with staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20) (line 553) and reverts unless the call succeeds (line 557). Per kev's finding, the group 3 identity manager calls this verifier through its insertion VerifierLookupTable in registerIdentities, which the identity operator gates. A party who recovers the setup trapdoor could forge proofs, but a tree update still requires the operator, so the finding's impact is liveness rather than funds loss.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds.
- Ruled out: The contract is not upgradeable; the owner swaps it through the lookup table.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
