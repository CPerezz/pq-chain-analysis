---
id: dualverifier-47fc5273-plonk-fflonk-verifier
format: 2
title: ZKsync DualVerifier accepts BN254 SNARK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged batch proofs pass this verifier; ZKsync governance can repoint chains to a new verifier via
  protocol upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 29
impact: funds-loss
action: Repoint chains via protocol upgrade to a verifier that checks the hash-based STARK proof on-chain, without
  a BN254 wrapper.
evidence_level: source
checks:
- id: proof-type
  source: '0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: The proof's first element selects the verifier.
  for:
  - what
- id: route-fflonk
  source: '0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: Type-0 proofs are verified by the fflonk leg.
  for:
  - evidence-1
  - justification
  - what
- id: route-plonk
  source: '0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: Type-1 proofs are verified by the PLONK leg.
  for:
  - evidence-2
  - justification
  - what
- id: immutable-legs
  source: '0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: The fflonk verifier address is immutable.
  for:
  - action
  - evidence-3
  - justification
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

This verifier checks batch proofs for ZK Stack chains by routing them to a fixed fflonk or PLONK verifier chosen by the proof's first element. With the BN254 setup trapdoor, a quantum attacker could make a false batch proof pass here.

## Evidence

- [verify](https://etherscan.io/address/0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e#code) passes type-0 proofs to the fflonk verifier and returns its result.
- [verify](https://etherscan.io/address/0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e#code) passes type-1 proofs to the PLONK verifier and returns its result.
- The [fflonk leg](https://etherscan.io/address/0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e#code) is immutable, set once in the constructor.

## Reviewer notes

### Mechanism

A chain's ExecutorFacet calls the verifier from getVerifier(), here this DualVerifier. verify(_publicInputs, _proof) (line 43) reverts on an empty proof, reads _proof[0] (line 51), and for type 0 returns FFLONK_VERIFIER.verify (line 53) or for type 1 PLONK_VERIFIER.verify (line 55) on the proof minus its first element (_extractProof). Both legs are immutable (lines 18, 21) and check BN254 pairings, so a quantum attacker holding the setup trapdoor can forge a proof accepted here. A false batch's L2-to-L1 logs then authorise withdrawals from the shared L1NativeTokenVault, limited per chain by its balance. The contract has no owner or upgrade path. Fixing it means pointing chains at a new verifier through governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no owner or admin in this contract.
- Ruled out: Holds no funds itself; exposure is through the shared vault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
