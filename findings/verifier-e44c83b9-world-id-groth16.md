---
id: verifier-e44c83b9-world-id-groth16
format: 2
title: World ID insertion verifier trusts a Groth16 setup a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: BN254 Groth16 setup trapdoor lets a forged proof pass; the owner Safe must swap this verifier, so
  MEDIUM
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe44c83b9e1971a24ec698829297a0c4026b0cef9'
  name: Verifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0xe44c83b9e1971a24ec698829297a0c4026b0cef9#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace this verifier in the group's lookup table with a post-quantum proof verifier via the owner Safe.
evidence_level: source
checks:
- id: c1
  source: '0xe44c83b9e1971a24ec698829297a0c4026b0cef9'
  file: src/insertion_b1200t30_verifier.sol
  line: 479
  has: function verifyProof(
  says: verifyProof is the Groth16 verification entry point
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair
  source: '0xe44c83b9e1971a24ec698829297a0c4026b0cef9'
  file: src/insertion_b1200t30_verifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 518
  says: verifyProof runs the BN254 pairing precompile check
  for:
  - evidence-2
  - justification
  - what
- id: rev
  source: '0xe44c83b9e1971a24ec698829297a0c4026b0cef9'
  file: src/insertion_b1200t30_verifier.sol
  has: revert ProofInvalid();
  line: 466
  says: a failed pairing check reverts
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

This contract checks BN254 Groth16 proofs for World ID batch insertions of 1200 identities with a pairing precompile call. A quantum attacker who recovers the setup trapdoor could make a forged proof that this check accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe44c83b9e1971a24ec698829297a0c4026b0cef9#code) takes an 8-word Groth16 proof and one public input.
- [The pairing check](https://etherscan.io/address/0xe44c83b9e1971a24ec698829297a0c4026b0cef9#code) is a staticcall to the BN254 pairing precompile.

## Reviewer notes

### Mechanism

verifyProof(uint256[8] proof, uint256[1] input) (line 479) computes the public-input point via publicInputMSM. It copies proof points A, B and C to memory and appends the hardcoded delta, alpha, beta and gamma constants. It then runs staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20) (line 518); a failed pairing reverts. Per kev, the group 1 WorldIDIdentityManager calls it through its VerifierLookupTable from registerIdentities. That call is gated to the identity-operator EOA, so a forged insertion proof gives an attacker nothing the operator cannot already do. The verifier is not upgradeable, but the Safe that owns the lookup table can swap it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds.
- Ruled out: Tree updates stay gated by the identity operator.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
