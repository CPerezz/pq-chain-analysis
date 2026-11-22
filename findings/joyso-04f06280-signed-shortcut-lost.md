---
id: joyso-04f06280-signed-shortcut-lost
title: "Joyso: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x04f062809b244e37e7fdc21d9409469c989c2342"
  family: "2691ffa8a72fca5216f1479b07389497"
  copies: 2
  name: "Joyso"
  label: "Joyso"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 150139
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "the user"
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
  note: "Exit is direct, but trading dies, so MEDIUM if a signed-only trade counts as a dead function. The reading said LOW. Note: ETH goes out with transfer (2300 gas)."
---

## Summary

Joyso exchange: admins relay orders, withdrawals, cancels and migrations signed by the user. A user with code can no longer trade but can exit by lockMe and then withdraw.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Joyso: the admin submits orders and withdrawals signed by the user; a user can also lock itself and withdraw by its own call after the lock period (withdraw and lockMe read). Read by hand.
- reading.first.json: lockMe() and withdraw() use msg.sender (Joyso.sol:247, 225); lockPeriod 30 days
- depositEther/depositToken direct
- Trading has no on-chain order path

## Impact and exposure

- Value held at block 26,438,999: $150,139 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The user calls lockMe, waits the lock period and calls withdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
