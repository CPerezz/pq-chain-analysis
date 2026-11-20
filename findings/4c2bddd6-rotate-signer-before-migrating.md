---
id: 4c2bddd6-rotate-signer-before-migrating
title: "0x4c2bddd6: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4c2bddd6d3bc89940e0f7a4bd3d43825d03a3ce0"
  family: "b4aa3552fb94a8a272fcb9f0f46ca2ac"
  copies: 272
  upgradeable: "no"
  rating: LOW
  value_usd: 298835
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7666
  last_active: 2026-11-18
  recoveries_14d: 631
fix:
  layer: account-migration
  who_acts: "account owner"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Own-key 7702 logic, re-delegation fixes."
---

## Summary

7702 delegate logic: batch signed by the account's own key (== ADDRESS) or a registered session key.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: 7702 account logic: the account's own key, or a session key it can revoke. Bytecode and names.
- own key compared with ADDRESS; session keys managed only when CALLER==ADDRESS (reading.keys)

## Impact and exposure

- Value held at block 26,438,999: $298,835 (ETH and 49 priced tokens, over 272 addresses).
- Activity: 7,666 transactions called it in the 90 days before that block; last on 2026-11-18.
- 631 signature recoveries in the study's two-week trace window.

## Remediation

Account keeps or re-delegates; rotates session keys by self-call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
