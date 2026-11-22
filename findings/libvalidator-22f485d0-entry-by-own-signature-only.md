---
id: libvalidator-22f485d0-entry-by-own-signature-only
title: "LibValidator: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x22f485d0e314e9e38b16da4f2992ad4cbf7585be"
  family: "087b9e70c284c491f5c5c955b6a99116"
  copies: 8
  name: "LibValidator"
  upgradeable: "yes"
  rating: LOW
  value_usd: 614
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 69
  last_active: 2026-09-10
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`LibValidator` at `0x22f485d0e314e9e38b16da4f2992ad4cbf7585be`, with 7 more addresses running its code. It lets an account register or place an order only with its own ECDSA signature; an account with code cannot enter.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Orion LibValidator validateV3: the order's sender must have signed; orders have no direct path / Orion LibValidator validateCrossChainOrder: the order's sender must have signed / Orion LibValidator…. Read (function text).
- Reviewed through the root issue's mechanism: entering or registering needs the entrant's own signature and nothing the entrant holds sits behind it; an account that takes real code enters before migrating or keeps an EIP-7702 delegation, which EIP-8151 exempts: LOW
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 197 rows below Anon's thresholds: 21 held at LOW, 3 had no ecrecover call (rows like those are now filed not affected by the mechanical check), 1 belonged to the rotation issue

## Impact and exposure

- Value held at block 26,438,999: $614 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 69 transactions called it in the 90 days before that block; last on 2026-09-10.

## Remediation

Add a direct call or ERC-1271 to the entry path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
