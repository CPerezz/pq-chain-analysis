---
id: reconstructed-b57dda84-7702-own-key-only
title: "Reconstructed: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xb57dda84e58a31f8527354d19edd73d0c4b164b0"
  family: "91dd46a33b075196924fb43a8c37044e"
  copies: 7954
  name: "Reconstructed"
  upgradeable: "no"
  rating: LOW
  value_usd: 15700
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 468
  last_active: 2026-11-17
  recoveries_14d: 3
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
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
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $15,700 (held), txs_90d 468"
---

## Summary

Reconstructed: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- verified source: Reconstructed.sol:107-108 `require(recovered == address(this))`
- cast code at 26438999: 0xef0100; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $15,700 (ETH and 49 priced tokens, over 7,954 addresses).
- Activity: 468 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
