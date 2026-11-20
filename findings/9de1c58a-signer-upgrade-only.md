---
id: 9de1c58a-signer-upgrade-only
title: "0x9de1c58a (tagged created by Nuo Network: Account Factory): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9de1c58a7fbd40950eb1b5fd80325e32e8c34be6"
  family: "df72af5ad91e0ab1d9449dd5ad1458b9"
  copies: 222
  label: "created by Nuo Network: Account Factory"
  upgradeable: "yes"
  rating: LOW
  value_usd: 14862
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "any of 3 admin EOAs via config contract 0x431f4290…"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live admin keys, same mechanism as 0xafd76c55…: LOW."
---

## Summary

A Nuo Network account-factory wallet (same family as 0xafd76c55…): changeMasterCopy replaces the implementation, gated by the same admin config contract.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x17e575b719b043d33d93fe9445b0f8df0598ac67 with changeMasterCopy(address), called through its own checks.
- slot5 of this account also packs config=0x431f4290… (same as the sibling row), confirmed by cast storage
- config.isAdmin true for the same 3 EOAs (nonces 678, 64046, 64597) at 26438999; disableAdminControl=false

## Impact and exposure

- Value held at block 26,438,999: $14,862 (ETH and 49 priced tokens, over 222 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

An admin calls changeImpl to point at a new master copy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
