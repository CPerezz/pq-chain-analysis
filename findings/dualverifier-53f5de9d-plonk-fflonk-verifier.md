---
id: dualverifier-53f5de9d-plonk-fflonk-verifier
format: 2
title: ZKsync DualVerifier accepts BN254 SNARK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 proofs are forgeable with the setup trapdoor; MEDIUM since ZKsync governance can repoint chains.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x53f5de9de3b2da90633a2c74beb3b9912cdd1579#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Point the chains at a verifier that checks a post-quantum STARK/FRI proof instead of the BN254 wrapper.
evidence_level: source
checks:
- id: src-route
  source: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: Proof type is taken from the first proof element.
  for:
  - evidence-1
  - what
- id: src-ff-call
  source: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: Type 0 returns the FFLONK verifier's result.
  for:
  - evidence-2
  - what
- id: src-pl-call
  source: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: Type 1 returns the PLONK verifier's result.
  for:
  - evidence-2
  - what
- id: src-ff
  source: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: The FFLONK leg is immutable.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: src-pl
  source: '0x53f5de9de3b2da90633a2c74beb3b9912cdd1579'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifier public immutable PLONK_VERIFIER;
  line: 21
  says: The PLONK leg is immutable.
  for:
  - action
  - evidence-3
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

This DualVerifier routes a chain's batch proof by its first element to a fixed FFLONK or PLONK BN254 verifier and returns its result. With the BN254 setup trapdoor, a quantum attacker could make a forged batch proof pass here.

## Evidence

- [verify](https://etherscan.io/address/0x53f5de9de3b2da90633a2c74beb3b9912cdd1579#code) reads the proof type from the first proof element.
- [verify](https://etherscan.io/address/0x53f5de9de3b2da90633a2c74beb3b9912cdd1579#code) returns the FFLONK or PLONK verifier's result for the proof.
- [FFLONK_VERIFIER](https://etherscan.io/address/0x53f5de9de3b2da90633a2c74beb3b9912cdd1579#code) and PLONK_VERIFIER are immutable, set at construction.

## Reviewer notes

### Mechanism

DualVerifier.verify (line 43) reverts on an empty proof, reads verifierType = _proof[0] (line 51), and for type 0 returns FFLONK_VERIFIER.verify (line 53) or for type 1 PLONK_VERIFIER.verify (line 55) on the proof with its first element stripped by _extractProof. Both legs are immutable (lines 18, 21), so the contract itself cannot be fixed; per kev, chain diamonds call it through getVerifier() when executing batches, and ZKsync governance can repoint chains via a protocol upgrade. The legs verify pairing-based BN254 SNARKs, forgeable with the setup trapdoor recoverable by a quantum computer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy, legs are immutable.
- Ruled out: Holds about $0 itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
