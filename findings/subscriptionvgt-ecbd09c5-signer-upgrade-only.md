---
id: subscriptionvgt-ecbd09c5-signer-upgrade-only
title: "SubscriptionVGT: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xecbd09c5a2e842ef1f2811400360a9197e459cb5"
  family: "0383d7ac39e7f9b9e1b7e6fa7f6d0cc1"
  copies: 25
  name: "SubscriptionVGT"
  upgradeable: "yes"
  admin: "EOA 0x572943f1… (zos admin, nonce 0; same key as ticketProvider)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "EOA 0x572943f1… (proxy admin and ticketProvider)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Admin can upgrade: LOW. The admin EOA has nonce 0, so liveness is unproven, but it is the active ticket-signing key."
---

## Summary

This address is itself a ZeppelinOS AdminUpgradeabilityProxy running SubscriptionVGT 0xb3710462… (same code hash 0xcd5e3eac as the dossier). Tickets must be signed by ticketProvider; the proxy admin is that same EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Subscription tickets: signed by the stored ticketProvider. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- zos implementation slot = 0xb37104629564668fd3187c66483366d659c75dff; zos admin slot keccak('org.zeppelinos.proxy.admin') = 0x572943f16c8ce36ab5466ff8f01d50ca679ecd42 (admin() from it confirms)
- ticketProvider() = 0x572943F1… (no code, nonce 0, balance 0); serviceProvider 0x0A446B4a…; source: ticketProvider set only in initialize
- Source: unsubscribe() refunds users with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 25 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin upgrades to an implementation with a new ticketProvider.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
