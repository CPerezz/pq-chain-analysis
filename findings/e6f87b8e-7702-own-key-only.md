---
id: e6f87b8e-7702-own-key-only
title: "0xe6f87b8e: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xe6f87b8eae04944d5209d0ba290e7067050b728b"
  family: "4388764dbaa36d83700562a2fd10ee38"
  copies: 5
  upgradeable: "no"
  rating: LOW
  value_usd: 1455919
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 61553
  last_active: 2026-11-18
  recoveries_14d: 473
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
  note: "Only 5 accounts; the own-key path is only ERC-1271; the operator swap paths don't use ecrecover"
---

## Summary

unnamed 7702 delegate (5 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Executed: a real transaction reverts once the account holds this logic as real code.
- Bytecode: isValidSignature 0x1626ba7e compares the recovered address with ADDRESS; the rest is an operator-run swap bot (allow-listed operators call fallback swap selectors)/source (dossier 4388764dbaa36d83700562a2fd10ee38)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Exec
- Activity (measured): txs_90d 61,553, last_active 2026-11-18, value_usd 1455919

## Impact and exposure

- Value held at block 26,438,999: $1.5M (ETH and 49 priced tokens, over 5 addresses).
- Activity: 61,553 transactions called it in the 90 days before that block; last on 2026-11-18.
- 473 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
