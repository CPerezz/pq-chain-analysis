---
id: mcpayment-9fb6e4ea-entry-by-own-signature-only
title: "MCPayment: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x9fb6e4ea70cc0f8df4a524f2984fb09a67c7a8c2"
  family: "504c4a732feee4fc07d0217eee330740"
  copies: 2
  name: "MCPayment"
  upgradeable: "no"
  rating: LOW
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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

`MCPayment` at `0x9fb6e4ea70cc0f8df4a524f2984fb09a67c7a8c2`, with 1 more addresses running its code. It lets an account register or place an order only with its own ECDSA signature; an account with code cannot enter.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / iden3 payment: the payment request is signed by the issuer being paid, whoever signed / iden3 ERC-20 payment: as above /…. Read from source.
- Reviewed through the root issue's mechanism (D-025): entering or registering needs the entrant's own signature and nothing the entrant holds sits behind it; an account that takes real code enters before migrating or keeps an EIP-7702 delegation, which EIP-8151 exempts: LOW
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 197 rows below Anon's thresholds: 21 held at LOW, 3 had no ecrecover call (rows like those are now filed not affected by the mechanical check), 1 belonged to the rotation issue

## Impact and exposure

- Value held at block 26,438,999: $5,955 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Add a direct call or ERC-1271 to the entry path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
