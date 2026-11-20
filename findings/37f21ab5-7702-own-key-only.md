---
id: 37f21ab5-7702-own-key-only
title: "0x37f21ab5 (tagged Bitget Wallet: 7702 v0.0.1): 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x37f21ab551f010353fd071c27d53496aa94763c6"
  family: "d51eb37435c14be494bdd014dc684fdf"
  copies: 10579
  label: "Bitget Wallet: 7702 v0.0.1"
  upgradeable: "no"
  rating: LOW
  value_usd: 621851
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1092
  last_active: 2026-11-17
  recoveries_14d: 2
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
  note: "No verified source; read from the bytecode reading"
---

## Summary

Bitget Wallet: 7702 v0.0.1 (10,579 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Bytecode only (Bitget 7702 v0.0.1): reading.first.json says the internal recover at pc 0x0629 (isValidSignature, validateUserOp) is compared with the account; batch call authorised by an external verifier/source (dossier d51eb37435c14be494bdd014dc684fdf)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Activity (measured): txs_90d 1,092, last_active 2026-11-17, value_usd 621851

## Impact and exposure

- Value held at block 26,438,999: $621,851 (ETH and 49 priced tokens, over 10,579 addresses).
- Activity: 1,092 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
