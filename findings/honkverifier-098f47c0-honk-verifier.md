---
id: honkverifier-098f47c0-honk-verifier
format: 2
title: Aztec rollup v2 HonkVerifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Its BN254 KZG check falls to a recovered setup trapdoor; only Aztec Governance can fix it, via a
  new rollup version.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  name: HonkVerifier
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x098f47c00f4df22a8030746eb11378236c24b4bc#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 75201
impact: funds-loss
action: Deploy and register a rollup version whose epoch proofs are checked by a hash-based verifier, then move
  portals to it.
evidence_level: source
checks:
- id: c1
  source: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  file: script/deploy/HonkVerifier.sol
  line: 4914
  has: staticcall(gas(), 7, G1_LOCATION, 0x60, ACCUMULATOR_2, 0x40)
  says: BN254 ecMul precompile call on a verification-key point.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  file: script/deploy/HonkVerifier.sol
  line: 4918
  has: staticcall(gas(), 6, ACCUMULATOR, 0x80, ACCUMULATOR, 0x40)
  says: BN254 ecAdd precompile call into the accumulator.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  file: script/deploy/HonkVerifier.sol
  line: 4926
  has: staticcall(gas(), 7, G1_LOCATION, 0x60, ACCUMULATOR_2, 0x40)
  says: A further BN254 ecMul call on a verification-key point.
  for:
  - evidence-1
- id: c4
  source: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  file: script/deploy/HonkVerifier.sol
  line: 4930
  has: staticcall(gas(), 6, ACCUMULATOR, 0x80, ACCUMULATOR, 0x40)
  says: A further BN254 ecAdd accumulation.
  for:
  - evidence-2
- id: code
  code: '0x098f47c00f4df22a8030746eb11378236c24b4bc'
  is: contract
  bytes: 16996
  says: The address holds deployed contract code.
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
  who: Review00 (verified source of the three verifiers and their rollups; Registry, GSE and portal reads; Xatu
    activity)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks UltraHonk epoch proofs for Aztec rollup v2 with BN254 curve operations. A quantum attacker who recovers the setup trapdoor could make a false epoch proof pass and release portal funds.

## Evidence

- [Verifier](https://etherscan.io/address/0x098f47c00f4df22a8030746eb11378236c24b4bc#code) multiplies verification-key points by proof-derived scalars with the BN254 scalar-multiplication precompile (address 7).
- [Verifier](https://etherscan.io/address/0x098f47c00f4df22a8030746eb11378236c24b4bc#code) accumulates those points with the BN254 point-addition precompile (address 6).

## Reviewer notes

### Mechanism

Rollup v2 submitEpochRootProof -> EpochProofLib (line 441) requires epochProofVerifier.verify(proof, publicInputs). That verifier is this HonkVerifier, which is immutable and set in the rollup constructor. verify (line 1512) runs the Shplemini batch opening: it accumulates VK commitments via ecMul (precompile 7) and ecAdd (precompile 6) at lines 4914-4954 and onward, then checks one BN254 pairing (line 5654) against the fixed SRS G2 point. Recovering the KZG trapdoor lets an attacker forge an opening. During the escape hatch, a bonded designated proposer needs no attestations, so a forged proof finalizes invented L2-to-L1 withdrawals from v2 portals and the FeeJuicePortal.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: Validator stake and rollup-held rewards are not reachable by a forged proof.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
