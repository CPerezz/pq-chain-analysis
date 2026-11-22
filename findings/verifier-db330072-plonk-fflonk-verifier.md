---
id: verifier-db330072-plonk-fflonk-verifier
format: 2
title: ZKsync legacy PLONK Verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 PLONK proofs are forgeable with the setup trapdoor; ZKsync governance can repoint chains to
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  name: Verifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xdb3300726556afa413a11af474a8cfda4d7fc5a5#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint chains to a verifier of the hash-based proof, replacing the BN254 wrapper, via a protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: Proof points are multiplied with the BN254 ecMul precompile.
  for:
  - what
- id: c2
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: Proof points are added with the BN254 ecAdd precompile.
  for:
  - what
- id: c5
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: pointMulAndAddIntoDest calls ecMul.
  for:
  - evidence-2
- id: c6
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: pointMulAndAddIntoDest calls ecAdd.
  for:
  - evidence-2
- id: c7
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: finalPairing calls the BN254 pairing precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c-fail
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  has: 'revertWithMessage(29, "finalPairing: pairing failure")'
  line: 1678
  says: the line or bytes the card cites
  for:
  - evidence-1
- id: c-true
  source: '0xdb3300726556afa413a11af474a8cfda4d7fc5a5'
  file: contracts/state-transition/Verifier.sol
  has: mstore(0, true)
  line: 1705
  says: the line or bytes the card cites
  for:
  - evidence-3
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

This Verifier checks PLONK batch proofs for a ZK Stack chain using BN254 elliptic-curve precompiles and a final pairing check. A quantum attacker who recovers the setup trapdoor could make a false batch proof pass the pairing check.

## Evidence

- [finalPairing](https://etherscan.io/address/0xdb3300726556afa413a11af474a8cfda4d7fc5a5#code) calls the BN254 pairing precompile and reverts on pairing failure.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0xdb3300726556afa413a11af474a8cfda4d7fc5a5#code) combines proof points with ecMul and ecAdd.
- [Verification](https://etherscan.io/address/0xdb3300726556afa413a11af474a8cfda4d7fc5a5#code) returns true once the final pairing passes.

## Reviewer notes

### Mechanism

The verification entry runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703), then returns true (line 1705). Commitments are combined with ecMul (precompile 7, lines 394, 437) and ecAdd (precompile 6, lines 405, 416, 427, 441). finalPairing calls precompile 8 at line 1673 against fixed G2 elements and reverts only if the pairing fails (line 1678). Soundness rests on the BN254 setup trapdoor staying unknown; a quantum attacker who computes it can produce a proof that passes, which would let a false batch be executed by the diamond that calls this verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and has no admin.
- Ruled out: The contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
