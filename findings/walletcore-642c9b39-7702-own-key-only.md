---
id: walletcore-642c9b39-7702-own-key-only
title: "WalletCore: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x642c9b393c3754d3618b88e16d6c96c13a467627"
  family: "fd63c340035522dc3c96e96e6f47946a"
  copies: 106596
  name: "WalletCore"
  upgradeable: "no"
  rating: LOW
  value_usd: 121201648
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 398033
  last_active: 2026-11-18
  recoveries_14d: 39170
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
  note: "Also accepts sessions and registered external validators, all set up by the account's own key"
---

## Summary

WalletCore (106,596 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- WalletCore isValidSignature: tryRecover == address(this) (line 170-171); validator==1 means built-in ecrecover; also sessions signed by the account and validators the account registers/source (dossier fd63c340035522dc3c96e96e6f47946a)
- Study note: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Activity (measured): txs_90d 398,033, last_active 2026-11-18, value_usd 121201648

## Impact and exposure

- Value held at block 26,438,999: $121.2M (ETH and 49 priced tokens, over 106,596 addresses).
- Activity: 398,033 transactions called it in the 90 days before that block; last on 2026-11-18.
- 39,170 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
