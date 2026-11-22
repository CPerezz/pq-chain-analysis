---
id: 05c40a5b-7702-own-key-only
title: "0x05c40a5b: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x05c40a5ba92a4d4efa11f81b7beaae56f91ba3c2"
  family: "0375f81a3a50788ea81bf65b524ab6a6"
  copies: 81
  upgradeable: "no"
  rating: LOW
  value_usd: 244518
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 125
  last_active: 2026-11-17
  recoveries_14d: 17
fix:
  layer: account-migration
  who_acts: "each account owner"
evidence:
  level: source-read
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
  note: "The relayers are hard-coded, but the account can always run the batch itself"
---

## Summary

unnamed 7702 delegate (81 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Bytecode: batch selector 0x6171d1c9 recovers (pc 4780) and must equal the account; submitted by one of two hard-coded relayers, or the account calls itself/source (dossier 0375f81a3a50788ea81bf65b524ab6a6)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Activity (measured): txs_90d 125, last_active 2026-11-17, value_usd 244518

## Impact and exposure

- Value held at block 26,438,999: $244,518 (ETH and 49 priced tokens, over 81 addresses).
- Activity: 125 transactions called it in the 90 days before that block; last on 2026-11-17.
- 17 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
