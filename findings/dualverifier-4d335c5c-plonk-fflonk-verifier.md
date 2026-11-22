---
id: dualverifier-4d335c5c-plonk-fflonk-verifier
format: 2
title: Memento chain's ZKsync verifier accepts proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: BN254 SNARK legs are forgeable with the setup trapdoor; MEDIUM as ZKsync governance can repoint the
  chain's verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x4d335c5c08fec91a39965351abb6e315ad2e9ff3#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Point the chain at a verifier that checks the hash-based STARK proof directly through a protocol upgrade.
evidence_level: source
checks:
- id: route-type
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: The proof type comes from the first proof element.
  for:
  - what
- id: route-fflonk
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: Type 0 is verified by the FFLONK leg.
  for:
  - evidence-1
  - justification
  - what
- id: route-plonk
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: Type 1 is verified by the PLONK leg.
  for:
  - evidence-1
  - justification
  - what
- id: immut-f
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: The FFLONK leg is immutable.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: immut-p
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifier public immutable PLONK_VERIFIER;
  line: 21
  says: The PLONK leg is immutable.
  for:
  - evidence-2
  - what
- id: ctor
  source: '0x4d335c5c08fec91a39965351abb6e315ad2e9ff3'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: constructor(IVerifierV2 _fflonkVerifier, IVerifier _plonkVerifier)
  line: 31
  says: The legs are set only at deployment.
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract routes each batch proof to a fixed FFLONK or PLONK verifier chosen by the proof's first element. Both legs are set at deployment and cannot be changed here, so a quantum attacker holding the setup trapdoor can pass forged batch proofs through it.

## Evidence

- [verify](https://etherscan.io/address/0x4d335c5c08fec91a39965351abb6e315ad2e9ff3#code) sends type-0 proofs to FFLONK_VERIFIER and type-1 proofs to PLONK_VERIFIER.
- [FFLONK_VERIFIER](https://etherscan.io/address/0x4d335c5c08fec91a39965351abb6e315ad2e9ff3#code) and PLONK_VERIFIER are immutable, fixed in the constructor.

## Reviewer notes

### Mechanism

The chain's ExecutorFacet calls getVerifier(), which returns this DualVerifier for chain 51888 (Memento). verify (line 43) reads _proof[0] (line 51). Type 0 goes to FFLONK_VERIFIER.verify (line 53), type 1 to PLONK_VERIFIER.verify (line 55), and other types revert (line 59). _extractProof strips the type element. Both legs are immutable (lines 18, 21) and set in the constructor (lines 32-33). The legs check BN254 pairings, so with the trusted-setup trapdoor a quantum attacker can forge a proof of a false batch. Withdrawals in that batch's L2-to-L1 logs then draw from the shared L1NativeTokenVault, up to the chain's balance. The fix is for ZKsync governance to deploy a new verifier and point the chain at it through a protocol upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract has no owner and no upgrade path; its legs cannot be swapped in place.
- Ruled out: The contract itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
