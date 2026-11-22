---
id: 4c2bddd6-7702-own-key-only
title: "0x4c2bddd6: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
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
  note: "Also accepts revocable session keys registered by the account"
---

## Summary

unnamed 7702 delegate (272 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: 7702 account logic: the account's own key, or a session key it can revoke. Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- DueWallet (bytecode): reading.first.json says the signer must be the account's own key or a session key the account registered/source (dossier b4aa3552fb94a8a272fcb9f0f46ca2ac)
- Study note: 7702 account logic: the account's own key, or a session key it can revoke. Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 7,666, last_active 2026-11-18, value_usd 298835

## Impact and exposure

- Value held at block 26,438,999: $298,835 (ETH and 49 priced tokens, over 272 addresses).
- Activity: 7,666 transactions called it in the 90 days before that block; last on 2026-11-18.
- 631 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
