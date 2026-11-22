---
id: rollupl1davalidator-72213dfe-blob-kzg
format: 2
title: ZK Stack blob DA validator trusts KZG openings a quantum committer could forge
status: confirmed
severity: LOW
justification: Forged openings only withhold data; operators can switch to calldata DA per batch now, so LOW.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  name: RollupL1DAValidator
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x72213dfe8ca61b0a782970dcfebfb877778f9119#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7857
impact: funds-locked
action: Commit batches with PubdataSource.Calldata, or have chain admins set a calldata-only DA validator pair.
evidence_level: source
checks:
- id: c1
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/RollupL1DAValidator.sol
  line: 118
  has: _pointEvaluationPrecompile(
  says: Blob commitment derivation calls the point-evaluation helper.
  for:
  - what
- id: c3
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/RollupL1DAValidator.sol
  line: 189
  has: (bool success, bytes memory data) = POINT_EVALUATION_PRECOMPILE_ADDR.staticcall(precompileInput);
  says: Helper staticcalls the KZG point-evaluation precompile.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/DAUtils.sol
  line: 34
  has: address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
  says: Precompile address is 0x0A.
  for:
  - evidence-1
  - what
- id: c6
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/RollupL1DAValidator.sol
  line: 204
  has: versionedHash := blobhash(_index)
  says: Blob versioned hash read via blobhash.
  for:
  - what
- id: cd-branch
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/RollupL1DAValidator.sol
  has: if (pubdataSource == uint8(PubdataSource.Blob)) {
  line: 76
  says: Operator input selects the blob/KZG path.
  for:
  - evidence-2
  - justification
- id: cd-calldata
  source: '0x72213dfe8ca61b0a782970dcfebfb877778f9119'
  file: contracts/RollupL1DAValidator.sol
  has: (blobCommitments, ) = _processCalldataDA(blobsProvided, fullPubdataHash, _maxBlobsSupported, l1DaInput[1:]);
  line: 79
  says: checkDA accepts calldata DA without KZG.
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

This validator checks a ZK chain batch's data availability, binding each blob to the batch with a KZG point-evaluation opening. With the KZG trapdoor, a committer could open a blob commitment to unpublished data, so users could not rebuild state. It also accepts calldata without KZG.

## Evidence

- [_pointEvaluationPrecompile](https://etherscan.io/address/0x72213dfe8ca61b0a782970dcfebfb877778f9119#code) calls precompile 0x0a to verify the blob opening.
- [checkDA](https://etherscan.io/address/0x72213dfe8ca61b0a782970dcfebfb877778f9119#code) takes the blob path when the operator's first input byte selects Blob.
- [checkDA](https://etherscan.io/address/0x72213dfe8ca61b0a782970dcfebfb877778f9119#code) also accepts Calldata, checked against the full pubdata hash.

## Reviewer notes

### Mechanism

A chain's diamond calls checkDA (line 58) at batch commit. The first byte of l1DaInput (line 73) selects PubdataSource.Blob (line 76) -> _processBlobDA (line 132) -> _getPublishedBlobCommitment (line 105), which reads blobhash (line 204) and calls _pointEvaluationPrecompile (line 118), staticcalling 0x0A (line 189) and requiring BLS_MODULUS (line 197). publishBlobs (line 29) pre-registers commitments the same way. The resulting blobsOpeningCommitments (line 98) feed the batch commitment covered by the SNARK. A KZG trapdoor lets a forged opening pass for data never published, so data availability breaks but validity does not. Calldata path (line 78-79) uses _processCalldataDA against fullPubdataHash with no KZG.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft: the committer is permissioned and the SNARK still enforces valid state transitions.
- Ruled out: Holds no funds itself; escrow is in the shared L1NativeTokenVault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
