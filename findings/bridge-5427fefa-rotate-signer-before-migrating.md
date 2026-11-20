---
id: bridge-5427fefa-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820"
  family: "f3969f727e902e067e61f557b2769805"
  copies: 5
  name: "Bridge"
  label: "Celer Network: cBridge V2"
  upgradeable: "no"
  rating: LOW
  value_usd: 1488582
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4379
  last_active: 2026-11-18
  recoveries_14d: 522
fix:
  layer: onchain-config
  who_acts: "signer quorum or owner"
evidence:
  level: source-read
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
  note: "LOW: setter callable by the live committee. The owner contract's type is unverified."
---

## Summary

Celer cBridge V2. A weighted signer committee signs by ECDSA; if more than a third of power migrates, relay and withdraw stop.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Celer bridge: signers ascending, matched against the signer list given in the call, power must reach two thirds plus one; the list is replaced by updateSigners (signed by the current set) or reset by…. Read from source.
- reading f3969f72: updateSigners by quorum, or owner notifyResetSigners/resetSigners after noticePeriod
- owner() = 0xF380166F (10,262-byte contract, not identified); paused() = false

## Impact and exposure

- Value held at block 26,438,999: $1.5M (ETH and 49 priced tokens, over 5 addresses).
- Activity: 4,379 transactions called it in the 90 days before that block; last on 2026-11-18.
- 522 signature recoveries in the study's two-week trace window.

## Remediation

The signers rotate through updateSigners before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
