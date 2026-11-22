---
id: contract-6666db78-blob-kzg
format: 2
title: Blob validium prototype trusts KZG openings a quantum attacker could forge
status: candidate
severity: HIGH
justification: Batch posting relies on KZG blob openings; only an operator redeploy or a protocol change replaces
  them.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  code: decompiled
  code_url: code/0x4942ef72c90b5cbcdfa7a015b27d2976d7f0bcfcf08a3b11e7b5117f21fa64f1.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Redeploy with calldata data availability instead of KZG blob openings, and swap in hash-based verifiers.
evidence_level: bytecode
checks:
- id: sel-postbatch
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: postBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes32))
  says: postBatch entry is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-operator
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: operator()
  says: contract has an operator role
  for:
  - evidence-1
  - justification
  - what
- id: sel-deposit
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: deposit(address)
  says: contract accepts deposits
  for:
  - evidence-2
  - what
- id: sel-claim
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: claimWithdrawal(uint8,uint128)
  says: users claim withdrawals
  for:
  - evidence-2
  - what
- id: sel-forceexit
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: triggerForceExit()
  says: force-exit entry exists
  for:
  - evidence-3
- id: sel-swapverifier
  selector: '0x6666db78b94fce223c618a7082db8ebf77f01a1b'
  fn: swapVerifier(address)
  says: operator can replace the batch verifier
  for:
  - action
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

The contract takes user deposits and withdrawal claims against batches that the operator posts. A quantum attacker who forges a blob opening lets the operator commit to batch data that users cannot read, which locks their deposits.

## Evidence

- [postBatch](https://etherscan.io/address/0x6666db78b94fce223c618a7082db8ebf77f01a1b#code) is the operator's entry for posting batch headers.
- [deposit and claimWithdrawal](https://etherscan.io/address/0x6666db78b94fce223c618a7082db8ebf77f01a1b#code) hold and release user funds.
- [triggerForceExit](https://etherscan.io/address/0x6666db78b94fce223c618a7082db8ebf77f01a1b#code) is the users' exit path.

## Reviewer notes

### Mechanism

Unverified bytecode, an earlier build of the same operator's system. The operator posts batches with postBatch. Per kev's trace, this contract made one call to the point-evaluation precompile (0x0a), consistent with opening the batch's EIP-4844 blob commitment at posting time. Users deposit with deposit(address) and withdraw via claimWithdrawal(uint8,uint128) or triggerForceExit/canForceExit. proveBatch and exitWithProof call SNARK verifiers that the operator can replace with swapVerifier/swapExitVerifier. Posting is operator-only: a non-operator call reverts Unauthorized. A forged KZG opening therefore enables data withholding, which locks deposits, rather than direct theft. How force exits use the posted data is not readable from the bytecode, and no calldata fallback was found.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Outsider batch posting: non-operator postBatch reverts Unauthorized.
- Ruled out: Pairing SNARK verifier risk is a separate finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
