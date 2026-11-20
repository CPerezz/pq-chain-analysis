---
id: market-79ef6d28-signed-shortcut-lost
title: "Market: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x79ef6d28c41e47a588e2f2ffb4140eb6d952aec4"
  family: "5f94ff57f53bd06727dc9ffed2129e77"
  name: "Market"
  label: "deployed by Inverse Finance: Deployer 2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1172
  last_active: 2026-11-15
  recoveries_14d: 2
fix:
  layer: offchain
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
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
  note: "Same act stays open to the same party."
---

## Summary

Inverse FiRM Market: borrowOnBehalf/withdrawOnBehalf recover the borrower's signature; a borrower with code loses these delegated paths but keeps borrow(amount) and withdraw(amount) as msg.sender.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Inverse FiRM borrowOnBehalf: the account named `from` must have signed for this caller / Inverse FiRM withdrawOnBehalf: the account named `from` must have signed for this caller. Read from source.
- src/Market.sol: borrow(uint) l.421 and withdraw(uint) l.486 act for msg.sender; borrowOnBehalf l.435 / withdrawOnBehalf l.500 need from's signature.
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/readings/5f94ff57f53bd06727dc9ffed2129e77; study replay: +200 gas.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,172 transactions called it in the 90 days before that block; last on 2026-11-15.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Borrower calls borrow/withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
