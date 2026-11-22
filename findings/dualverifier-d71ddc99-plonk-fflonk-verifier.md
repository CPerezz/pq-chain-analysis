---
id: dualverifier-d71ddc99-plonk-fflonk-verifier
format: 2
title: ZKsync DualVerifier accepts BN254 SNARK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Its proof legs rest on a BN254 trapdoor; ZKsync governance can repoint chains to a new verifier,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd71ddc9956781bf07dbfb9fca891f971dbe9868a'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xd71ddc9956781bf07dbfb9fca891f971dbe9868a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint chains to a post-quantum (STARK/FRI) verifier through a ZKsync protocol upgrade.
evidence_level: source
checks:
- id: src-route
  source: '0xd71ddc9956781bf07dbfb9fca891f971dbe9868a'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: uint256 verifierType = _proof[0];
  line: 51
  says: Proof type comes from the first proof element.
  for:
  - evidence-1
  - what
- id: src-fflonk
  source: '0xd71ddc9956781bf07dbfb9fca891f971dbe9868a'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return FFLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 53
  says: Type 0 proofs are verified by the FFLONK leg.
  for:
  - evidence-2
  - justification
  - what
- id: src-plonk
  source: '0xd71ddc9956781bf07dbfb9fca891f971dbe9868a'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: return PLONK_VERIFIER.verify(_publicInputs, _extractProof(_proof));
  line: 55
  says: Type 1 proofs are verified by the PLONK leg.
  for:
  - evidence-3
  - justification
  - what
- id: src-immut
  source: '0xd71ddc9956781bf07dbfb9fca891f971dbe9868a'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  has: IVerifierV2 public immutable FFLONK_VERIFIER;
  line: 18
  says: The FFLONK leg address is immutable.
  for:
  - action
  - evidence-3
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

This DualVerifier routes ZK Stack batch proofs to a fixed FFLONK or PLONK verifier, chosen by the proof's first element. With the BN254 setup trapdoor, a quantum attacker could make it accept a false batch proof for the chains that use it.

## Evidence

- [verify](https://etherscan.io/address/0xd71ddc9956781bf07dbfb9fca891f971dbe9868a#code) reads _proof[0] to pick the verifier type.
- [verify](https://etherscan.io/address/0xd71ddc9956781bf07dbfb9fca891f971dbe9868a#code) returns FFLONK_VERIFIER.verify for type 0.
- [verify](https://etherscan.io/address/0xd71ddc9956781bf07dbfb9fca891f971dbe9868a#code) returns PLONK_VERIFIER.verify for type 1; both legs are immutable.

## Reviewer notes

### Mechanism

ExecutorFacet of each chain's diamond calls getVerifier() and then verify(_publicInputs, _proof) on this contract (line 43). Line 51 takes verifierType = _proof[0]. Type 0 forwards to the immutable FFLONK_VERIFIER (line 53), and type 1 forwards to the immutable PLONK_VERIFIER (line 55). Both calls use _extractProof, which strips the first element. The immutables are set once in the constructor (lines 18, 21, 32-33), so this contract has no setter. Its legs check pairings over BN254. The finding says chains 1217 and 375 use this contract. A forged wrapper proof would let a false batch's withdrawal logs pass to the shared L1 vault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and has no owner; the fix is repointing at the chain-type-manager level.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
