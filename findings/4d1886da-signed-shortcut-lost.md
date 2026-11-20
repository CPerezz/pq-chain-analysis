---
id: 4d1886da-signed-shortcut-lost
title: "0x4d1886da: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x4d1886daf2617cbd9e27abfd0f18a54f04f33c41"
  family: "48ea0cb33070d1554fb60e65d28c66cd"
  copies: 17
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 193990
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-25
fix:
  layer: none
  who_acts: "the bidder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The row note says bids can also be made by deposit, but the reading shows that allocation is signature-only. Taking part dies, and deposits stay withdrawable, so MEDIUM (study said LOW). It is likely moot because the sales ended."
---

## Summary

Unverified token-sale contract (17 copies, 108 ETH): the owner submits each bidder's signed bid (0x33c50420), and the bid is allocated to the recovered address. A bidder with code cannot get a bid allocated; deposits and withdrawals are direct.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: token auctions (17 contracts, 108 ETH): a buyer can bid through a signature as well as by its own deposit, and withdraws by its own call. A buyer with code loses only the signed route. Bytecode and names.
- reading.first.json other_paths: 'Have a bid allocated' path_without_ecrecover = no; only 0x33c50420 writes an allocation
- deposit 0xd0e30db0 and withdraw 0x3ccfd60b use the caller's own entry (direct)
- Reading: the sale window very likely ended (recoveries only in blocks 4,579,824-4,580,307)

## Impact and exposure

- Value held at block 26,438,999: $193,990 (ETH and 49 priced tokens, over 17 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-25.

## Remediation

The bidder withdraws its deposit with 0x3ccfd60b.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
