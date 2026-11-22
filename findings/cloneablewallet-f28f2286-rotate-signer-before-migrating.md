---
id: cloneablewallet-f28f2286-rotate-signer-before-migrating
title: "CloneableWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf28f22868b5d7199772034f224d1fa6f8bafac83"
  family: "8a26da14f431a4f188fe34cc6a903c64"
  copies: 34447
  name: "CloneableWallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 477667
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-10
fix:
  layer: account-migration
  who_acts: "authorized key pair or recoveryAddress"
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
  note: "Key holder and recovery address both can rotate."
---

## Summary

Dapper CloneableWallet (34,447 clones): signer/cosigner pairs authorise invokes; a key with code stops signing.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Dapper wallet ERC-1271: signer and cosigner must be a pair recorded in the wallet's authorizations / Dapper wallet invoke1CosignerSends (variant): the recovered key is an authorized key, the caller…. Read from source.
- setAuthorized via an authorized invoke; emergencyRecovery by recoveryAddress (msg.sender) wipes keys and sets a new pair (reading.keys)

## Impact and exposure

- Value held at block 26,438,999: $477,667 (ETH and 49 priced tokens, over 34,447 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

Holder rotates the pair, or recoveryAddress runs emergencyRecovery.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
