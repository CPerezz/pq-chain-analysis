---
id: simpleaccount-078bf499-signer-upgrade-only
title: "SimpleAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x078bf499222bfcbbfb50ebb191270a9bac93ce44"
  family: "a69eaf4d635c7c80d967e2807418b182"
  copies: 14
  name: "SimpleAccount"
  upgradeable: "yes"
  admin: "0x2dde819938edd5a7cd962d221940edee5ab788c1"
  rating: LOW
  value_usd: 227
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1024
  last_active: 2026-11-17
  recoveries_14d: 77
fix:
  layer: account-migration
  who_acts: "EOA owner 0x4850f18b…"
evidence:
  level: executed
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
  note: "LOW, same basis as the family row 0x2c2f1906…."
---

## Summary

SimpleAccount (ERC-4337), same pattern as 0x2c2f1906…: the owner has a direct-call path and can upgrade.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x74fcf00553d3699d845b616d5a9bf5256c984299 with upgradeTo(address), owner 0x2dde819938edd5a7cd962d221940edee5ab788c1.
- owner() at 26438999 = 0x4850f18b6295bf28d9e48ace95587aa08083a58b
- that owner has no code, nonce 0 at 26438999 (an unused but existing EOA key)

## Impact and exposure

- Value held at block 26,438,999: $227 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 1,024 transactions called it in the 90 days before that block; last on 2026-11-17.
- 77 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls execute() directly or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
