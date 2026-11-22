---
id: eraverifierfflonk-8470d6b3-plonk-fflonk-verifier
format: 2
title: ZKsync EraVerifierFflonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged batch proofs over BN254 release chain funds; MEDIUM because ZKsync governance can repoint
  verifiers by upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9'
  name: EraVerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 25538
impact: funds-loss
action: Replace the BN254 fflonk wrapper with an on-chain hash-based STARK verifier and repoint chains via a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile to verify the proof.
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

This contract is the fflonk leg of a ZK Stack DualVerifier and checks batch proofs with BN254 elliptic-curve operations and a pairing check. With the setup trapdoor, a quantum attacker could forge a proof that this pairing check accepts, for a false batch on the chains that use it.

## Evidence

- [pairing_check](https://etherscan.io/address/0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9#code) decides proof validity with the BN254 pairing precompile (address 8).
- [point_mul](https://etherscan.io/address/0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9#code) and point_add use the BN254 ecMul and ecAdd precompiles (addresses 7 and 6).

## Reviewer notes

### Mechanism

The DualVerifier that the ExecutorFacet calls routes type-0 proofs to this fflonk leg. The leg builds a Fiat-Shamir transcript with keccak (update_transcript, get_challenge, lines 1471-1489). It combines commitments with point_mul (ecMul precompile 7, line 1501), point_add and point_sub (ecAdd precompile 6, lines 1520 and 1541). It accepts the proof when pairing_check (precompile 8, line 1576) passes against the VK_G2 elements. Those G2 elements come from a BN254 KZG trusted setup. A quantum attacker who recovers the setup trapdoor through discrete logs can make commitments that open to arbitrary values. The pairing check then accepts a false batch. The batch's L2→L1 logs authorise withdrawals from the shared L1NativeTokenVault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds itself.
- Ruled out: The inner Boojum STARK is hash-based; only this BN254 wrapper is pre-quantum.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
