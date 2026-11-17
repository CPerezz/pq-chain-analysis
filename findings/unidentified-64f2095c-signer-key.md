---
id: unidentified-64f2095c-signer-key
title: "Unidentified 1inch swap executor: a quantum attacker who derives its plan-signing key can run their own execution plans, but the executor holds nothing and only moves the caller's swap input"
project: unidentified-64f2095c
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: sole
role: auxiliary
contracts:
- address: "0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec"
  implementation: null
  name: unverified 1inch AggregationRouterV6 executor
  upgradeable: "no"
  admin: "unknown (unverified, no proxy); signer 0x4447696e7878c0fa2c581768f04c3871a9a57b76 immutable in bytecode; deployer EOA 0xa38038f9ac2b3a7b4247804a46c787960e160aed"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-06
  txs_30d: 14
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer 0xa38038f9ac2b3a7b4247804a46c787960e160aed (unidentified; possibly 1inch-affiliated): deploy an executor that checks a post-quantum plan signature or only trusts its router"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-64f2095c-signer-key/classification.jsonl
  - evidence/unidentified-64f2095c-signer-key/onchain.json
  - evidence/unidentified-64f2095c-signer-key/activity.json
  - evidence/unidentified-64f2095c-signer-key/source-excerpts.md
  - evidence/unidentified-64f2095c-signer-key/trace-notes.md
  - evidence/unidentified-64f2095c-signer-key/bytecode.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review06 (Claude), 2026-11-17 review
  ref: debug_traceTransaction of two transactions; bytecode reads and Blockscout creator history on 2026-11-17
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

0x64f2095c… is an unverified executor for the 1inch AggregationRouterV6: the router hands it a user's swap input
and calls `execute(address)`, and the executor first checks with `ecrecover` that its execution plan was signed by a
fixed key, 0x4447696e…. A quantum attacker who derives that key can make the executor run any plan, but the executor
holds only dust and handles only the input of the swap that called it, and the router enforces the user's minimum
return. Nothing is exposed. Rated LOW: step 4: the check guards which plans run, and nothing can be taken through it.

## Mechanism

- In traced swaps (tx 0x47f24c58…, 0xe79dfd0d…), router 0x11111112… calls `execute(address)` (0x4b64e492) on the
  executor; the executor's first call is a `STATICCALL` to precompile 0x01 that returns 0x4447696e…, then it runs the
  plan (`patchSequence()`, Uniswap v3 swaps with `uniswapV3SwapCallback`, WETH wrapping, approvals) and returns the
  output to the router.
- 0x4447696e… appears verbatim in the runtime bytecode (immutable) and has no code and nonce 0: it only signs off-chain.
- Other selectors (`swapUniV2()`, `swapSolidly()`, `swapClipper()`, `psmDaiToUsdc()`, `chargeFee()`,
  `callBytes(address,bytes)` and DEX callbacks; see [`bytecode.json`](../evidence/unidentified-64f2095c-signer-key/bytecode.json))
  match an aggregation executor.
- Pattern PQ-4 (one operator key), with nothing pooled behind it.

## Evidence

- CHECKED (debug_traceTransaction via eth.drpc.org; tx hashes from `data/agg/y1_tx_caller.parquet`): the call
  sequence and recovered address ([`trace-notes.md`](../evidence/unidentified-64f2095c-signer-key/trace-notes.md)).
- CHECKED (runtime bytecode, 17,752 bytes, no proxy): contains 0x4447696e…; selector list in `bytecode.json`.
- CHECKED (on-chain read at block 26,431,214): holds 1 wei and token dust (USD 0.000000000000002)
  ([`onchain.json`](../evidence/unidentified-64f2095c-signer-key/onchain.json)).
- CHECKED (`y1_tx_caller.parquet`): 78,609 transactions with an ecrecover from this contract, last at block
  23,824,393 (2025-11-18). CHECKED (Xatu, any function): 14 transactions in 2026-10-16 to 2026-11-16, last on
  2026-11-06 ([`activity.json`](../evidence/unidentified-64f2095c-signer-key/activity.json)).
- Identity (INFERRED, not established): Blockscout creator 0xa38038f9… (EOA) also deployed contracts verified as
  `LeftoverExchanger` and `FeeCollector` (both importing `@1inch/solidity-utils`) and `StepVesting` contracts, and
  0x5141b82f…, which appears beside this executor in 1inch fills. That suggests a 1inch-affiliated or 1inch-integrated
  team but does not identify it, so `project` stays unidentified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x64f2095c…` executor | no | $0 (dust, 2026-11-17) | 2026-11-06 | 14 |

- A forged plan can only spend what the executor holds during the call: the caller's own swap input, which the
  router has transferred for that swap, and the router checks the user's minimum return afterwards.
- Pre-quantum use stopped in 2025-11 according to the yearly data, while the contract is still called.

## Remediation

- Deploy an executor that checks a post-quantum signature for its plans, or that relies on being called by its
  router (the router already protects the user's minimum return).
- Who acts: the deployer 0xa38038f9…. No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review06): MEDIUM -> LOW, step 4: the signature only selects the executor's plan; the executor holds dust and spends only the calling swap's input (impact funds-loss -> none, role core -> auxiliary). Status candidate -> confirmed from transaction traces (1inch router calls execute(address), executor recovers immutable 0x4447696e…).
