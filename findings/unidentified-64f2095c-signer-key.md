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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-64f2095c-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
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
  `callBytes(address,bytes)` and DEX callbacks; see [`bytecode.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-64f2095c-signer-key/bytecode.json))
  match an aggregation executor.
- Pattern PQ-4 (one operator key), with nothing pooled behind it.

## Evidence

- CHECKED (debug_traceTransaction via eth.drpc.org; tx hashes from `data/agg/y1_tx_caller.parquet`): the call
  sequence and recovered address ([`trace-notes.md`](#trace-notes-review06-2026-11-17)).
- CHECKED (runtime bytecode, 17,752 bytes, no proxy): contains 0x4447696e…; selector list in `bytecode.json`.
- CHECKED (on-chain read at block 26,431,214): holds 1 wei and token dust (USD 0.000000000000002)
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-64f2095c-signer-key/onchain.json)).
- CHECKED (`y1_tx_caller.parquet`): 78,609 transactions with an ecrecover from this contract, last at block
  23,824,393 (2025-11-18). CHECKED (Xatu, any function): 14 transactions in 2026-10-16 to 2026-11-16, last on
  2026-11-06 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-64f2095c-signer-key/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review06): MEDIUM -> LOW, step 4: the signature only selects the executor's plan; the executor holds dust and spends only the calling swap's input (impact funds-loss -> none, role core -> auxiliary). Status candidate -> confirmed from transaction traces (1inch router calls execute(address), executor recovers immutable 0x4447696e…).

# Source excerpts: unidentified-64f2095c-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec`

No verified source on Sourcify or Blockscout.

# Trace notes (Review06, 2026-11-17)

debug_traceTransaction (callTracer) via https://eth.drpc.org; tx hashes from data/agg/y1_tx_caller.parquet (caller = this contract, precompile ecrecover).

```
== 0x47f24c58ad7b35d20714adc5231c7fe14061de85b42ef7935c8acdf861a0f843 top input 0x07ed2379 to 0x111111125421ca6dc452d289314280a0f8842a65
  CALL 0x11111112->0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec 0x4b64e492 val=0x1c6bf52634000
    STATICCALL 0x64f2095c->0x0000000000000000000000000000000000000001 0x421871a7 val=None
    CALL 0x64f2095c->0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 0xd0e30db0 val=0x1c6bf52634000
    CALL 0x64f2095c->0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 0x095ea7b3 val=0x0
    CALL 0x64f2095c->0x111111125421ca6dc452d289314280a0f8842a65 0x56a75868 val=0x0
ECRECOVER {"depth": 2, "ecrecover_from_frame": "0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec", "ctx": ["0x11111112", "0x64f2095c"], "input": "0x421871a7006077f03f3009e3111d7135e0c58f7a20a813f906e4fc67a54ba746000000000000000000000000000000000000000000000000000000000000001b4afd9225eaa7800ee55dfb090565feb9946c04a68f73039e7491be569326eaea19d5ec3634836c7c75ac101bfa3ebe24416cc68fae691d7b89c57b12c662e20a", "output": "0x0000000000000000000000004447696e7878c0fa2c581768f04c3871a9a57b76"}
ECRECOVER {"depth": 4, "ecrecover_from_frame": "0x51c72848c68a965f66fa7a88855f9f7784502a7f", "ctx": ["0x11111112", "0x64f2095c", "0x11111112", "0x51c72848"], "input": "0x1feb3d22a82fe6dc1f0d8160cafadead99970294df86158042b662cace8e1a0f000000000000000000000000000000000000000000000000000000000000001b2cc9e0011c56120ccb50ef7209fabdc579fe93e3208292125023004568c840d74fbfcaddaa207b012750bad55ed3ce90e599df68a69fe6dce1d3bc948bc7e0e3", "output": "0x000000000000000000000000a0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8"}
ECRECOVER {"depth": 6, "ecrecover_from_frame": "0x51c72848c68a965f66fa7a88855f9f7784502a7f", "ctx": ["0x11111112", "0x64f2095c", "0x11111112", "0x8b543dff", "0x00000000", "0x51c72848"], "input": "0x6d5943601597800f340844a6f23e6b235c5d9536dd0e66eca672db7ab0bf5f1d000000000000000000000000000000000000000000000000000000000000001b06e52cd4733f0fd11054bfb3b17d61abf4f52e4477dd9871324300dc2d00d3fe2e0f3e35c57cb1db1a215f345352f0e3116e96a7b6704917a6270657b5cbc666", "output": "0x000000000000000000000000a0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8"}
== 0xe79dfd0d69f804a4993569141a24032859bf13d4389a364d465167600b8437c4 top input 0x07ed2379 to 0x111111125421ca6dc452d289314280a0f8842a65
  CALL 0x11111112->0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec 0x4b64e492 val=0x0
    STATICCALL 0x64f2095c->0x0000000000000000000000000000000000000001 0x8f73d42c val=None
    CALL 0x64f2095c->0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec 0x07e5c0d2 val=0x0
      CALL 0x64f2095c->0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec 0xee63c1e5 val=0x0
        CALL 0x64f2095c->0x2a8ff49323d42be0af7a1b2f3005b67da55e0c6b 0x128acb08 val=0x0
          CALL 0x2a8ff493->0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec 0xfa461e33 val=0x0
      CALL 0x64f2095c->0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 0x095ea7b3 val=0x0
      CALL 0x64f2095c->0x111111125421ca6dc452d289314280a0f8842a65 0x56a75868 val=0x0
ECRECOVER {"depth": 2, "ecrecover_from_frame": "0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec", "ctx": ["0x11111112", "0x64f2095c"], "input": "0x8f73d42c27519cd66e2e9ca0fda9e9213c843e15314b83363aa1d14dd2ed596f000000000000000000000000000000000000000000000000000000000000001c0f61d25da02c654419f12480d969b01064e7d935e1d088e4add918f0c3adf4fc1d4b7e3be8b11d4ba5767a2a0d0839028bf8f82ac7a718c639d7d6fc4406476d", "output": "0x0000000000000000000000004447696e7878c0fa2c581768f04c3871a9a57b76"}
ECRECOVER {"depth": 5, "ecrecover_from_frame": "0x51c72848c68a965f66fa7a88855f9f7784502a7f", "ctx": ["0x11111112", "0x64f2095c", "0x64f2095c", "0x11111112", "0x51c72848"], "input": "0x8aa353806894efd7a3a2e5e76118306cd252a9857f3c28459c8a2439dbfb84b3000000000000000000000000000000000000000000000000000000000000001cfe15eeef8cbbfbe3a1e53771d256b0f590ef390ba9f0e1d41196caaa5339635d740b591cb3317d893bdfebf8a90bd69c76b4a3e24a12c1cd127fb4165ea37f10", "output": "0x000000000000000000000000a0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8"}
ECRECOVER {"depth": 7, "ecrecover_from_frame": "0x51c72848c68a965f66fa7a88855f9f7784502a7f", "ctx": ["0x11111112", "0x64f2095c", "0x64f2095c", "0x11111112", "0x8b543dff", "0x00000000", "0x51c72848"], "input": "0x18f45a562f73d2fc58ca6ee08bd140aefcbe5870e6b462b9291bca2fa5125aeb000000000000000000000000000000000000000000000000000000000000001c33c1d386f6cb9931814cc3993ae40098c8d2bfe7e94e15bfccf140c38a65cd0218649ffa993da37cd6f14ac002e349e2e71d0b9df17554385433beef22ffd680", "output": "0x000000000000000000000000a0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8"}
```

- Caller 0x111111125421ca6dc452d289314280a0f8842a65 = 1inch AggregationRouterV6; selector 0x4b64e492 = execute(address), the IAggregationExecutor entry point of the router's swap().
- The contract's first action is ecrecover, returning 0x4447696e7878c0fa2c581768f04c3871a9a57b76 (no code, nonce 0); that address appears verbatim in the runtime bytecode (immutable).
- Other ecrecover calls in these txs come from 0x51c72848c68a965f66fa7a88855f9f7784502a7f (not this contract).
- Last ecrecover by this contract in the yearly data: block 23,824,393 (2025-11-18); 78,609 transactions 2025-03 to 2025-11.
- Deployer 0xa38038f9ac2b3a7b4247804a46c787960e160aed (EOA) also created contracts verified as LeftoverExchanger 0x6ea77f83…, FeeCollector 0x862268aa… (both importing @1inch/solidity-utils) and StepVesting contracts (Blockscout).
