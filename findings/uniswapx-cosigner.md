---
id: uniswapx-cosigner
title: "UniswapX V2DutchOrderReactor: a quantum attacker who recovers Uniswap Labs' cosigner key can cosign open orders to fill them at each swapper's worst signed price"
project: uniswap
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x00000011f84b9aa48e5f8aa8b9897600006289be"
  implementation: null
  name: V2DutchOrderReactor
  upgradeable: "no"
  admin: owner 0x1a9c8182c09f50c8318d769245bea52c32be35bc (Uniswap governance Timelock) can only set the protocol fee controller; no upgrade path
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 35213
families: []
fix:
  layer: new-deployment
  who_acts: Uniswap Labs (runs the cosigner and the UniswapX order API) deploys a reactor that verifies the cosigner through ERC-1271 or a post-quantum scheme and routes new orders to it; fillers follow
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/uniswapx-cosigner/classification.jsonl
  - evidence/uniswapx-cosigner/onchain.json
  - evidence/uniswapx-cosigner/activity.json
  - evidence/uniswapx-cosigner/source-excerpts.md
  - evidence/uniswapx-cosigner/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/uniswapx-cosigner/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [uniswap-permit2-code-first]
---

## Summary

Every UniswapX V2 Dutch order must carry a cosignature that the reactor checks with raw `ecrecover` against the
cosigner address in the swapper's order (PQ-4); Uniswap Labs runs that cosigner key. A quantum attacker who recovers
it can cosign any open order with decay times already past and itself as exclusive filler, filling the order at the
swapper's worst signed amounts and keeping the slippage tolerance. It cannot exceed the swapper's signed limits or
touch funds outside open orders. The reactor is immutable; the exposure (users' slippage on open orders, drawn from
their Permit2 approvals) is not measurable. Rated MEDIUM (step 4): fixed by a new reactor deployment that Uniswap
Labs routes orders to.

## Mechanism

`V2DutchOrderReactor._resolve` (lines 43–69) calls `_validateOrder` (lines 111–123), which requires
`ecrecover(keccak256(orderHash || abi.encode(cosignerData)), v, r, s) == order.cosigner`. The cosigner data sets
`decayStartTime`, `decayEndTime`, `exclusiveFiller`, `exclusivityOverrideBps` and optional better start amounts;
`_updateWithCosignerAmounts` (lines 83–104) only lets the cosigner improve the start amounts. Input and outputs then
decay between the cosigned times, and the swapper's tokens move through
`permit2.permitWitnessTransferFrom` with the swapper's own signature (lines 72–81). Forging the cosigner therefore
controls timing and exclusivity, i.e. where on the swapper's signed start-to-end curve the order fills. Pattern PQ-4.
Lines: [`notes.md`](../evidence/uniswapx-cosigner/notes.md),
[`source-excerpts.md`](../evidence/uniswapx-cosigner/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): raw `ecrecover` against `order.cosigner`, no ERC-1271; cosigner amounts
  bounded by the swapper's signed amounts.
- CHECKED (`cast` at block 26,431,621): not a proxy; `owner()` = Uniswap Timelock `0x1a9c8182…` (2-day delay); owner
  functions only set the protocol fee controller (currently zero).
- CHECKED (precompile trace to March 2026): 525,706 transactions with `ecrecover` in the last year; Xatu: 35,213
  transactions called the reactor in 2026-10-16 to 2026-11-16, last 2026-11-16.
- INFERRED: the cosigner key has signed on-chain-visible cosignatures (every filled order carries one), so its public
  key is recoverable from any filled order.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000011…` V2DutchOrderReactor | no | not measurable (swappers' slippage on open orders) | 2026-11-16 | 35,213 |

The reactor holds nothing between fills (dust only). What a forged cosigner can take is, per open order, the gap
between the market price and the swapper's signed end amounts; orders live for seconds to minutes, so the amount at
risk at any time is not measurable from chain state. Swapper funds sit in their own wallets behind Permit2 approvals,
which this check does not release. Other UniswapX reactors and V3 Dutch order reactors were not checked here.

## Remediation

- Uniswap Labs deploys a reactor that verifies the cosignature through ERC-1271 (so the cosigner can be a contract
  with a post-quantum signer) or a post-quantum scheme directly, and routes new orders to it through its order API;
  fillers integrate the new reactor. Orders already signed for this reactor expire within their short deadlines.
- Until then, Uniswap Labs can stop issuing V2 orders and route through a reactor without a cosigner.
- Swappers limit exposure by signing tight slippage; post-quantum swappers already sign through Permit2's ERC-1271
  path. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review07): MEDIUM unchanged (step 4). Confirmed the forged cosigner is bounded by the swapper's
  signed amounts (it takes slippage, not principal); owner identified as Uniswap Timelock (fee controller only).
