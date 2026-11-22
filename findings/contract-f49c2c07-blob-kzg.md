---
id: contract-f49c2c07-blob-kzg
format: 2
title: Blob validium trusts KZG openings; a forged batch could lock deposits
status: candidate
severity: HIGH
justification: Batch posting relies on a KZG blob opening; only a protocol change or operator redeploy with calldata
  DA fixes it.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  code: decompiled
  code_url: code/0x523eda304c4352d23ed2d2c49fb5be60c36149aa5ce801e92c60917949931c10.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Redeploy with batch data posted as calldata instead of blob openings, or adopt post-quantum DA when Ethereum
  offers it.
evidence_level: bytecode
checks:
- id: code
  code: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  is: contract
  bytes: 19511
  says: The address holds contract code.
  for:
  - justification
- id: sel-postbatch
  selector: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  fn: postBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes32))
  says: postBatch selector is in the code.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-operator
  selector: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  fn: operator()
  says: operator() selector is in the code.
  for:
  - evidence-1
  - what
- id: sel-deposit
  selector: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  fn: deposit(address)
  says: deposit(address) selector is in the code.
  for:
  - evidence-2
  - what
- id: sel-claim
  selector: '0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2'
  fn: claimWithdrawal(uint8,uint128)
  says: claimWithdrawal selector is in the code.
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (bytecode selectors and state reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract takes user deposits and lets its operator post batches that are checked against an EIP-4844 blob opening. An operator with a quantum computer could forge the opening and commit to batch data nobody can read, locking deposits.

## Evidence

- [postBatch](https://etherscan.io/address/0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2#code) is the batch-posting entry, alongside an operator() role.
- [deposit](https://etherscan.io/address/0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2#code) and claimWithdrawal take in and pay out user funds.

## Reviewer notes

### Mechanism

Unverified bytecode. postBatch(header, prevHeader) is operator-only (kev's eth_call from a non-operator reverts Unauthorized). Each contract made one call to the point-evaluation precompile 0x0a, consistent with opening the batch's blob commitment at posting. proveBatch/exitWithProof call batchVerifier()/exitVerifier() (BN254 SNARKs, separate finding), swappable via swapVerifier/swapExitVerifier. deposit/depositToken take funds; claimWithdrawal pays out; triggerForceExit/reclaimDeposits exist but their dependence on batch data is not readable. A forged KZG opening lets the operator withhold batch data, locking deposits; outsiders cannot post batches. No calldata fallback found in bytecode.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Outsider forging a batch: postBatch reverts Unauthorized for non-operators (kev's eth_call).
- Ruled out: Proxy upgrade: no proxy found.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
