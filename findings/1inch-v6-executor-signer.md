---
id: 1inch-v6-executor-signer
title: "1inch swap executors 0x0bb7a4fd and 0x27934db9: a quantum attacker who recovers their hard-coded route-signing key can run arbitrary routes through them, which hold only dust"
project: 1inch
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover, p256]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x0bb7a4fdea32910038dec59c20ccae3a6e66b09f"
  implementation: null
  name: unverified swap executor (IAggregationExecutor.execute 0x4b64e492)
  upgradeable: "no"
  admin: "none found: no proxy, no owner(); signer 0x4447696e7878c0fa2c581768f04c3871a9a57b76 is a constant in the bytecode; deployed by 1inch EOA 0x56e44874f624ebde6efcc783efd685f0fbdc6dcf"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1
- address: "0x27934db9cd07e6368900d99047c0b39e2a6664ce"
  implementation: null
  name: unverified swap executor, predecessor of 0x0bb7a4fd (same selectors and signer constant)
  upgradeable: "no"
  admin: "none found: no proxy, no owner(); same hard-coded signer 0x4447696e7878c0fa2c581768f04c3871a9a57b76; deployed by 1inch EOA 0x56e44874f624ebde6efcc783efd685f0fbdc6dcf"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-12-16
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "1inch (deployer EOA 0x56e44874f624ebde6efcc783efd685f0fbdc6dcf, which also owns 1inch's OffchainOracle): deploy executors that verify a post-quantum signature, or none, and route through them"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/1inch-v6-executor-signer/classification.jsonl
  - evidence/1inch-v6-executor-signer/onchain.json
  - evidence/1inch-v6-executor-signer/activity.json
  - evidence/1inch-v6-executor-signer/source-excerpts.md
  - evidence/1inch-v6-executor-signer/review-reads.json
  - evidence/1inch-v6-executor-signer/27934db9-classification.jsonl
  - evidence/1inch-v6-executor-signer/27934db9-onchain.json
  - evidence/1inch-v6-executor-signer/27934db9-activity.json
  - evidence/1inch-v6-executor-signer/27934db9-source-excerpts.md
  - evidence/1inch-v6-executor-signer/27934db9-attribution.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/1inch-v6-executor-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x27934db9
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review21 (finding review), for 0x27934db9
  ref: evidence/1inch-v6-executor-signer/27934db9-attribution.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [1inch-lop-order-sig-scheme-select]
---

## Summary

`0x0bb7a4fd…` is an unverified swap executor that AggregationRouterV6 `swap` calls; its `execute` entry first recovers
an ECDSA signature over the route and compares it with a signer hard-coded in the bytecode (PQ-4). A quantum attacker
who recovers that key can make the executor run any route, but the executor holds only dust between transactions and
user funds are only inside it during a router call the attacker cannot interpose on, so nothing of value can be taken. Its predecessor `0x27934db9…` (June to December 2025) has the same selectors and
the same hard-coded signer, holds USD 0.04 and has not been called since 2025-12-16.
The attribution to 1inch holds: the deploying EOA is the owner of 1inch's OffchainOracle. Rated LOW: a new deployment
by 1inch would fix it (MEDIUM, step 4), lowered by step 5 because the measured exposure is about $0.

## Mechanism

- Call path (CHECKED by trace): user -> `AggregationRouterV6.swap` (`0x07ed2379`) -> router transfers the user's input
  token to the executor -> `executor.execute(address)` (`0x4b64e492`) -> first sub-call is `ecrecover` (precompile
  `0x01`) on a 32-byte digest with a 65-byte signature, returning `0x4447696e7878c0fa2c581768f04c3871a9a57b76`.
- The bytecode compares the recovered address with `PUSH32 0x…4447696e7878c0fa2c581768f04c3871a9a57b76` (masked to 160
  bits), so the signer is a deploy-time constant: it cannot be rotated without a new executor.
- After the check the executor runs the encoded route (Uniswap v4 `unlockCallback`, Curve, 1inch limit orders as taker,
  `processLeftovers`), and the router enforces the user's minimum return.
- Predecessor `0x27934db9…64ce` (18,088 bytes, unverified): the same 46 dispatcher selectors, one call to precompile
  `0x01`, the `"\x19Ethereum Signed Message:\n32"` prefix and the same `PUSH32 0x…4447696e…a57b76` signer constant.
- The precompile trace also shows 3 `p256` (`0x100`) calls by this contract in the year; their purpose was not
  established.

Pattern PQ-4. The source is not verified; [`source-excerpts.md`](../evidence/1inch-v6-executor-signer/source-excerpts.md)
has no excerpt.

## Evidence

- CHECKED (trace of tx `0xa675f17a…`, block 24,700,004, `debug_traceTransaction` callTracer): `execute` -> `ecrecover`
  -> `0x4447696e…`; another executor called in the same transaction (`0x990636ec…`) does not verify a signature
  ([`review-reads.json`](../evidence/1inch-v6-executor-signer/review-reads.json)).
