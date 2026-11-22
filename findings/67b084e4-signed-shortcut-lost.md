---
id: 67b084e4-signed-shortcut-lost
title: "0x67b084e4: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x67b084e4654e1d62afa9694b6a626cec5c9ff2bd"
  family: "8134a7f237b953c6ffc2becadb396d37"
  upgradeable: "no"
  rating: LOW
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-10-27
fix:
  layer: offchain
  who_acts: "trader with code"
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
  note: "The same act stays open by a direct call; read from the decompile, so less certain than source. Value $12632, txs_90d 9 (not rating inputs)."
---

## Summary

An unverified exchange vault (an EtherDelta variant, 7 ETH): signed orders and cancels fail for an account with code; the account can still place orders on chain, and deposits and withdrawals are direct.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a token vault (7 ETH): signed allowances and self-signed calls are lost for an account with code; direct deposits and withdrawals remain. Bytecode and names.
- heimdall decompile: 0xb4980620 writes orders[msg.sender][hash]=1 (on-chain order); the cancel 0xd55a7bb6 accepts the on-chain order without ecrecover; the trade 0x4ce56e26 checks ecrecover only when there is no on-chain order
- deposit() 0xd0e30db0, depositToken 0x338b5dea, withdraw(uint256) 0x2e1a7d4d, withdrawToken 0x9e281a98 use msg.sender

## Impact and exposure

- Value held at block 26,438,999: $12,632 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

Use on-chain orders and direct withdrawals.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
