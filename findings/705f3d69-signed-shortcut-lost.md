---
id: 705f3d69-signed-shortcut-lost
title: "0x705f3d69: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x705f3d69eb1d375198f9bdb6b0bd1761ba851cec"
  family: "ce22908a6397ae1c3ad364d532c4bad9"
  copies: 31
  upgradeable: "no"
  rating: LOW
  value_usd: 147613
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-27
fix:
  layer: none
  who_acts: "the borrower"
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
  note: "Same act (borrower withdrawal) is open by direct call: LOW."
---

## Summary

SmartCredit loan contracts (31, 82 ETH): a signed route checks the stored borrower; the borrower can also withdraw assets by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SmartCredit loan contracts (31, 82 ETH): the borrower withdraws by direct call; a signed route compares with the stored borrower. A borrower with code keeps direct withdrawal. Bytecode and names.
- EIP-1167 clone of 0xc46507ce7b32e4243ae39644f4b2fe42e6d9c46f (runtime code at block 26438999)
- heimdall decompile (scratch L025/sc) line 169-171: withdrawAsset(address,uint256) requires msg.sender == stored borrower
- Row note: a borrower with code keeps direct withdrawal

## Impact and exposure

- Value held at block 26,438,999: $147,613 (ETH and 49 priced tokens, over 31 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-27.

## Remediation

The borrower calls withdrawAsset directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
