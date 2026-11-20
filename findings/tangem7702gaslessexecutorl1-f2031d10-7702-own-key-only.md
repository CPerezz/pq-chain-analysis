---
id: tangem7702gaslessexecutorl1-f2031d10-7702-own-key-only
title: "Tangem7702GaslessExecutorL1: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xf2031d100ee36e25d0f3ab7550f2acbf57dfcd4f"
  family: "eb9b8185d15f7619811ceeae7ad61f54"
  copies: 15150
  name: "Tangem7702GaslessExecutorL1"
  upgradeable: "no"
  rating: LOW
  value_usd: 48723120
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 41396
  last_active: 2026-11-18
  recoveries_14d: 38
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

Tangem7702GaslessExecutorL1 (15,150 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Tangem7702GaslessExecutorL1 (variant): `require(signer == address(this))` after ECDSA.recover (line 169-171)/source (dossier eb9b8185d15f7619811ceeae7ad61f54)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Activity (measured): txs_90d 41,396, last_active 2026-11-18, value_usd 48723120

## Impact and exposure

- Value held at block 26,438,999: $48.7M (ETH and 49 priced tokens, over 15,150 addresses).
- Activity: 41,396 transactions called it in the 90 days before that block; last on 2026-11-18.
- 38 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
