---
id: contract-2d53a516-executor-signer
format: 2
title: gamma.satoris.eth arbitrage executor trusts ECDSA-signed trade orders
status: candidate
severity: MEDIUM
justification: Signed trade instructions rest on ECDSA; the operator must fix it with a new deployment, so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2d53a516ead19f9ff340bf30428a5a7abac7fa49'
  project: gamma-satoris
  code: decompiled
  code_url: code/0xaa68b5728a487fc1b74cbeaad7f5d33ef59b20ec11d5c70989a20a14220cec54.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 11201
impact: funds-loss
action: Retire this executor or redeploy with msg.sender or post-quantum signature authorisation.
evidence_level: bytecode
checks:
- id: code
  code: '0x2d53a516ead19f9ff340bf30428a5a7abac7fa49'
  is: contract
  bytes: 18223
  says: The address holds contract code.
  for:
  - action
  - justification
  - what
- id: sel-owner
  selector: '0x2d53a516ead19f9ff340bf30428a5a7abac7fa49'
  fn: getOwner()
  says: The code has an owner getter.
  for:
  - action
  - evidence-2
  - justification
- id: sel-sweep
  selector: '0x2d53a516ead19f9ff340bf30428a5a7abac7fa49'
  fn: sweep(address[],address)
  says: The code has a token sweep function.
  for:
  - evidence-2
- id: sel-flash
  selector: '0x2d53a516ead19f9ff340bf30428a5a7abac7fa49'
  fn: getFlashToken(address)
  says: The code has a flash-token getter.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (bytecode selectors, sampled trace, on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This flash-loan arbitrage executor takes signed trade instructions and runs them inside a flash loan. A quantum attacker who recovers the signing key could direct its trades, though it holds almost nothing.

## Evidence

- [getFlashToken](https://etherscan.io/address/0x2d53a516ead19f9ff340bf30428a5a7abac7fa49#code) shows the executor works with flash-loaned tokens.
- [getOwner](https://etherscan.io/address/0x2d53a516ead19f9ff340bf30428a5a7abac7fa49#code) names the owner, who controls the executor and can sweep tokens.

## Reviewer notes

### Mechanism

Unverified bytecode. Entry points taking arrays of (bytes,uint256,address,address,uint256,uint256) swap legs start a Morpho flash loan. Per the census, the callback runs in a delegatecalled library containing OpenZeppelin ECDSA, which recovers the signer of the trade instruction. Profit goes to the owner (getOwner). The owner can sweep(address[],address) and transferToken. Who must sign (owner or whitelisted address) is not established from bytecode.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Flash-loaned funds must be repaid in the same transaction, so they are not exposed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
