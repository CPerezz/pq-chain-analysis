---
id: visiontoken-f406f7a9-signed-shortcut-lost
title: "VisionToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xf406f7a9046793267bc276908778b29563323996"
  family: "df08a44881801306116ad01163affc7a"
  copies: 2
  name: "VisionToken"
  label: "APY Vision: VISION Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 95822
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 131
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  rating: LOW
  note: "All three signed acts have direct equivalents: LOW."
---

## Summary

VisionToken (C-Org bonding curve): permit, permitBuy and permitSell check the owner's signature. An owner with code keeps approve, buy and sell by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: C-Org permitBuy: `from` must have signed / C-Org permitSell: `from` must have signed / C-Org permit: the owner named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.
- reading.first.json: buy() and sell() use msg.sender (VisionToken.sol:2008, 2157)
- approve/increaseAllowance by direct call; permit is not blocked while paused, but approve is (not paused at the pinned block)
- approve 0x095ea7b3 in runtime code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $95,822 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 131 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The holder calls approve, buy or sell directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
