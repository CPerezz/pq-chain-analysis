---
id: honkverifier-09ae3b03-honk-verifier
format: 2
title: Aztec HonkVerifier accepts BN254 KZG proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 trusted setup a CRQC can break; only Aztec Governance can fix it, via a new
  rollup version.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x09ae3b0362bcce6e447ce4130c4963630b5a67db'
  name: HonkVerifier
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x09ae3b0362bcce6e447ce4130c4963630b5a67db#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18990
impact: funds-loss
action: Deploy and register a rollup version whose epoch proofs are checked by a hash-based verifier.
evidence_level: source
checks:
- id: c1
  source: '0x09ae3b0362bcce6e447ce4130c4963630b5a67db'
  file: script/deploy/HonkVerifier.sol
  line: 4966
  has: staticcall(gas(), 7, G1_LOCATION, 0x60, ACCUMULATOR_2, 0x40)
  says: VK point scaled with BN254 ecMul precompile (0x07)
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x09ae3b0362bcce6e447ce4130c4963630b5a67db'
  file: script/deploy/HonkVerifier.sol
  line: 4970
  has: staticcall(gas(), 6, ACCUMULATOR, 0x80, ACCUMULATOR, 0x40)
  says: Accumulator updated with BN254 ecAdd precompile (0x06)
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x09ae3b0362bcce6e447ce4130c4963630b5a67db'
  file: script/deploy/HonkVerifier.sol
  line: 4978
  has: staticcall(gas(), 7, G1_LOCATION, 0x60, ACCUMULATOR_2, 0x40)
  says: Second VK point scaled with ecMul
  for:
  - what
- id: c4
  source: '0x09ae3b0362bcce6e447ce4130c4963630b5a67db'
  file: script/deploy/HonkVerifier.sol
  line: 4982
  has: staticcall(gas(), 6, ACCUMULATOR, 0x80, ACCUMULATOR, 0x40)
  says: Second accumulation with ecAdd
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

This contract checks Aztec rollup epoch proofs by combining verification-key points with the BN254 elliptic-curve precompiles. A quantum attacker who recovers the setup trapdoor could make a false epoch proof pass.

## Evidence

- [Verifier code](https://etherscan.io/address/0x09ae3b0362bcce6e447ce4130c4963630b5a67db#code) multiplies verification-key points with the BN254 scalar-multiplication precompile.
- [Verifier code](https://etherscan.io/address/0x09ae3b0362bcce6e447ce4130c4963630b5a67db#code) adds the results into the batch accumulator with the BN254 point-addition precompile.

## Reviewer notes

### Mechanism

Rollup v3's EpochProofLib calls epochProofVerifier.verify(proof, publicInputs) on this HonkVerifier. Inside the assembly verifier, after the Shplemini batching scalars are computed, loadVk() loads the fixed verification key. Each VK commitment (sigma_1..4, id_1..4, ...) is multiplied by its batch scalar via staticcall to precompile 7 (lines 4966, 4978, 4990, 5002) and added to the accumulator via precompile 6 (lines 4970, 4982, 4994, 5006). Per kev's finding, the result then goes to a single BN254 pairing check against the fixed SRS G2 point. Recovering the KZG trapdoor lets an attacker open commitments to false values. Through the escape hatch, a bonded proposer needs no attestations, so a forged proof alone could finalize invented withdrawals from the portals.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Verifier is immutable in the rollup; no setter
- Ruled out: Rollup's own AZTEC and validator stake not reachable via forged proof

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
