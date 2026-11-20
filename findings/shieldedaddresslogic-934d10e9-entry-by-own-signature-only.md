---
id: shieldedaddresslogic-934d10e9-entry-by-own-signature-only
title: "ShieldedAddressLogic: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x934d10e93666481e25e2e6f77a7c3109a8502225"
  family: "e2340ec9f9b706f0d7be9442cf88fc56, 78a2068067ef06eee40b6c13311518c6"
  copies: 4
  name: "ShieldedAddressLogic"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2
  last_active: 2026-10-28
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "the team adds a direct call or ERC-1271 to the entry path"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`ShieldedAddressLogic` at `0x934d10e93666481e25e2e6f77a7c3109a8502225`, with 3 more addresses running its code. It lets an account register or place an order only with its own ECDSA signature; an account with code cannot enter.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: shielded address registration: whoever signed registers its own public address, bound by a proof; there is no registration by a direct call. Read from source.
- Reviewed through the root issue's mechanism (D-025): entering or registering needs the entrant's own signature and nothing the entrant holds sits behind it; an account that takes real code enters before migrating or keeps an EIP-7702 delegation, which EIP-8151 exempts: LOW
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 197 rows below Anon's thresholds: 21 held at LOW, 3 had no ecrecover call (rows like those are now filed not affected by the mechanical check), 1 belonged to the rotation issue

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-10-28.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Add a direct call or ERC-1271 to the entry path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
