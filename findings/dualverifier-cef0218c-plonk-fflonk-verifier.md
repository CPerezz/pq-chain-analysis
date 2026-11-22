---
id: dualverifier-cef0218c-plonk-fflonk-verifier
format: 2
title: ZKsync DualVerifier trusts BN254 SNARK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 setup trapdoor lets false batches verify; MEDIUM as ZKsync governance can repoint chains to
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xcef0218c0c6db0768e48debee26e41b8dade7081#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 37511
impact: funds-loss
action: Repoint chains, via a governance protocol upgrade, to a verifier of the hash-based STARK proof instead of
  the BN254 wrapper.
evidence_level: source
checks:
- id: imm-fflonk
  source: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: FFLONK leg is immutable
  for:
  - action
  - evidence-3
  - what
- id: imm-plonk
  source: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifier public immutable PLONK_VERIFIER;
  line: 21
  says: PLONK leg is immutable
  for:
  - action
  - what
- id: vtype
  source: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: proof's first element selects the verifier
  for:
  - what
- id: route-fflonk
  source: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: type 0 proofs go to the FFLONK verifier
  for:
  - evidence-1
  - justification
  - what
- id: route-plonk
  source: '0xcef0218c0c6db0768e48debee26e41b8dade7081'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: type 1 proofs go to the PLONK verifier
  for:
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This DualVerifier routes batch proofs to an immutable FFLONK or PLONK verifier chosen by the proof's first element. A quantum attacker holding the BN254 setup trapdoor can make a false batch proof pass here for the chains that use it.

## Evidence

- [verify](https://etherscan.io/address/0xcef0218c0c6db0768e48debee26e41b8dade7081#code) sends type 0 proofs to the FFLONK verifier.
- [verify](https://etherscan.io/address/0xcef0218c0c6db0768e48debee26e41b8dade7081#code) sends type 1 proofs to the PLONK verifier.
- [FFLONK_VERIFIER](https://etherscan.io/address/0xcef0218c0c6db0768e48debee26e41b8dade7081#code) is immutable, fixed at deployment.

## Reviewer notes

### Mechanism

When a chain's ExecutorFacet proves a batch it calls getVerifier(), which for chains 388, 325 and 1345 is this DualVerifier. verify() (line 43) reads _proof[0] (line 51); type 0 goes to FFLONK_VERIFIER.verify (line 53), type 1 to PLONK_VERIFIER.verify (line 55); both are immutable (lines 18, 21). The legs check pairings over BN254, so the setup trapdoor lets a quantum attacker forge a proof of a false batch whose L2->L1 logs authorise withdrawals from the shared L1NativeTokenVault, up to the chain's balance. The verifier itself is not upgradeable; governance must point chains at a new verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: No owner or admin can change the legs; they are immutable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
