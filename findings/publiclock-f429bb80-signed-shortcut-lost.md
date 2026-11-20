---
id: publiclock-f429bb80-signed-shortcut-lost
title: "PublicLock: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xf429bb8044bf4b21c65e3ec459eb3010197c6f82"
  family: "77c073c106b2fd6cc03e4a0653ad9e66"
  copies: 122
  name: "PublicLock"
  label: "created by Unlock Protocol: Unlock Contract"
  upgradeable: "no"
  rating: LOW
  value_usd: 13715
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-15
fix:
  layer: offchain
  who_acts: "key owner with code"
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
  note: "Direct path, same party. Value $13715, txs_90d 10 (not rating inputs)."
---

## Summary

Unlock PublicLock: cancelAndRefundFor lets another caller cancel a key with the key owner's signature. A key owner with code can still cancel by itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Unlock cancelAndRefundFor: the key owner signs for another caller; it can cancel itself. Read from source.
- source PublicLock.sol:2014 cancelAndRefund() external → _cancelAndRefund(msg.sender)
- cancelAndRefundFor(_keyOwner,_signature) is the signed shortcut to the same _cancelAndRefund

## Impact and exposure

- Value held at block 26,438,999: $13,715 (ETH and 49 priced tokens, over 122 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

The key owner calls cancelAndRefund() itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