- CHECKED (runtime code at block 26,431,457): the signer appears as a `PUSH32` constant followed by a mask and
  comparison; no EIP-1967 slots, no `owner()`; the signer `0x4447696e…` has no code.
- CHECKED (Blockscout): created 2025-12-16 (tx `0xf01355e6…`) by EOA `0x56e44874…` through Create3Deployer `0xd935a2bb…`.
  The same EOA is `owner()` of 1inch's OffchainOracle `0x00000000000d6ffc74a8feb35af5827bf57f6786` (it called
  `addOracle` there) and administered 1inch KycNFT contracts `0xacce5500…`. Attribution to 1inch: CHECKED through the
  deployer; INFERRED that 1inch operates the executor.
- CHECKED (pipeline read at block 26,431,214): 1 wei ETH and about $0.06 of tokens held.
- CHECKED (precompile trace to March 2026): 110,900 `ecrecover` and 3 `p256` calls in the year
  (`data/report/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 1 transaction touched it: `0xcb67c79a…` (2026-11-15), an EIP-7702 account
  `0xe71e46a8…` sweeping token leftovers out via Multicall3 `aggregate3`; no router swaps through it in the window.
- CHECKED (predecessor `0x27934db9…`): bytecode read 2026-11-17 (signer constant and selector set as above); created
  2025-06-02 (block 22,620,076, tx `0xc4cbdfc6…`) by the same EOA `0x56e44874…` through Create3Deployer `0xd935a2bb…`,
  both listed in 1inch repositories (`1inch/limit-order-protocol`, `1inch/fusion-protocol`, `1inch/cross-chain-swap`);
  no proxy, no `owner()`, USD 0.04 held at block 26,431,214; 67,185 pre-quantum calls in the year to March 2026
  (`txs_y1`); last called 2025-12-16, none in the 30-day window
  ([`27934db9-attribution.json`](../evidence/1inch-v6-executor-signer/27934db9-attribution.json),
  [`27934db9-onchain.json`](../evidence/1inch-v6-executor-signer/27934db9-onchain.json),
  [`27934db9-activity.json`](../evidence/1inch-v6-executor-signer/27934db9-activity.json)).
- INFERRED: the signature binds the route calldata; the exact signed payload was not decoded.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0bb7a4fd…` swap executor | no | $0 (dust) | 2026-11-15 | 1 |
| `0x27934db9…` swap executor (predecessor) | no | $0.04 | 2025-12-16 | 0 |

With the key, an attacker can run arbitrary routes through the executor, which takes only what the executor holds
(dust) and whatever the attacker sends in. Users' tokens enter the executor only inside their own router call and the
router checks the minimum return, so they are not reachable. The signature looks like an access gate keeping others
from using 1inch's executor (INFERRED). The executor appears to have been replaced: the deployer created further
contracts through the same CREATE3 deployer in 2026-01 to 2026-04, and only a sweep touched this one in the last 30 days.

Sibling: `0x64f2095cc11e4726078f4a64d4279c7e7fb7e6ec` (finding `unidentified-64f2095c-signer-key`, same selector set)
was created on 2024-12-24 by a different EOA, `0xa38038f9ac2b3a7b4247804a46c787960e160aed`; this review does not
establish that it is 1inch's.

## Remediation

- 1inch: deploy executors without the signature gate or with a post-quantum one (hash-based or ML-DSA verification, or
  an ERC-7913 verifier), and stop routing through `0x0bb7a4fd…` (and `0x27934db9…`, already out of use). Nothing in this contract can be changed.
- Users: nothing to do; their funds are not exposed through this check.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review09): MEDIUM -> LOW, step 5: measured exposure is the executor's own balance (about $0); the signature gates use of the executor, and users' funds are only inside it during their own router call. Mechanism confirmed by trace (ecrecover on `execute` against a signer hard-coded in the bytecode, so `alternative: sole` stands and key rotation is impossible); 1inch attribution confirmed through the deployer EOA, which owns 1inch's OffchainOracle; status candidate -> confirmed (bytecode plus trace).
- 2026-11-04 (merged from `unidentified-27934db9-signer-key`): `0x27934db9…` classified from bytecode (hand classification pass; `data/curation/out_0.jsonl`); drafted 2026-11-17 by `scripts/15_findings.py` as MEDIUM (step 4).
- 2026-11-17 review (Review21) of `0x27934db9…`: MEDIUM -> LOW, step 5: holds USD 0.04 and replaced (last call 2025-12-16); identified as 1inch through the deployer EOA and Create3Deployer; same selectors and same hard-coded signer `0x4447696e…` as `0x0bb7a4fd…`.
- 2026-11-17 (Review21): merged `unidentified-27934db9-signer-key` into this finding (contract, evidence files `27934db9-*`, sources, History). LOW kept: combined held value about USD 0.10.
