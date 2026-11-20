---
id: authereumaccount-10e55548-rotate-signer-before-migrating
title: "AuthereumAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10e55548db8cdd32ad9a90c14271a88cd0b52e96"
  family: "e7f0144c25dcf11394c628cd56a75b68"
  copies: 912
  name: "AuthereumAccount"
  label: "created by Authereum: Proxy Factory v2020070100"
  upgradeable: "yes"
  rating: LOW
  value_usd: 36091
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-29
fix:
  layer: account-migration
  who_acts: "the auth key holder"
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
  note: "the auth key holder rotates its own key directly."
---

## Summary

AuthereumAccount: meta-transactions must be signed by an auth key (or a login key attested by one); an auth key with code cannot sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: an auth key of the account signs, or a login key that an auth key signed for / the recovered address must be an auth key of the account; auth keys are added and removed by the account. Read from source.
- AuthereumAccount.sol:1890/1900 addAuthKey/removeAuthKey onlyAuthKeyOrSelf (auth key calls directly as msg.sender)
- account is an upgradeable proxy whose upgrade is self-called

## Impact and exposure

- Value held at block 26,438,999: $36,091 (ETH and 49 priced tokens, over 912 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

rotate the signer key before the account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
