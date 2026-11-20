---
id: f6cf2711-7702-own-key-only
title: "0xf6cf2711: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xf6cf271147adce6c841aecfbfe7530264759126e"
  family: "ef01f713265e8ce219e7526705dcb831"
  copies: 34742
  upgradeable: "no"
  rating: LOW
  value_usd: 53420390
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8460
  last_active: 2026-11-18
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
  note: "Same family as WalletCore; read from the bytecode reading, not re-decompiled"
---

## Summary

unnamed 7702 delegate (34,742 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Bytecode only (wallet-core 1.0.0 from eip712Domain): reading.first.json says internal tryRecover (pc 5626-5825) is compared with ADDRESS; sessions for an executor also validated/source (dossier ef01f713265e8ce219e7526705dcb831)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Activity (measured): txs_90d 8,460, last_active 2026-11-18, value_usd 53420390

## Impact and exposure

- Value held at block 26,438,999: $53.4M (ETH and 49 priced tokens, over 34,742 addresses).
- Activity: 8,460 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
