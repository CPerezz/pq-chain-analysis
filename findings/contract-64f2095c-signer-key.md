---
id: contract-64f2095c-signer-key
format: 2
title: Swap executor trusts an ECDSA plan-signing key a quantum attacker could derive
status: candidate
severity: LOW
justification: The key selects which plans run and the executor holds dust, so LOW; the deployer fixes it by redeploying.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec'
  code: decompiled
  code_url: code/0xda0657a2aed662768b54f6563002b813e3e369e9dd0d3ee97fc6bf97b75264b6.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 14
impact: liveness
action: Deploy an executor that checks a post-quantum plan signature or only trusts its router.
evidence_level: bytecode
checks:
- id: code
  code: '0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec'
  is: contract
  bytes: 17752
  says: the address holds 17,752 bytes of contract code
  for:
  - justification
  - what
- id: sel-execute
  selector: '0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec'
  fn: execute(address)
  says: execute(address) selector is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-callbytes
  selector: '0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec'
  fn: callBytes(address,bytes)
  says: callBytes(address,bytes) selector is in the code
  for:
  - evidence-2
  - what
- id: sel-univ3cb
  selector: '0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec'
  fn: uniswapV3SwapCallback(int256,int256,bytes)
  says: uniswapV3SwapCallback selector is in the code
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This unverified executor is called by the 1inch router through execute(address) and runs a swap plan after checking with ecrecover that a fixed key signed it. A quantum attacker who derives that key can make the executor run their own plans; they work on what the executor holds during the call.

## Evidence

- [execute(address)](https://etherscan.io/address/0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec#code) is the entry the router calls before the plan's signature is recovered.
- [callBytes(address,bytes)](https://etherscan.io/address/0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec#code) and DEX callbacks let a signed plan make arbitrary calls and swaps.

## Reviewer notes

### Mechanism

Traced swaps show this flow. Router 0x11111112… calls execute(address) (0x4b64e492) on the executor. The executor's first action is a STATICCALL to precompile 0x01, which recovers the immutable signer 0x4447696e…. That signer has no code and only signs off-chain. The executor then runs the plan: WETH deposit, approve, uniswapV3SwapCallback swaps and callBytes. It returns the output to the router, and the router enforces the user's minimum return. If the key is derived, a forged plan can only move what the executor holds during the call: the calling swap's input. At rest the executor holds dust.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Pooled funds at risk: executor holds dust
- Ruled out: Upgrade path: no proxy, no admin read

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
