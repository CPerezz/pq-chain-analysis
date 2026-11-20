---
id: walletcore-642c9b39-rotate-signer-before-migrating
title: "WalletCore: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
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
  who_acts: "the delegating EOA"
evidence:
  level: source-read
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
  note: "There is no stored foreign key to rotate; the own key works while delegated. LOW (7702 own-key nature)."
---

## Summary

WalletCore, 7702 delegate logic for about 106k accounts. A signature must recover address(this); a delegation indicator is exempt under EIP-8151.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; a longer one names a validator the account registered / the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- reading fd63c340: the result is compared only with address(this); reading 2 has no effect because a delegated account keeps the 0xef0100 indicator
- an account with other code no longer runs this logic

## Impact and exposure

- Value held at block 26,438,999: $121.2M (ETH and 49 priced tokens, over 106,596 addresses).
- Activity: 398,033 transactions called it in the 90 days before that block; last on 2026-11-18.
- 39,170 signature recoveries in the study's two-week trace window.

## Remediation

Keep the delegation or re-delegate. Nothing to rotate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
