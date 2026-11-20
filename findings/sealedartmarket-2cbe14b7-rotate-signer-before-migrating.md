---
id: sealedartmarket-2cbe14b7-rotate-signer-before-migrating
title: "SealedArtMarket: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2cbe14b7f60fbe6a323cba7db56f2d916c137f3c"
  family: "4b5a2c8efebf6a968e3bac90bc071c7f"
  copies: 2
  name: "SealedArtMarket"
  upgradeable: "no"
  rating: LOW
  value_usd: 22196
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18
  last_active: 2026-11-02
fix:
  layer: onchain-config
  who_acts: "owner Safe; users for own bids"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "There is a setter and a live Safe owner, and user funds have a direct exit with a delay. 18 txs in 90d."
---

## Summary

SealedArtMarket: a sequencer and settleSequencer sign withdrawals, cancellations and winners, and users sign bids and offers (raw ecrecover). A sequencer or user key with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a sealed-bid art market: its helper returns the signer (read) and the callers compare it with bidders, sellers and a sequencer; by its function names funds leave by a forced withdrawal with a delay,…. Read by hand.
- SealedArtMarket.sol:75 changeSequencer onlyOwner replaces both sequencer keys
- users exit without a sequencer: startWithdrawal/executePendingWithdrawal (:147-161) and startCancelAuction/executeCancelAuction
- owner 0xe4fa…005c is a Safe, threshold 2, 3 owners

## Impact and exposure

- Value held at block 26,438,999: $22,196 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Owner Safe calls changeSequencer. Users who migrate exit through the forced withdrawal.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
