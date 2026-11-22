---
id: 011d21fb-7702-own-key-only
title: "0x011d21fb: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x011d21fb4789a647ab5e4c5934a202cd43a139f1"
  family: "8643c6bdad07a8492bff828aaaa55741"
  copies: 23
  upgradeable: "no"
  rating: LOW
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1587
  last_active: 2026-09-25
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
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd 3, txs_90d 1587."
---

## Summary

Small unverified 7702 delegate; 0x011d... is itself a 7702 account delegating to 0xacde27dd.... Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- cast code 0x011d... at 26438999 = 0xef0100acde27dd...
- disassembly after STATICCALL to 0x01 at pc 923: recovered address masked, ADDRESS, SUB, JUMPI to the fail branch (recovered must equal address(this))

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens, over 23 addresses).
- Activity: 1,587 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
