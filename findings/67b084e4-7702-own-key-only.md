---
id: 67b084e4-7702-own-key-only
title: "0x67b084e4: 7702 logic that accepts only the account's own key"
status: not-affected
severity: NONE
patterns: [PQ-20]
impact: none
contracts:
- address: "0x67b084e4654e1d62afa9694b6a626cec5c9ff2bd"
  family: "8134a7f237b953c6ffc2becadb396d37"
  upgradeable: "no"
  rating: NONE
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-10-27
fix:
  layer: none
  who_acts: "nobody: not an EIP-7702 own-key delegate"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Not affected as an EIP-7702 own-key delegate: an EtherDelta-style exchange whose signed orders check the order maker's key; its signed shortcut (makers can still trade and withdraw by direct call) is filed under that root issue's own row."
---

## Summary

EtherDelta-style exchange or vault with real code at its own address. Signed orders recover the maker, so a maker that holds code can no longer have orders filled.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: a token vault (7 ETH): signed allowances and self-signed calls are lost for an account with code; direct deposits and withdrawals remain. Bytecode and names.
- heimdall decompile: trade path `require(ecrecover(...) == arg7)` (the maker), and 0xd55a7bb6 `ecrecover(...) == msg.sender`
- direct paths open: withdraw 0x2e1a7d4d sends to msg.sender from its balance; withdrawToken 0x9e281a98 debits balances[token][msg.sender]; deposit 0xd0e30db0, depositToken 0x338b5dea
- cast code at 26438999: real bytecode (0x6060… legacy solc), not a 7702 delegate

## Impact and exposure

- Value held at block 26,438,999: $12,632 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

Users with code withdraw directly and trade elsewhere.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
