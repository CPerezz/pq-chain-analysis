---
id: semimodularaccount7702-0cfabe8a-rotate-signer-before-migrating
title: "SemiModularAccount7702: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e"
  family: "dda3e769e166291d5abdffe6b25e08a7"
  copies: 98841
  name: "SemiModularAccount7702"
  label: "Alchemy: SemiModularAccount 7702"
  upgradeable: "yes"
  rating: LOW
  value_usd: 88055490
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 612987
  last_active: 2026-11-18
  recoveries_14d: 45867
fix:
  layer: onchain-config
  who_acts: "the account"
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
  note: "A setter callable by the account owner exists: LOW. The default configuration is unaffected."
---

## Summary

Alchemy SemiModularAccount7702 (98.8k EOAs). The signer is the account itself or a stored fallback signer; a signer flagged as a contract is asked through ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source.
- reading dda3e769: the default signer is the account (a delegation indicator, exempt)
- the fallback signer is set by the account itself and can be flagged as a contract owner

## Impact and exposure

- Value held at block 26,438,999: $88.1M (ETH and 49 priced tokens, over 98,841 addresses).
- Activity: 612,987 transactions called it in the 90 days before that block; last on 2026-11-18.
- 45,867 signature recoveries in the study's two-week trace window.

## Remediation

The account replaces the fallback signer, or flags it as a contract owner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
