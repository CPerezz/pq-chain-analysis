---
id: verifier-06aa7a7b-plonk-fflonk-verifier
format: 2
title: Retired ZKsync PLONK verifier accepts BN254 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Its BN254 pairing check falls to a quantum attacker; ZKsync governance controls which verifier chains
  use.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  name: Verifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: source
checks:
- id: c1
  source: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  file: contracts/state-transition/Verifier.sol
  line: 395
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile call in pointMulIntoDest.
  for:
  - what
- id: c2
  source: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  file: contracts/state-transition/Verifier.sol
  line: 406
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile call in pointAddIntoDest.
  for:
  - what
- id: c5
  source: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  file: contracts/state-transition/Verifier.sol
  line: 438
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul call in pointMulAndAddIntoDest.
  for:
  - evidence-2
  - what
- id: c6
  source: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  file: contracts/state-transition/Verifier.sol
  line: 442
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd call in pointMulAndAddIntoDest.
  for:
  - evidence-2
  - what
- id: c7
  source: '0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66'
  file: contracts/state-transition/Verifier.sol
  line: 1672
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: finalPairing calls the BN254 pairing precompile (address 8).
  for:
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

This is a PLONK verifier for ZKsync batch proofs over BN254. It accepts a proof when the final elliptic-curve pairing check passes. With the setup trapdoor, a quantum attacker can build a proof that this verifier accepts for a false batch.

## Evidence

- [finalPairing](https://etherscan.io/address/0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66#code) calls the BN254 pairing precompile and reverts unless the pairing check succeeds.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66#code) combines proof commitments with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verification entry runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1687-1702), then returns true (line 1704). The proof commitments are combined with ecMul and ecAdd precompile calls (lines 395, 406, 417, 428, 438 and 442). finalPairing (line 1672) checks the pairing with precompile 8 against fixed G2 elements from the setup. Anyone who knows the setup trapdoor, which a quantum computer can recover through discrete logs, can make this pairing check pass for arbitrary public inputs. According to kev's census, Sophon (50104) used this verifier directly until its last call. No registered chain points at it now, so no funds are exposed through it today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No registered chain currently uses this verifier, so it puts no funds at risk now.
- Ruled out: The contract is not upgradeable and has no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
