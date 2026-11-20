---
id: sos69069-7373dbc2-entry-by-own-signature-only
title: "SOS69069: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x7373dbc24dcd785896e8ac3d5372c6ced9b75a8a"
  family: "1f5df108d362133547a651db1908bc75"
  name: "SOS69069"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3142
  last_active: 2026-11-17
  recoveries_14d: 43
fix:
  layer: none
  who_acts: "none"
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
  note: "Entry/record only; nothing held. value_usd None, txs_90d 3142."
---

## Summary

SOS69069: records that an address signed a payload (stats/trust counters). No assets behind the signature.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: SOS69069: records that the address named signed a payload. Read from source.
- source header: every record function requires a valid ECDSA signature by the named address
- only view functions (statsOf, balanceOf of points) depend on the records; no token withdrawal is gated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,142 transactions called it in the 90 days before that block; last on 2026-11-17.
- 43 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
