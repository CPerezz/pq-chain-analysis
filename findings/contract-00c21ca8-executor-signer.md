---
id: contract-00c21ca8-executor-signer
format: 2
title: gamma.satoris.eth arbitrage executor runs trades on ECDSA-signed instructions
status: candidate
severity: MEDIUM
justification: A quantum-forged ECDSA signature could direct the executor; only the operator can fix it, by a new
  deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00c21ca82d94dade0d5d1ed420a4728f58427d21'
  project: gamma-satoris
  code: decompiled
  code_url: code/0x7dcbeeccb3a461bf2d94ed61cde3729f9293ece4d0eac91a5a70a677cdfe89a5.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Retire this executor or redeploy it with a msg.sender check from a post-quantum account or a post-quantum
  signature.
evidence_level: bytecode
checks:
- id: code
  code: '0x00c21ca82d94dade0d5d1ed420a4728f58427d21'
  is: contract
  bytes: 18538
  says: The address holds contract code.
  for:
  - action
  - justification
  - what
- id: sel-getnonce
  selector: '0x00c21ca82d94dade0d5d1ed420a4728f58427d21'
  fn: getNonce(address)
  says: The executor exposes a per-address nonce getter.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-getowner
  selector: '0x00c21ca82d94dade0d5d1ed420a4728f58427d21'
  fn: getOwner()
  says: The executor exposes an owner getter.
  for:
  - evidence-2
  - what
- id: sel-sweep
  selector: '0x00c21ca82d94dade0d5d1ed420a4728f58427d21'
  fn: sweep(address[],address)
  says: The executor has a sweep function for tokens.
  for:
  - evidence-2
  - justification
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

This flash-loan arbitrage executor is owned by the gamma.satoris.eth operator and runs trade instructions that carry an ECDSA signature. A quantum attacker who recovers the signing key could forge instructions and direct the executor's trades.

## Evidence

- [getNonce](https://etherscan.io/address/0x00c21ca82d94dade0d5d1ed420a4728f58427d21#code) tracks a per-address nonce for signed trade instructions.
- [getOwner](https://etherscan.io/address/0x00c21ca82d94dade0d5d1ed420a4728f58427d21#code) names the owner, who can sweep tokens out of the executor.

## Reviewer notes

### Mechanism

Unverified bytecode. Entry points such as 0xc8512104 start a Morpho flash loan. In the sampled transaction 0x6cada0da…, the callback delegatecalls library 0x878978b5…, whose selectors are onMorphoFlashLoan and 0x677e86e2. That library's bytecode contains the secp256k1 n/2 constant (OpenZeppelin ECDSA). Instruction structs end in a bytes field, read as a signature checked against getNonce(address). Profit goes to the owner, the loan is repaid in the same transaction, and the owner can sweep and transferToken. Who must sign (owner or whitelisted bot) is not established. The executor holds about USD 1 or less.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; owner is an EOA.
- Ruled out: Flash-loaned funds are repaid within the transaction and are not holdings.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
