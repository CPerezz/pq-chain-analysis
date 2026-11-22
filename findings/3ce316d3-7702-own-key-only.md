---
id: 3ce316d3-7702-own-key-only
title: "0x3ce316d3: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x3ce316d3b3d9a20f3e48e9da4d95892773e29f8e"
  family: "265caf9c5b396e96c7f009ae9b4d356b"
  copies: 267
  upgradeable: "no"
  rating: LOW
  value_usd: 98709
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1298
  last_active: 2026-11-18
  recoveries_14d: 114
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
evidence:
  level: executed
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
  verdict: confirmed
  rating: LOW
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $98,709 (held), txs_90d 1298"
---

## Summary

unnamed 7702 delegate: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Executed: a real transaction reverts once the account holds this logic as real code.
- heimdall decompile of the delegate target 0x14eb85c766a24fa18a2008d9d2ba69344830e938: isValidSignature returns magic on recovered == address(this)
- cast code at 26438999: 0xef010014eb85c766a24fa18a2008d9d2ba69344830e938; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $98,709 (ETH and 49 priced tokens, over 267 addresses).
- Activity: 1,298 transactions called it in the 90 days before that block; last on 2026-11-18.
- 114 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
