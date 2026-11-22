---
id: escrow-v1-0-b221ac66-own-signature-only-exit
title: "Escrow_v1_0: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xb221ac6622ae5348375d0048dcff0049ebb97d89"
  family: "96eb1434467e389fe616b44c345fab2d"
  copies: 2
  name: "Escrow_v1_0"
  upgradeable: "no"
  rating: HIGH
  value_usd: 354
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "escrow parties (buyer, seller, moderator)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No update path; the users' escrowed funds lock once the needed parties' addresses have code → HIGH. Root issue is closer to parties' own-signature exit than an operator key."
---

## Summary

OpenBazaar Escrow_v1_0: escrowed ETH/tokens leave only via execute(), which needs ecrecover signatures by the escrow's own parties (at least one, and the seller's after the timeout). The parties are fixed when the escrow opens. There is no direct-call release and no ERC-1271.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: OpenBazaar Escrow_v1_0 _verifySignatures: a threshold of the escrow's own parties (buyer, seller, moderator), fixed when the escrow opens. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Escrow_v1_0.sol _verifySignatures: recovered must be isOwner (buyer/seller/moderator set in _addTransaction)
- _verifyTransaction: below threshold, release is allowed only after timeout AND the seller signed; sigV.length 0 can never pass
- no refund, cancel or admin function; transactionCount 122; balance ≈0.196 ETH now

## Impact and exposure

- Value held at block 26,438,999: $354 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Parties execute open escrows before their keys take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-own-signature-only-exit` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
