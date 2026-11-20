---
id: 9da26fc2-7702-own-key-only
title: "0x9da26fc2: 7702 logic that accepts only the account's own key"
status: not-affected
severity: NONE
patterns: [PQ-20]
impact: none
contracts:
- address: "0x9da26fc2e1d6ad9fdd46138906b0104ae68a65d8"
  family: "64e05b93bfd9b853d1c5e76414a96d5d"
  copies: 6233
  upgradeable: "no"
  rating: NONE
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 212838
  last_active: 2026-11-18
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "nobody"
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
  note: "The study's own-key reading (\"user operation recovers to own address\") does not match this code. The traced recoveries ran in other frames. Main reviewer: check where the 2 traced recoveries came from. value $3,790 (held), txs_90d 212838"
---

## Summary

An EOA delegated to 0x8a67b5…, a tx.origin-gated bot (calls USDT and others). That code never calls ecrecover, so nothing it does depends on 0x01.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: an EIP-7702 delegate used by 6,232 accounts: a user operation counts when its signature recovers to the account's own address. A 7702 delegation is exempt from EIP-8151; only real code at the account…. Bytecode and names.
- cast code at 26438999: 0xef0100 8a67b5020ee254ef48e3b6a04927f39baf7e408a; the keccak of the target code equals facts.representative_code.h
- facts.json: n_ec 0, kind "3 seen recovering in the window, no call site in its code"
- heimdall disassemble of the target: no STATICCALL; only CALLs to constant tokens; tx.origin == 0x963819ac… gate

## Impact and exposure

- Value held at block 26,438,999: $3,790 (ETH and 49 priced tokens, over 6,233 addresses).
- Activity: 212,838 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
