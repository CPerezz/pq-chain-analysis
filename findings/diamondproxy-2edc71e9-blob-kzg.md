---
id: diamondproxy-2edc71e9-blob-kzg
format: 2
title: Abstract's diamond trusts KZG blob openings that quantum attackers can forge
status: confirmed
severity: LOW
justification: A forged KZG opening hides chain data and locks funds; low because a keccak calldata path exists
  and admins can switch.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  name: DiamondProxy
  project: abstract
  code: verified
  code_url: https://etherscan.io/address/0x2edc71e9991a962c7fe172212d1aa9e50480fbb9#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 14685
impact: funds-locked
action: Commit pubdata as keccak-checked calldata and point the DA validator pair at a calldata-only validator.
evidence_level: source
checks:
- id: c1
  source: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  file: contracts/common/Config.sol
  line: 86
  has: address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
  says: The code fixes the KZG point evaluation precompile 0x0A for blob verification.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  file: contracts/state-transition/StateTransitionManager.sol
  line: 297
  has: function setValidator(uint256 _chainId, address _validator, bool _active) external onlyOwnerOrAdmin {
  says: Owner or admin sets the batch validators for a chain.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

Abstract's diamond accepts batch data availability proven by opening EIP-4844 blob commitments with the KZG point-evaluation precompile. With the KZG setup trapdoor, the batch committer can pass this check with blobs that lack the proven data, leaving bridged funds stuck.

## Evidence

- [Config](https://etherscan.io/address/0x2edc71e9991a962c7fe172212d1aa9e50480fbb9#code) points blob verification at the point evaluation precompile at 0x0A.
- [setValidator](https://etherscan.io/address/0x2edc71e9991a962c7fe172212d1aa9e50480fbb9#code) lets the owner or admin choose which validators commit batches.

## Reviewer notes

### Mechanism

ExecutorFacet of this DiamondProxy hands each committed batch's DA input to the L1 DA validator from getDAValidatorPair (RollupL1DAValidator). For PubdataSource.Blob, _processBlobDA -> _getPublishedBlobCommitment -> _pointEvaluationPrecompile calls 0x0A (Config.sol line 86 constant POINT_EVALUATION_PRECOMPILE_ADDR) and requires BLS_MODULUS back; the opening becomes part of the batch commitment checked by the SNARK. A trapdoor-forged opening lets the validator (set via setValidator, StateTransitionManager line 297) commit batches whose blobs omit the state diffs, so others cannot rebuild state and bridged assets are stuck. PubdataSource.Calldata uses keccak and avoids KZG; the operator picks the source per batch.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft through this check: the validity proof still guards the state transition.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
