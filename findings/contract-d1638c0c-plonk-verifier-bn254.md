---
id: contract-d1638c0c-plonk-verifier-bn254
format: 2
title: Scroll Halo2 verifier accepts BN254 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 KZG proofs are forgeable with the setup trapdoor; MEDIUM since Scroll's owner can register
  a hash-based verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  project: scroll
  code: decompiled
  code_url: code/0x91816743ec15118a4ddacb13c830e56e9f8b28f1c875dfc458a27142a88c9fc8.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a hash-based verifier and have ScrollOwner register it via updateVerifier, retiring BN254 verifiers.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  has: 60055afa
  says: Code calls the modexp precompile.
  for:
  - evidence-2
  - what
- id: b4
  bytecode: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  has: 60075afa
  says: Code calls the BN254 ecmul precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xd1638c0c7bd6bf49d655d855d353ac8b4f949582'
  is: contract
  bytes: 18498
  says: The address holds contract code.
  for:
  - action
  - justification
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

This Scroll proof verifier runs BN254 elliptic-curve arithmetic through the modexp and ecmul precompiles. A quantum attacker who recovers the BN254 setup trapdoor can forge a proof that it accepts.

## Evidence

- [Runtime code](https://etherscan.io/address/0xd1638c0c7bd6bf49d655d855d353ac8b4f949582#code) calls the BN254 multiplication precompile.
- [Runtime code](https://etherscan.io/address/0xd1638c0c7bd6bf49d655d855d353ac8b4f949582#code) calls the modexp precompile at three offsets.

## Reviewer notes

### Mechanism

Bytecode-only contract (fallback dispatch, 18,498 bytes). Kev's finding lists it as the Halo2Verifier registered for version 6 in MultipleVersionRollupVerifier, which ScrollChain consults in verifyBundleProof before finalizing a batch's state and withdraw roots. The runtime code calls modexp (offsets 7598, 13129, 13690) and the BN254 ecmul precompile (offset 15529), consistent with a snark-verifier KZG/Halo2 verifier. With the BN254 trusted-setup trapdoor, a quantum attacker can produce an accepted proof of a false statement.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself
- Ruled out: Not upgradeable
- Ruled out: No calls in the 30-day window
- Ruled out: Whether ScrollChain still finalizes version-6 batches was not checked

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
