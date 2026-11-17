---
id: bitget-bridge-router-signer
title: "Bitget Wallet bridge router: a quantum-forged co-signer ECDSA key lets an attacker skip the backend's approval of bridge orders, but payouts still need a whitelisted relayer's own funds; the router is paused and unused since August 2025"
project: bitget-wallet
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a"
  implementation: null
  name: BKBridgeRouter
  upgradeable: config-only
  admin: "owner = Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 (3 of 5, read at block 26431214) sets signer, operator, relayers and vault via setAccess; operator EOA 0x5db8606f2927e7173b3cab5a4c512d9f00bbf193 can pause and rescue; no proxy"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-03-05
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "Bitget Wallet: owner Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 keeps the router paused (operator 0x5db8606f2927e7173b3cab5a4c512d9f00bbf193 paused it on 2026-03-05) or deploys a router that verifies a post-quantum co-signature"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/bitget-bridge-router-signer/classification.jsonl
  - evidence/bitget-bridge-router-signer/onchain.json
  - evidence/bitget-bridge-router-signer/activity.json
  - evidence/bitget-bridge-router-signer/source-excerpts.md
  - evidence/bitget-bridge-router-signer/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

BKBridgeRouter, Bitget Wallet's cross-chain bridge entry on Ethereum, requires every bridge call to carry an
ECDSA co-signature from one backend key, `signer` (PQ-4). Forging that key does not release funds by itself: user
`send*` calls move the caller's own tokens into the vault, and every payout (`relay*`, `refund`) is a `transferFrom`
out of the calling relayer's own balance and also requires a whitelisted relayer as `msg.sender`. The router holds
nothing, was last used for bridging on 2025-08-05 and has been paused since 2026-03-05. Rated LOW: step 1 (no use of
the path in 12 months and nothing held).

## Mechanism

- `_checkSigner(nonce, signature, transferId, dstChainId)` (BKBridgeAccess.sol lines 186-198) marks the unordered
  nonce, hashes `(nonce, chainid, this, msg.sender, transferId, dstChainId)`, applies `toEthSignedMessageHash` and
  requires `recover(signature) == signer`.
- Called by `send`, `sendV1`, `sendV2` (BKBridgeRouter.sol lines 33-77, `onlySender`: caller pays from its own
  balance into `vault`) and by `relay`, `relayV1`, `relayV2`, `cancel`, `refund` (lines 79-146, all `onlyRelayer`;
  BKBridgeHandler.sol lines 103-122 and 227-246 pay the receiver with `safeTransferFrom(token, msg.sender, …)`).
- So the co-signature is a second factor next to relayer whitelisting; with only the signer key, an attacker can
  create orders paid with its own funds. Pattern PQ-4; excerpt in
  [`source-excerpts.md`](../evidence/bitget-bridge-router-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source on Sourcify, BKBridgeRouter.sol, BKBridgeAccess.sol, BKBridgeHandler.sol read
  2026-11-17): the lines above; no proxy; `setAccess` (owner) rotates `signer`, `operator`, `vault`, relayers.
- CHECKED (`cast call`, latest block 2026-11-17): `signer()` `0x28d50aee…`, `operator()` `0x5db8606f…`, `owner()` and
  `safe()` Safe `0x9287b8e8…`, `vault()` `0x11235534…` (an EOA holding 586,957 USDT units = 0.59 USDT),
  `vaultToken()` USDT, `paused()` true ([`review-reads.json`](../evidence/bitget-bridge-router-signer/review-reads.json)).
- CHECKED (on-chain read at block 26,431,214): router holds nothing; owner Safe 3 of 5
  ([`onchain.json`](../evidence/bitget-bridge-router-signer/onchain.json)).
- CHECKED (Blockscout transactions, 2026-11-17): last bridge call `relayV1` on 2025-08-05 (block 23,073,140); then
  only the operator's `rescueETH` and `pause` on 2026-03-05 (block 24,588,406); 268,026 transactions in total.
- CHECKED (precompile trace): 101,361 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`),
  all before the August 2025 stop. Xatu saw no transactions in 2026-10-16 to 2026-11-16.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x22ce84a7…` BKBridgeRouter | config-only | $0 | 2026-03-05 (pause; last bridge call 2025-08-05) | 0 |

Nothing sits in the router, and payouts come from relayers' own balances, not from an escrow the signature controls,
so there is no exposure to measure (`held` $0).

## Remediation

- Post-quantum replacement: a co-signature verified with a post-quantum scheme (for example an ERC-7913 verifier) in
  a new router; `setAccess` only rotates the ECDSA key.
- Who acts: owner Safe `0x9287b8e8…` (3 of 5) and operator `0x5db8606f…`; keeping the router paused already closes
  the path. Protocol change: not needed. Users have no action to take.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-05) and nothing held).
- 2026-11-17 review (Review20): LOW kept, step 1: last bridge call 2025-08-05, router paused since 2026-03-05 and holds
  nothing. `impact` funds-loss -> none (payouts are `transferFrom` from a whitelisted relayer, so the co-signature
  alone releases nothing); `last_active` set to the 2026-03-05 pause transaction; `held` $0 recorded.
