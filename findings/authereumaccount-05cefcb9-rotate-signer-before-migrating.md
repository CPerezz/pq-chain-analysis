---
id: authereumaccount-05cefcb9-rotate-signer-before-migrating
title: "AuthereumAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x05cefcb9471605380c1750874ec652e3f0609856"
  family: "5cd5f31ed55cae59a0b6ea68fe01d063"
  copies: 243
  name: "AuthereumAccount"
  label: "created by Authereum: Proxy Factory V2019111500"
  upgradeable: "yes"
  rating: LOW
  value_usd: 27068
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-17
fix:
  layer: account-migration
  who_acts: "account auth key holder"
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
  note: "Key holder can rotate its own keys by direct call."
---

## Summary

Authereum account proxy: isValidSignature and meta-transactions recover an auth key or login key attested by an auth key.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: isValidSignature by an auth key: the recovered address must be an auth key of the account / isValidSignature by a login key: a login key signs, and an auth key of the account signed for that login…. Read from source.
- addAuthKey/removeAuthKey are onlyAuthKeySenderOrSelf, so a current auth key can call them directly (AuthereumAccount.sol:1037,1046)
- upgradeToAndCall is onlySelf (live upgrade through the account)
- Auth key set not enumerated (mapping)

## Impact and exposure

- Value held at block 26,438,999: $27,068 (ETH and 49 priced tokens, over 243 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-17.

## Remediation

Auth key holder adds a new auth key by direct call before migrating, or calls the account directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
