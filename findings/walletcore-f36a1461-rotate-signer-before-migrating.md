---
id: walletcore-f36a1461-rotate-signer-before-migrating
title: "WalletCore: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
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
  who_acts: "the delegating EOA"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Own key only, nothing to rotate: LOW."
---

## Summary

OKX WalletCore 7702 delegator. The signature must recover address(this), which is exempt as a delegation indicator.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction is unaffected by code at the signer.
- reading 1cab59ca: the result is compared only with address(this); reading 2 has no effect
- family 1cab59ca: 24,451 addresses run this code holding 4,028 ETH; the own-key check has no stored foreign signer to rotate

## Impact and exposure

- Value held at block 26,438,999: $15.4M (ETH and 49 priced tokens, over 24,451 addresses).
- Activity: 24,454 transactions called it in the 90 days before that block; last on 2026-11-18.
- 271 signature recoveries in the study's two-week trace window.

## Remediation

Keep the delegation or re-delegate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
