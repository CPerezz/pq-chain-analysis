---
id: kernel-147c622b-7702-own-key-only
title: "Kernel: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x147c622b1439676d3276b114017f72e5501a893f"
  family: "36e61aedcb87898f3cec2244a4d36ad8"
  copies: 119406
  name: "Kernel"
  upgradeable: "yes"
  rating: LOW
  value_usd: 9946735
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 174066
  last_active: 2026-11-18
  recoveries_14d: 37525
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
  note: "Only the 7702 root-validator mode is own-key; the account can install another validator. Upgradeable by the account itself"
---

## Summary

Kernel (119,406 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: ZeroDev Kernel 7702 path: the signature must recover to the account itself. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Kernel v0.3.3: when the root validator type is 0x00 (the 7702 mode), the ECDSA signer must be the account itself; otherwise validator modules or permissions decide/source (dossier 36e61aedcb87898f3cec2244a4d36ad8)
- Study note: ZeroDev Kernel 7702 path: the signature must recover to the account itself. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 174,066, last_active 2026-11-18, value_usd 9946735

## Impact and exposure

- Value held at block 26,438,999: $9.9M (ETH and 49 priced tokens, over 119,406 addresses).
- Activity: 174,066 transactions called it in the 90 days before that block; last on 2026-11-18.
- 37,525 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
