---
id: semaphoreverifier-4a5aef39-world-id-groth16
format: 2
title: World ID group 3 verifier accepts Groth16 proofs a quantum trapdoor could forge
status: confirmed
severity: MEDIUM
justification: A forged membership proof passes World ID group 3 checks; the owner Safe must swap this verifier,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c'
  name: SemaphoreVerifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace this verifier through the manager's setSemaphoreVerifier with a post-quantum proof verifier.
evidence_level: source
checks:
- id: c1
  source: '0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c'
  file: src/SemaphoreVerifier.sol
  line: 552
  has: function verifyProof(uint256[8] calldata proof, uint256[4] calldata input) public view {
  says: verifyProof takes a Groth16 proof and four public inputs, view, no return value.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pair
  source: '0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c'
  file: src/SemaphoreVerifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 588
  says: The proof is accepted by a BN254 pairing precompile check.
  for:
  - evidence-2
  - justification
  - what
- id: rev
  source: '0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c'
  file: src/SemaphoreVerifier.sol
  has: success := and(success, mload(f))
  line: 590
  says: Acceptance depends only on the pairing result.
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

This contract checks Semaphore membership proofs for World ID group 3 with a BN254 Groth16 pairing check. With the setup trapdoor, a quantum attacker could forge a proof for any root, nullifier and signal that this verifier accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c#code) takes a Groth16 proof and four public inputs and returns nothing on success.
- [verifyProof](https://etherscan.io/address/0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c#code) accepts the proof when the BN254 pairing precompile returns 1.

## Reviewer notes

### Mechanism

SemaphoreVerifier.verifyProof (line 552) computes the public input point via publicInputMSM(input), copies proof points A, B, C from calldata (line 564), writes fixed verifying-key constants DELTA/ALPHA/BETA/GAMMA (lines 570-585), and calls the pairing precompile with staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20) at line 588; success requires the precompile output to be 1 (line 590), otherwise it reverts. Its security rests on the Groth16 trusted-setup toxic waste and BN254 discrete log; a quantum attacker who recovers the trapdoor forges proofs for arbitrary inputs. The group 3 WorldIDIdentityManager calls this verifier from its verifyProof after requireValidRoot; the verifier holds no funds and is swappable by the manager owner.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no value.
- Ruled out: No mainnet transaction called this verifier in the study's window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
