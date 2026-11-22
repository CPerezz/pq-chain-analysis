---
id: l1verifierfflonk-d324a7c8-plonk-fflonk-verifier
format: 2
title: ZKsync fflonk verifier trusts BN254 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: A forged batch proof releases chain funds from the vault; ZKsync governance can repoint the verifier
  by upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd324a7c8556a059371b207fb96fd77be24e2042c'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xd324a7c8556a059371b207fb96fd77be24e2042c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with an on-chain STARK/FRI verifier and repoint chains to it through a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xd324a7c8556a059371b207fb96fd77be24e2042c'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xd324a7c8556a059371b207fb96fd77be24e2042c'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0xd324a7c8556a059371b207fb96fd77be24e2042c'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile.
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

This contract checks fflonk batch proofs for a ZK Stack chain using BN254 curve operations and a pairing check. With the BN254 setup trapdoor, a quantum attacker can make a false batch pass this check, including withdrawals that never happened.

## Evidence

- [pairing_check](https://etherscan.io/address/0xd324a7c8556a059371b207fb96fd77be24e2042c#code) decides validity with the BN254 pairing precompile (address 8).
- [point_mul and point_add](https://etherscan.io/address/0xd324a7c8556a059371b207fb96fd77be24e2042c#code) combine the proof commitments with the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

L1VerifierFflonk is the fflonk leg (proof type 0) of DualVerifier 0x4d335c5c, which serves chain 51888 (Memento). The chain diamond's ExecutorFacet calls the DualVerifier, which routes to this leg. The leg checks the proof in Yul. It builds a keccak transcript with update_transcript and get_challenge. It combines points with point_mul (staticcall to precompile 7, line 1501) and point_add and point_sub (precompile 6, lines 1520 and 1541). It computes inverses with modexp (precompile 5). It ends with pairing_check (precompile 8, line 1576) against the hard-coded VK_G2 elements. Anyone who knows the setup trapdoor, which a quantum computer can derive from the public G2 elements, can produce commitments that pass this pairing check for false public inputs. A verified batch's L2-to-L1 logs authorise withdrawals from the shared L1NativeTokenVault, up to the chain's balance. The leg is not upgradeable. Governance can repoint chains to a new verifier through a protocol upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and has no admin.
- Ruled out: The contract itself holds no funds; the exposed funds sit in the shared vault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
