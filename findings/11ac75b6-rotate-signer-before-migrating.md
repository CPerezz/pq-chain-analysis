---
id: 11ac75b6-rotate-signer-before-migrating
title: "0x11ac75b6: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x11ac75b61c0974f71a6e171e1e36714c4f105e35"
  family: "d7fbee65384576226fdd62c5fb91ceef"
  copies: 2
  upgradeable: "yes"
  admin: "UPGRADE_ROLE 0x4b339694df393ee9e1a06c422508d31529742ad2 (EOA)"
  rating: LOW
  value_usd: 47640
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "role holder 0x4b339694 (EOA)"
evidence:
  level: bytecode
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
  note: "Setter and upgrade are both callable by a live EOA role holder."
---

## Summary

UUPS proxy (impl 0x79716351): signed price quotes come from a stored priceQuoteSigner. A signer with code makes the quote-gated calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setPriceQuoteSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- Impl decompile: setPriceQuoteSigner requires role 0xa4980720…; upgradeTo requires role 0x88aa7196… (UPGRADE_ROLE)
- RoleGranted at creation (block 13943457) gave both roles to 0x4b339694df393ee9e1a06c422508d31529742ad2; hasRole is true for both at block 26438999
- 0x4b33…: no code, nonce 63

## Impact and exposure

- Value held at block 26,438,999: $47,640 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Role holder calls setPriceQuoteSigner with an EOA, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
