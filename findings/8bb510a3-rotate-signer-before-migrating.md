---
id: 8bb510a3-rotate-signer-before-migrating
title: "0x8bb510a3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8bb510a3860e0ad2a0f2794a90cbf14b1b85a2f0"
  family: "5a0542388e6c89f185d36d83a072058a"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 368130
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8861
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "any current owner"
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
  note: "Direct-call setter and direct path."
---

## Summary

Owner-controlled command executor; relayed programs need an owner signature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: owners in a mapping, added and removed by functions. Bytecode and names.
- addOwner 0x7065cb48 / removeOwner 0x173825d9 by any owner direct call
- owners also run programs by direct call (reading.what)

## Impact and exposure

- Value held at block 26,438,999: $368,130 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 8,861 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner adds a new EOA owner or acts directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
