---
id: c99d6e64-7702-own-key-only
title: "0xc99d6e64: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xc99d6e641fe5fc285564943d1869f3c821eea8f4"
  family: "ff3290cb6c5e339eb6d8f63ec0d28722"
  copies: 3
  upgradeable: "no"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1319
  last_active: 2026-11-18
  recoveries_14d: 760
fix:
  layer: account-migration
  who_acts: "the account holder"
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
  verdict: confirmed
  rating: LOW
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd 361, txs_90d 1319."
---

## Summary

Unverified 7702 delegate (same TrustlessProposer shape: EIP-712 domain, signature by the account key). Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: 7702 delegate: the recovered address must be the account itself. Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- heimdall decompile: EIP-712 domain cache check against 0x6f8d170c... then recover compared with address(this); self-call guard require(address(this)==msg.sender)
- row note: executed, a real tx reverts once the account holds this logic as real code

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,319 transactions called it in the 90 days before that block; last on 2026-11-18.
- 760 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
