---
id: contract-27934db9-v6-executor-signer
format: 2
title: Retired 1inch swap executor gates routes on a fixed quantum-forgeable ECDSA key
status: candidate
severity: MEDIUM
justification: Signer is fixed in code, so only a new 1inch deployment fixes it; the executor holds only dust, so
  exposure is low.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x27934db9cd07e6368900d99047c0b39e2a6664ce'
  project: 1inch
  code: decompiled
  code_url: code/0x9c936bc47e7f905e045bdcc0cbd3b513f2d75fb9931565ba9397e934b16846d4.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Stop routing through this executor and deploy executors with a post-quantum signature check, or none.
evidence_level: bytecode
checks:
- id: code
  code: '0x27934db9cd07e6368900d99047c0b39e2a6664ce'
  is: contract
  bytes: 18088
  says: the address holds 18088 bytes of contract code
  for:
  - evidence-2
  - justification
  - what
- id: sel-execute
  selector: '0x27934db9cd07e6368900d99047c0b39e2a6664ce'
  fn: execute(address)
  says: the execute(address) selector is in the executor's dispatcher
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

This contract is an older 1inch swap executor that runs encoded swap routes through its execute entry. A quantum attacker who recovers the route-signing key can run any route through it, reaching only the dust it holds.

## Evidence

- [execute](https://etherscan.io/address/0x27934db9cd07e6368900d99047c0b39e2a6664ce#code) is in the dispatcher, the entry the router calls to run a route.
- The [contract code](https://etherscan.io/address/0x27934db9cd07e6368900d99047c0b39e2a6664ce#code) is deployed at this address and has no admin to rotate a signer.

## Reviewer notes

### Mechanism

Per kev's review, AggregationRouterV6.swap transfers the user's input token to the executor and calls execute(address) (selector 0x4b64e492). The executor first calls ecrecover on an Ethereum-signed-message digest of the route and compares the result with a signer pushed as a PUSH32 constant in the runtime code, so the signer cannot be rotated. It then runs the encoded route (Uniswap v4 unlockCallback, Curve, 1inch limit orders, processLeftovers). The router enforces the user's minimum return. The contract has no proxy and no owner(). It holds about $0 and has had no calls in the 30-day window. A forged signature lets an attacker run routes using only the executor's own balance and whatever the attacker sends in.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: User funds: these tokens sit in the executor only inside the user's own router call, which also checks the minimum return.
- Ruled out: Upgrade or signer rotation: no proxy slots and no owner().

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
