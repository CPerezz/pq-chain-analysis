---
id: walletcore-f36a1461-7702-own-key-only
title: "WalletCore: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xf36a146160ec69820542f3c4dec5c72b37403967"
  family: "1cab59ca573097d480ab7ea35652b50e"
  copies: 24451
  name: "WalletCore"
  label: "OKX: EIP-7702 Delegator"
  upgradeable: "no"
  rating: LOW
  value_usd: 15395784
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 24454
  last_active: 2026-11-18
  recoveries_14d: 271
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
  note: "Also accepts sessions and registered validators set up by the account"
---

## Summary

WalletCore (24,451 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction is unaffected by code at the signer.
- WalletCore (OKX) isValidSignature: tryRecover == address(this) (line 151-152); sessions and registered validators also exist/source (dossier 1cab59ca573097d480ab7ea35652b50e)
- Study note: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source. E
- Activity (measured): txs_90d 24,454, last_active 2026-11-18, value_usd 15395784

## Impact and exposure

- Value held at block 26,438,999: $15.4M (ETH and 49 priced tokens, over 24,451 addresses).
- Activity: 24,454 transactions called it in the 90 days before that block; last on 2026-11-18.
- 271 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
