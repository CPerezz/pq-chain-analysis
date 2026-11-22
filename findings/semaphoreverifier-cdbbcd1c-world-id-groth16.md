---
id: semaphoreverifier-cdbbcd1c-world-id-groth16
format: 2
title: World ID verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged membership proofs pass checks; the owner Safe must swap the verifier; no mainnet consumer
  holds value.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  name: SemaphoreVerifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Swap in a post-quantum proof verifier through the owner Safe's setSemaphoreVerifier on the identity managers.
evidence_level: source
checks:
- id: c1
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 19
  has: function verifyProof(
  says: verifyProof is the entry point for membership proofs.
  for:
  - justification
- id: c2
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 29
  has: p.A = Pairing.G1Point(proof[0], proof[1]);
  says: Proof point A comes from caller input.
  for:
  - what
- id: c3
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 30
  has: p.B = Pairing.G2Point([proof[2], proof[3]], [proof[4], proof[5]]);
  says: Proof point B comes from caller input.
  for:
  - what
- id: c4
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 31
  has: p.C = Pairing.G1Point(proof[6], proof[7]);
  says: Proof point C comes from caller input.
  for:
  - what
- id: c5
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 37
  has: vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[1], merkleTreeRoot));
  says: The Merkle root is a public input.
  for:
  - evidence-1
  - what
- id: c6
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 38
  has: vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[2], nullifierHash));
  says: The nullifier hash is a public input.
  for:
  - evidence-1
  - what
- id: c7
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 39
  has: vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[3], signal));
  says: The signal is a public input.
  for:
  - evidence-1
  - what
- id: c8
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  line: 40
  has: vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[4], externalNullifier));
  says: The external nullifier is a public input.
  for:
  - evidence-1
  - what
- id: c54
  source: '0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5'
  file: lib/semaphore/packages/contracts/contracts/base/SemaphoreVerifier.sol
  has: Pairing.pairingCheck(p1, p2);
  line: 54
  says: Proof acceptance rests on a BN254 Groth16 pairing check.
  for:
  - action
  - evidence-2
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

This contract checks Semaphore membership proofs for World ID groups 0 and 1 with a BN254 Groth16 pairing check over root, nullifier, signal and external nullifier. A quantum attacker who recovers the setup trapdoor could forge a proof that passes for any current root, nullifier and signal.

## Evidence

- [verifyProof](https://etherscan.io/address/0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5#code) binds root, nullifier, signal and external nullifier into the Groth16 input point.
- [verifyProof](https://etherscan.io/address/0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5#code) accepts a proof only if the BN254 pairing check passes.

## Reviewer notes

### Mechanism

WorldIDRouterImplV1.verifyProof routes by groupId to the identity manager, which checks the root and calls this contract's verifyProof (line 19). Lines 29-31 load proof points A, B, C; line 33 selects the depth's verification key; lines 37-40 fold merkleTreeRoot, nullifierHash, signal and externalNullifier into vk_x; line 54 runs Pairing.pairingCheck on e(-A,B)e(alfa1,beta2)e(vk_x,gamma2)e(C,delta2). The function is view and returns nothing; nullifier tracking is the consuming app's job. Anyone holding the setup trapdoor can produce A, B, C satisfying the check for arbitrary public inputs.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No ETH or tokens held by this verifier.
- Ruled out: No mainnet transaction consumed a membership proof through it in the study window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
