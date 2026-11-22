---
id: l1verifierfflonk-e3743181-plonk-fflonk-verifier
format: 2
title: ZKsync L1VerifierFflonk checks BN254 proofs that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based fflonk proofs fall to a quantum attacker; ZKsync governance can repoint chains to a
  new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3743181a4b0a0c1260826105c6bba4b6e18d79d'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xe3743181a4b0a0c1260826105c6bba4b6e18d79d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 fflonk wrapper with a hash-based STARK verifier and repoint chains to it through a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xe3743181a4b0a0c1260826105c6bba4b6e18d79d'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile (7).
  for:
  - evidence-2
  - what
- id: c2
  source: '0xe3743181a4b0a0c1260826105c6bba4b6e18d79d'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile (6).
  for:
  - evidence-2
  - what
- id: c4
  source: '0xe3743181a4b0a0c1260826105c6bba4b6e18d79d'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile (8) to accept the proof.
  for:
  - action
  - evidence-1
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies fflonk proofs of ZK Stack batches over BN254 with the elliptic-curve add, multiply and pairing precompiles. With the setup trapdoor, a quantum attacker can make a false batch proof pass the final pairing check.

## Evidence

- [pairing_check](https://etherscan.io/address/0xe3743181a4b0a0c1260826105c6bba4b6e18d79d#code) accepts the proof through the BN254 pairing precompile (address 8).
- [point_mul and point_add](https://etherscan.io/address/0xe3743181a4b0a0c1260826105c6bba4b6e18d79d#code) combine commitments with the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

This is an fflonk leg of a ZKsync DualVerifier. It is not upgradeable and has no admin. Verification folds the proof commitments with point_mul (line 1501, ecMul precompile 7) and with point_add/point_sub (lines 1520 and 1541, ecAdd precompile 6). It then accepts or rejects in pairing_check (line 1576, ecPairing precompile 8) against the VK_G2 elements from the BN254 KZG setup. Anyone who knows the setup trapdoor, which a quantum computer can recover by solving the discrete log, can open commitments arbitrarily and forge a passing proof. Per kev's census this leg is retired. Lens (232) used it through DualVerifier 0x4f06ef57, and no registered chain points at it now, so nothing is exposed through this address. Live verifiers share the same construction and are repointed by ZKsync governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy or admin slot
- Ruled out: Holds no funds itself

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
