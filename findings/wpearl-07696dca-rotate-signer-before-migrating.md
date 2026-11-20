---
id: wpearl-07696dca-rotate-signer-before-migrating
title: "WPearl: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x07696dcab55e62cfef953666b29fe1970518cb00"
  family: "7652d82cc32952d17ecc59fea243d1e9"
  copies: 3
  name: "WPearl"
  label: "PearlBridge Bridged WPRL (Ethereum): WPRL Token"
  upgradeable: "yes"
  admin: "timelock 0xc07c5b10fa35c0db94ab47484b9f667b7b649762"
  rating: LOW
  txs_90d: 70551
  last_active: 2026-11-18
  recoveries_14d: 138
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN timelock 0xc07c…9762"
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
  note: "role setter held by a working timelock; upgrade path too."
---

## Summary

WPearl (UUPS): attester quorum of RELAYER_ROLE holders plus an OZ permit; a relayer with code fails, permit owners keep approve.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / attester quorum: each recovered signer must hold RELAYER_ROLE, ascending order. Read from source. Executed: a real transaction reverts with code at the signer.
- RELAYER_ROLE admin is DEFAULT_ADMIN_ROLE; grantRole(RELAYER_ROLE,·) eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() and role-0 member = 0xc07c5b10…, a timelock (getMinDelay 86400) which also governs upgrades

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 70,551 transactions called it in the 90 days before that block; last on 2026-11-18.
- 138 signature recoveries in the study's two-week trace window.

## Remediation

Admin timelock grants RELAYER_ROLE to new keys and revokes old ones (1-day delay).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
