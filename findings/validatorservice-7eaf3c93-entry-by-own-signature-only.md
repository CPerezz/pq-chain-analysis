---
id: validatorservice-7eaf3c93-entry-by-own-signature-only
title: "ValidatorService: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x7eaf3c936c0109364e63a325652eb3568fa6c29d"
  family: "5cdada6621035c9b3ff7a37673c92fdf"
  copies: 2
  name: "ValidatorService"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 330
  last_active: 2026-11-17
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

`ValidatorService` at `0x7eaf3c936c0109364e63a325652eb3568fa6c29d`, with 1 more addresses running its code. It lets an account register or place an order only with its own ECDSA signature; an account with code cannot enter.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: SKALE ValidatorService linkNodeAddress: the node address must sign; one with code cannot be linked. Read (function text).
- Reviewed through the root issue's mechanism: entering or registering needs the entrant's own signature and nothing the entrant holds sits behind it; an account that takes real code enters before migrating or keeps an EIP-7702 delegation, which EIP-8151 exempts: LOW
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 197 rows below Anon's thresholds: 21 held at LOW, 3 had no ecrecover call (rows like those are now filed not affected by the mechanical check), 1 belonged to the rotation issue

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 330 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Add a direct call or ERC-1271 to the entry path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
