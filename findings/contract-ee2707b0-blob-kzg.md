---
id: contract-ee2707b0-blob-kzg
format: 2
title: Quantum-forged KZG blob openings could lock deposits in this validium
status: candidate
severity: HIGH
justification: Batch posting relies on KZG blob openings; only a protocol change or an operator redeploy with calldata
  data fixes it.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
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
action: Redeploy with batch data posted as calldata, or move to post-quantum data availability once Ethereum offers
  it.
evidence_level: bytecode
checks:
- id: code
  code: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  is: contract
  bytes: 19511
  says: the address holds contract code
  for:
  - justification
- id: sel-postbatch
  selector: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  fn: postBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes32))
  says: postBatch, which takes the batch header with the blob opening, is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-operator
  selector: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  fn: operator()
  says: an operator role exists
  for:
  - evidence-2
  - what
- id: sel-transferop
  selector: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  fn: transferOperator(address)
  says: the operator role can be transferred
  for:
  - evidence-2
- id: sel-deposit
  selector: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  fn: deposit(address)
  says: users can deposit funds
  for:
  - evidence-3
  - what
- id: sel-claim
  selector: '0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42'
  fn: claimWithdrawal(uint8,uint128)
  says: users claim withdrawals from the contract
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
  who: Review17 (bytecode selectors and state reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The contract takes user deposits and lets its operator post batches that are opened against EIP-4844 blob commitments with KZG. With a quantum computer, the operator could forge a KZG opening and commit to batch data nobody can read, locking deposits.

## Evidence

- [postBatch](https://etherscan.io/address/0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42#code) is in the code and takes the batch header carrying the blob opening.
- [operator](https://etherscan.io/address/0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42#code) and transferOperator are in the code. The operator role controls batch posting.
- [deposit and claimWithdrawal](https://etherscan.io/address/0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42#code) are in the code. User funds depend on the posted batches.

## Reviewer notes

### Mechanism

Bytecode only (unverified). postBatch(header, prevHeader) is operator-gated: an eth_call from a non-operator reverts Unauthorized. The contract made exactly one call to the point-evaluation precompile (0x0a), which is consistent with opening the batch's blob commitment when the batch is posted. proveBatch and exitWithProof call batchVerifier()/exitVerifier(), pairing SNARK verifiers that are out of scope here. The operator can replace these verifiers with swapVerifier/swapExitVerifier. A forged KZG opening lets the operator commit to unreadable data, so deposits (deposit, claimWithdrawal, force-exit paths) are locked. No calldata fallback can be read from the bytecode. Whether the opening feeds the proof's public inputs is not established.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Outsiders cannot post batches: postBatch reverts Unauthorized for non-operators.
- Ruled out: SNARK verifier exposure is a separate finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
