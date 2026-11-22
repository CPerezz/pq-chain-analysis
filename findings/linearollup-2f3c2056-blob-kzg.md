---
id: linearollup-2f3c2056-blob-kzg
format: 2
title: Rarimo rollup trusts KZG blob checks a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged openings finalize unpublished data; operators can switch to calldata submission.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  name: LineaRollup
  project: rarimo
  code: verified
  code_url: https://etherscan.io/address/0x37139c71a739659a079576a97507d9c1a37b9eb4#code
  proxy_of: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  copies: 1
  upgradeable: 'yes'
  admin: '0xb6b6e80bd32bca86ed5d60ff6889cff5e2d4f63f'
value:
  usd: 3035
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Post data with submitDataAsCalldata and pause BLOB_SUBMISSION until Ethereum offers post-quantum data availability.
evidence_level: source
checks:
- id: c1
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  line: 39
  has: address internal constant POINT_EVALUATION_PRECOMPILE_ADDRESS = address(0x0a);
  says: precompile address is 0x0a
  for:
  - evidence-2
- id: c5
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  line: 281
  has: currentDataHash = blobhash(i);
  says: blob versioned hash read per blob
  for:
  - what
- id: c6
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  line: 431
  has: (bool success, bytes memory returnData) = POINT_EVALUATION_PRECOMPILE_ADDRESS.staticcall(
  says: staticcall to the point-evaluation precompile
  for:
  - evidence-2
  - justification
  - what
- id: n-blob-role
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  has: whenTypeAndGeneralNotPaused(PauseType.BLOB_SUBMISSION) onlyRole(OPERATOR_ROLE)
  line: 247
  says: submitBlobs needs OPERATOR_ROLE and is pausable by BLOB_SUBMISSION type
  for:
  - evidence-1
  - what
- id: n-blob-pause
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  has: PauseType.BLOB_SUBMISSION
  line: 247
  says: blob submission has its own pause type
  for:
  - action
  - evidence-1
  - justification
- id: n-encode
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  has: abi.encodePacked(_currentDataHash, _dataEvaluationPoint, _dataEvaluationClaim, _kzgCommitment, _kzgProof)
  line: 432
  says: precompile input is hash, point, claim, commitment, proof
  for:
  - evidence-2
- id: n-shnarf-claim
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  has: bytes32(blobSubmission.dataEvaluationClaim)
  line: 304
  says: the claimed evaluation goes into the shnarf
  for:
  - evidence-3
  - what
- id: n-calldata-fn
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/interfaces/ILineaRollup.sol
  has: function submitDataAsCalldata(
  line: 331
  says: the contract offers calldata data submission
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The rollup accepts L2 data blobs from operators and checks each blob against its claimed evaluation with the KZG point-evaluation precompile. With the KZG setup trapdoor, a quantum attacker holding the operator role passes this check for data never published, so users cannot rebuild state.

## Evidence

- [submitBlobs](https://etherscan.io/address/0x37139c71a739659a079576a97507d9c1a37b9eb4#code) is gated by OPERATOR_ROLE and the BLOB_SUBMISSION pause type.
- [_verifyPointEvaluation](https://etherscan.io/address/0x37139c71a739659a079576a97507d9c1a37b9eb4#code) staticcalls precompile 0x0a with the blob hash, point, claim, commitment and proof.
- [submitBlobs](https://etherscan.io/address/0x37139c71a739659a079576a97507d9c1a37b9eb4#code) puts the claimed evaluation into the shnarf used at finalization.

## Reviewer notes

### Mechanism

submitBlobs (L243-316, OPERATOR_ROLE, pause type BLOB_SUBMISSION) reads blobhash(i) (L281), derives the evaluation point as keccak(snarkHash, blobhash) (L289), and calls _verifyPointEvaluation (L291-297). That function (L420-452) staticcalls precompile 0x0a (L431-433) and requires a 64-byte return of (4096, BLS modulus). _computeShnarf (L299-305) folds the claimed dataEvaluationClaim into the shnarf, and finalizeBlocks (L461) uses that shnarf for the proof's public input. Someone with the KZG trapdoor can open a commitment to any value, so the shnarf can bind data that was never published. The validity proof still checks execution, so the forgery causes data withholding (funds locked), not theft. submitDataAsCalldata in the same contract binds data by keccak without the precompile and is under a separate pause type.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Direct theft through the opening alone: the validity proof still checks state transitions.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
