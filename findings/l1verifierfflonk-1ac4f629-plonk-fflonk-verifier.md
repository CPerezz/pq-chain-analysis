---
id: l1verifierfflonk-1ac4f629-plonk-fflonk-verifier
format: 2
title: ZKsync fflonk verifier leg trusts a BN254 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Pairing-based proof check breaks with the setup trapdoor; MEDIUM because ZKsync governance can repoint
  chains.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint chains to a post-quantum verifier of the underlying STARK proof through a ZKsync protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1484
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile (7).
  for:
  - evidence-2
  - what
- id: c2
  source: '0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1503
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile (6).
  for:
  - evidence-2
  - what
- id: c4
  source: '0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1559
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile (8).
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

This contract is the fflonk leg of a ZK Stack DualVerifier and checks batch proofs with BN254 point arithmetic and a pairing check. A quantum attacker who recovers the setup trapdoor could make false proofs pass this check.

## Evidence

- [pairing_check](https://etherscan.io/address/0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911#code) calls the BN254 pairing precompile (address 8) to accept a proof.
- [point_mul](https://etherscan.io/address/0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911#code) and point_add use the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The DualVerifier routes proof type 0 to its immutable FFLONK_VERIFIER, this contract. Its verification uses point_mul (line 1484, precompile 7), point_add (line 1503) and point_sub (line 1524, precompile 6), and ends in pairing_check (line 1559, precompile 8) against hard-coded VK_G2 elements from a BN254 trusted setup. With the setup trapdoor, recoverable by a quantum computer, an attacker can build commitments that satisfy the pairing for false public inputs. A batch accepted this way lets its L2-to-L1 logs authorise withdrawals from the shared L1NativeTokenVault, up to the chain's balance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and has no admin.
- Ruled out: The contract itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
