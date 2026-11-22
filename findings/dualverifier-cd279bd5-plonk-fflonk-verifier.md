---
id: dualverifier-cd279bd5-plonk-fflonk-verifier
format: 2
title: ZKsync Gateway DualVerifier trusts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pre-quantum BN254 proofs gate batches; ZKsync governance can repoint chains to a new verifier, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: funds-loss
action: Repoint chains through a protocol upgrade to a verifier that checks the hash-based STARK proof directly
  on-chain.
evidence_level: source
checks:
- id: src-type
  source: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: Proof type is taken from the first proof element.
  for:
  - what
- id: src-route-fflonk
  source: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: Type-0 proofs are verified by the FFLONK leg.
  for:
  - evidence-1
  - justification
  - what
- id: src-route-plonk
  source: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: Type-1 proofs are verified by the PLONK leg.
  for:
  - evidence-2
  - justification
  - what
- id: src-imm-fflonk
  source: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: FFLONK leg address is immutable.
  for:
  - action
  - evidence-3
  - what
- id: src-imm-plonk
  source: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifier public immutable PLONK_VERIFIER;
  line: 21
  says: PLONK leg address is immutable.
  for:
  - action
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

This DualVerifier accepts a batch proof for the ZKsync Gateway by routing it to a fixed FFLONK or PLONK verifier leg, chosen by the proof's first element. Both legs are set once at deployment, and a quantum attacker holding the BN254 setup trapdoor could make either leg accept a false batch proof.

## Evidence

- [verify](https://etherscan.io/address/0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45#code) passes type-0 proofs to the FFLONK verifier and returns its result.
- [verify](https://etherscan.io/address/0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45#code) passes type-1 proofs to the PLONK verifier.
- [FFLONK_VERIFIER](https://etherscan.io/address/0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45#code) is an immutable set in the constructor.

## Reviewer notes

### Mechanism

ExecutorFacet calls getVerifier().verify(publicInputs, proof). DualVerifier.verify (line 43) rejects empty proofs, reads _proof[0] (line 51), and for type 0 returns FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof)) (line 53); for type 1 it returns PLONK_VERIFIER.verify (line 55); otherwise it reverts. Both leg addresses are immutables set in the constructor (lines 18, 21, 32-33), so this contract cannot be repointed; the fix is a protocol upgrade that changes the chain's verifier. The legs check BN254 pairings, which a holder of the setup trapdoor obtained with a quantum computer could satisfy for false statements.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself.
- Ruled out: Not upgradeable; no owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
