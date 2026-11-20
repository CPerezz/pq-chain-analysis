---
id: bba3c74a-rotate-signer-before-migrating
title: "0xbba3c74a (tagged deployed by Conflux Network: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbba3c74a006f199193645e35a936b75b605cb2bc"
  family: "d81eb18d2628842bf1ab672228674b7e"
  copies: 2
  label: "deployed by Conflux Network: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 184967
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 118
  last_active: 2026-11-14
  recoveries_14d: 12
fix:
  layer: onchain-config
  who_acts: "committee quorum / WhitelistAdmin"
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
  note: "Quorum upgrade path; WhitelistAdmin holders not enumerated."
---

## Summary

Custody vault with 2/3 committee ECDSA quorum, upgradeable by quorum.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changeMember). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- changeMember 0x0c660be4 by WhitelistAdmin holder
- upgradeImpl(bytes[]) by 2/3 committee signatures rewrites implementation

## Impact and exposure

- Value held at block 26,438,999: $184,967 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 118 transactions called it in the 90 days before that block; last on 2026-11-14.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Committee replaces a member or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
