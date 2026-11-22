---
id: semimodularaccount7702-a79692b6-rotate-signer-before-migrating
title: "SemiModularAccount7702: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa79692b65bad10d7d2fe9de309a646fbe311d6a2"
  family: "8554540d6b65a7c2598143cb0037076a"
  copies: 30422
  name: "SemiModularAccount7702"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2794361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 237508
  last_active: 2026-11-18
  recoveries_14d: 17088
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
  note: "LOW: setter controlled by the account."
---

## Summary

SemiModularAccount7702 variant. The signer is the account itself (exempt) or a stored fallback signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Alchemy SemiModularAccount7702 ERC-1271: the signature must recover to the account itself / Alchemy SemiModularAccount (variant): the fallback signer, the account itself until changed, signs with…. Read from source.
- reading 8554540d: all 17,088 traced recoveries returned the account itself; only a foreign fallback signer with code is affected
- the fallback signer is set by the account

## Impact and exposure

- Value held at block 26,438,999: $2.8M (ETH and 49 priced tokens, over 30,422 addresses).
- Activity: 237,508 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,088 signature recoveries in the study's two-week trace window.

## Remediation

The account changes the fallback signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
