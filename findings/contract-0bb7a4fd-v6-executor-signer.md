---
id: contract-0bb7a4fd-v6-executor-signer
format: 2
title: 1inch swap executor gates routes on a fixed, quantum-forgeable ECDSA key
status: candidate
severity: MEDIUM
justification: The signer is fixed at deploy time, so only a new 1inch deployment fixes it; the executor holds only
  dust.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f'
  project: 1inch
  code: decompiled
  code_url: code/0x58e42f6c5393260bc8315fae7d1be3b64ddb26046c2d96478bc8ecbfb5158665.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: funds-loss
action: Deploy executors with a post-quantum signature check or no signature gate, and route swaps through them.
evidence_level: bytecode
checks:
- id: code
  code: '0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f'
  is: contract
  bytes: 19207
  says: The address holds 19,207 bytes of contract code.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-execute
  selector: '0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f'
  fn: execute(address)
  says: The execute(address) selector is in the runtime code.
  for:
  - action
  - evidence-1
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
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x27934db9
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review21 (finding review), for 0x27934db9
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This executor runs 1inch swap routes through its execute entry, which the 1inch router calls during a swap. A quantum attacker who recovers the route-signing key can run any route through it, but it holds only dust.

## Evidence

- [execute(address)](https://etherscan.io/address/0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f#code) is a function in the executor's runtime code.
- [Runtime code](https://etherscan.io/address/0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f#code) is deployed at this address; the source is unverified.

## Reviewer notes

### Mechanism

User calls AggregationRouterV6.swap (0x07ed2379). The router transfers the input token to the executor and calls executor.execute(address) (0x4b64e492). The executor's first sub-call is ecrecover (precompile 0x01) on a 32-byte digest with a 65-byte signature. It compares the recovered address with a PUSH32 constant 0x4447696e7878c0fa2c581768f04c3871a9a57b76, masked to 160 bits. The signer is therefore a deploy-time constant and cannot be rotated. After the check, the executor runs the encoded route (Uniswap v4 unlockCallback, Curve, 1inch limit orders, processLeftovers). The router enforces the user's minimum return. The contract has no proxy slots and no owner(). The predecessor 0x27934db9 has the same signer constant and selector set.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users' funds: they enter the executor only inside their own router call, and the router checks the minimum return.
- Ruled out: Upgrade or rotation of the signer: no proxy and no owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
