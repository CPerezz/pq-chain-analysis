---
id: paymentcontract-8cf43047-entry-by-own-signature-only
title: "PaymentContract: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x8cf430475ae48587f361eb6057b9eb68b0eb91b3"
  family: "28b2b61a53e41220b2e9d4b47fa77b76"
  name: "PaymentContract"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the subscriber (sign and send from an EOA)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry only: nothing a payer holds sits behind its signature."
---

## Summary

PaymentContract subscription intake: createSubscriptionIfSignatureMatch requires signer == sender == msg.sender, then pulls tokens via transferFrom. A payer with real code cannot sign, so it cannot open a subscription.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: PaymentContract createSubscriptionIfSignatureMatch: the sender (the caller) must sign; a caller with code cannot. Read (function text).
- source/PaymentContract.sol L237-277: the signature only gates opening a new subscription; tokens move only at that moment (transferFrom from msg.sender)
- The contract keeps no per-payer balance or refund; payments are swept by owner-only withdrawAll (L227), which uses no signature
- state.json: 0 ETH at block 26438999; 0 recoveries in the window

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed; payers use an EOA (or a 7702-delegated EOA).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
