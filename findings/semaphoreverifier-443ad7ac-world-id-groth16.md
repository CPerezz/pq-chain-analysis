---
id: semaphoreverifier-443ad7ac-world-id-groth16
format: 2
title: World ID group 2 verifier accepts Groth16 proofs a setup trapdoor could forge
status: confirmed
severity: MEDIUM
justification: A quantum-recovered setup trapdoor forges proofs; the owner Safe must swap this verifier out of the
  group 2 manager.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee'
  name: SemaphoreVerifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace this verifier in the group 2 manager with a post-quantum proof verifier via the owner Safe.
evidence_level: source
checks:
- id: c1
  source: '0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee'
  file: src/SemaphoreVerifier.sol
  line: 552
  has: function verifyProof(uint256[8] calldata proof, uint256[4] calldata input) public view {
  says: verifyProof takes a Groth16 proof and four public inputs, view, no return
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pairing
  source: '0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee'
  file: src/SemaphoreVerifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 588
  says: verifyProof runs the BN254 pairing precompile check
  for:
  - evidence-2
  - justification
  - what
- id: andres
  source: '0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee'
  file: src/SemaphoreVerifier.sol
  has: success := and(success, mload(f))
  line: 590
  says: success requires the pairing output to be 1
  for:
  - evidence-2
- id: consts
  source: '0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee'
  file: src/SemaphoreVerifier.sol
  has: mstore(add(f, 0x180), ALPHA_X)
  line: 574
  says: fixed setup verification-key constants are used
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

This contract checks World ID group 2 Semaphore membership proofs with a BN254 Groth16 pairing check against fixed setup constants. A quantum attacker who recovers the setup trapdoor could forge a proof that passes for any root, nullifier and signal.

## Evidence

- [verifyProof](https://etherscan.io/address/0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee#code) takes a Groth16 proof and four public inputs and returns nothing on success.
- [verifyProof](https://etherscan.io/address/0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee#code) accepts the proof when the BN254 pairing precompile returns 1.

## Reviewer notes

### Mechanism

WorldIDRouter.verifyProof routes group 2 to its WorldIDIdentityManager, which checks the root is recent and calls this SemaphoreVerifier.verifyProof(proof, [root, nullifierHash, signalHash, externalNullifierHash]) (line 552). It computes the public-input MSM (line 553), writes A, B, C and the fixed delta, alpha, beta and gamma verification-key constants to memory (lines 564-585), and calls the BN254 pairing precompile (line 588), requiring output 1 (line 590). Soundness rests on the trusted-setup toxic waste; a discrete-log break recovers it and allows forged proofs. The verifier is not upgradeable but the manager owner can swap it. The contract holds nothing, and the study saw no mainnet call to it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds are held by this verifier.
- Ruled out: No mainnet transaction has called this verifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
