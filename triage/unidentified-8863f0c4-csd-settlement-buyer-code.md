---
id: unidentified-8863f0c4-csd-settlement-buyer-code
title: "CsdUsdcSettlement: under EIP-8151 a buyer that takes code after locking cannot be settled against and is refunded after the seller paid"
project: unidentified-8863f0c4
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x8863f0c477a30bb5a2077c813f42250d7fbefcb9"
  implementation: null
  name: CsdUsdcSettlement (Sourcify)
  upgradeable: "no"
  admin: "none: no owner, no proxy"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-16
  txs_30d: 127
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer (unidentified): check the buyer's signature once, at lock"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source and state read, replayed on the exact engine; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family e2498adf"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The buyer's signature is checked at lock and again at settlement. Under EIP-8151 a buyer that gives its address
code while its USDC is locked cannot be settled against; after expiry anyone refunds it. The seller has already paid
on the other chain and gets nothing. Immutable; at most 30 USDC per trade.

## Mechanism

PQ-15. `settleCsdUsdc` L483: `if (_recover(authHash, authSig) != auth.buyer) revert BadSignature();`.
`refundExpiredLock` pays `auth.buyer` with no signature check.

## Evidence

- Verified source (Sourcify), lines above; state at block 26,438,999: no owner, no proxy, `totalLocked` 0.
- Executed (exact engine): settlement `0x55d7ee240594f01a2339416dc20362814d42e610ad3681f0b24d995ba38690fb`
  (block 26,318,326): today success, equal to the receipt; EIP-8151 success; EIP-8151 with code at buyer
  `0xcfc25c23c39525875908865980d7ef905287a98c`: reverts. A real early release reverts the same way.

## Impact and exposure

Sellers of trades whose buyer migrates mid-lock (25 minutes to about 5 hours). 66 locks, 44 settlements since
creation; 127 transactions in 30 days.

## Remediation

New deployment that settles on the payment proof alone.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; proposed rating LOW → CRITICAL: value and activity no longer lower a rating.
