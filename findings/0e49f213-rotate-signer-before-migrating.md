---
id: 0e49f213-rotate-signer-before-migrating
title: "0x0e49f213: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e49f213201cce625295f8b04c02aed6b0138b7a"
  family: "c1609274bc991cd3e6c1eda003f9d5f9"
  copies: 3
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16995
  last_active: 2026-11-18
  recoveries_14d: 356
fix:
  layer: onchain-config
  who_acts: "admin Safe 1/1"
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
  note: "Setter callable by a live 1/1 Safe."
---

## Summary

Unverified role-based contract; signers are kept as role members (grantRole/revokeRole). Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall decompile: grantRole (0x2f2ff15d) requires storage_map_d[msg.sender] (admin)
- admins() = owners() = [0x7712c056…], a Safe with 1 owner (0x62b397af…), threshold 1
- EIP-1967 implementation slot is zero and upgradeToAndCall requires address(this) != 0x0e49… (onlyProxy), so this address cannot be upgraded

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 16,995 transactions called it in the 90 days before that block; last on 2026-11-18.
- 356 signature recoveries in the study's two-week trace window.

## Remediation

Admin Safe grants the signer role to a fresh EOA and revokes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
