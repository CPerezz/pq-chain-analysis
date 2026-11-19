---
id: unidentified-3a362a19-escrow-dispute-party-code
title: "Trade escrows v2 (ETH, ERC-20): under EIP-8151 a party whose address has code can no longer have a dispute resolved"
project: unidentified-3a362a19
status: confirmed
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41"
  implementation: null
  name: ETHEscrowV2 (Sourcify)
  upgradeable: "no"
  admin: "owner and arbitrator 0x8e466cdd9508103c12731e9243e2926a829033c9"
  value_usd: 46205
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 7510
- address: "0xccb2718d633ed28bdf0639134380e2f5b05162b5"
  implementation: null
  name: ERC20EscrowV2 (Sourcify)
  upgradeable: "no"
  admin: "the same"
  value_usd: 151600
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 6038
families: []
fix:
  layer: new-deployment
  who_acts: "the operator 0x8e466cdd…: accept ERC-1271 from a party, or a dispute request by the party's own call"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source and state read, replayed on the exact engine; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 83430300 and ba1ed685"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

A dispute is resolved only with an ECDSA signature of the buyer or seller. Under EIP-8151 a party whose address
has code cannot sign one, so its open trade waits for the other side or for the operator's sweep to itself after 180
days. Immutable; many parties' funds.

## Mechanism

PQ-16. `resolveDispute`: `if (signer != buyer && signer != seller) revert InvalidDisputeSigner();` No ERC-1271
path. `release` and `buyerCancel` (direct calls) are unaffected.

## Evidence

- Verified source (Sourcify) `contracts/ETHEscrowV2.sol` L285–321; `stuckDelaySeconds` 15,552,000 in both.
- Executed (exact engine), the latest resolution of each:
  `0x34e6fa77b3850be07f6a71491781750c6a792c81c1ef5a51e29e02a91aa1b117` (ETH, block 26,437,892) and
  `0x47b43aced505820e8d2224d965b3bdf2c6c8b079b64f7ff0ef7228f210482ea0` (USDT, block 26,437,049): today and EIP-8151
  succeed; with code at the signing party both revert.
- 669 disputes in about two months, 3 % of trades.

## Impact and exposure

12.93 ETH reserved for open trades and about 84 ETH of tokens at block 26,438,999; 13,548 transactions in 30 days.

## Remediation

New deployment. Until then: do not migrate a trading address with open trades.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; proposed rating LOW → CRITICAL: value and activity no longer lower a rating.
