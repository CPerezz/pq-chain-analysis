---
id: exchange-2a0c0dbe-signed-shortcut-lost
title: "Exchange: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x2a0c0dbecc7e4d658f48e01e3fa353f44050c208"
  family: "51a9b1614ae411e02e95ed2c5fc029f7"
  copies: 5
  name: "Exchange"
  label: "IDEX"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 28325637
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 410
  last_active: 2026-11-16
fix:
  layer: none
  who_acts: "the user (direct withdraw)"
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
  note: "adminWithdraw has a direct path (withdraw), but trade has none for either side: trading dies for such users, funds stay withdrawable → MEDIUM. Rated LOW by the study; flagged."
---

## Summary

IDEX v1 Exchange: the admin submits trades and withdrawals signed by users; EIP-8151 makes a code-holding user's signatures fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: IDEX v1 adminWithdraw: the admin submits, the user named must have signed / IDEX v1 trade: the admin submits; maker and taker must each have signed. Read from source.
- Exchange.sol:110 withdraw(token,amount) is a direct call by the user, allowed once block.number - lastActiveTransaction >= inactivityReleasePeriod
- inactivityReleasePeriod() = 240 blocks at block 26438999 (cast call)
- Exchange.sol:145 trade is onlyAdmin and needs both maker and taker signatures; there is no on-chain order path

## Impact and exposure

- Value held at block 26,438,999: $28.3M (ETH and 49 priced tokens, over 5 addresses).
- Activity: 410 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Users with code withdraw directly after 240 blocks of inactivity; they cannot trade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
