---
id: hermesdelegatev1-3afebc8a-7702-own-key-only
title: "HermesDelegateV1: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x3afebc8a2cf00ef3ff053f59b11ee7ae7d6a7f41"
  family: "821064140cd90f31bf8e588b8b0bcb38"
  copies: 1239
  name: "HermesDelegateV1"
  upgradeable: "no"
  rating: LOW
  value_usd: 412883
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4023
  last_active: 2026-11-18
  recoveries_14d: 1487
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
  note: "Pure own-key check; re-delegation fixes it -> LOW."
---

## Summary

HermesDelegateV1 (1,239 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction is unaffected by code at the signer.
- HermesDelegateV1 isValidSignature: tryRecover == address(this) (lines 589-590)/source (dossier 821064140cd90f31bf8e588b8b0bcb38)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction is unaffected by code at the signer.
- Activity (measured): txs_90d 4,023, last_active 2026-11-18, value_usd 412883

## Impact and exposure

- Value held at block 26,438,999: $412,883 (ETH and 49 priced tokens, over 1,239 addresses).
- Activity: 4,023 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,487 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
