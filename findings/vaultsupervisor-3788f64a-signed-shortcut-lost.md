---
id: vaultsupervisor-3788f64a-signed-shortcut-lost
title: "VaultSupervisor: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3788f64a0805f3ec777ce26080bb2eeeb29c1199"
  family: "076f95002ec16af1595f37afb85b5237"
  copies: 2
  name: "VaultSupervisor"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2071
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the user (deposits directly)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "direct deposit path → LOW"
---

## Summary

Karak VaultSupervisor (upgradeable): gasless deposit path verifies the user's signature (verifyVaultSign); with code at the user it fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Karak VaultSupervisor verifyVaultSign: the user named signs a deposit; the user can deposit directly. Read (function text).
- selectors at block include deposit(address,uint256,uint256), callable by the user with msg.sender as staker
- signed variant only replaces the user's own call
- ownable upgradeable proxy (upgradeToAndCall)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,071 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

user calls deposit directly

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
