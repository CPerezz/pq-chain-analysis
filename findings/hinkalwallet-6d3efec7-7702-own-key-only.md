---
id: hinkalwallet-6d3efec7-7702-own-key-only
title: "HinkalWallet: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x6d3efec79de0262b05d51c26e8308890479b5b3b"
  family: "e7f2785a700b677d466a6a77702842d7"
  copies: 851
  name: "HinkalWallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 129026
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 28
  last_active: 2026-11-13
  recoveries_14d: 1
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

HinkalWallet (851 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- HinkalWallet isValidSignature: tryRecover == address(this) (lines 49-55)/source (dossier e7f2785a700b677d466a6a77702842d7)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Activity (measured): txs_90d 28, last_active 2026-11-13, value_usd 129026

## Impact and exposure

- Value held at block 26,438,999: $129,026 (ETH and 49 priced tokens, over 851 addresses).
- Activity: 28 transactions called it in the 90 days before that block; last on 2026-11-13.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
