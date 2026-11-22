---
id: wormhole-f92cd566-rotate-signer-before-migrating
title: "Wormhole: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf92cd566ea4864356c5491c177a430c222d7e678"
  family: "26e6e0270bc183a0c2bb94faa05e7478"
  name: "Wormhole"
  label: "Wormhole: Solana Bridge"
  upgradeable: "no"
  rating: LOW
  value_usd: 415771
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 31
  last_active: 2026-11-03
fix:
  layer: onchain-config
  who_acts: "guardian quorum"
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
  note: "Committee rotation live while quorum stays EOA."
---

## Summary

Wormhole v1 bridge: submitVAA needs a guardian quorum; a guardian with code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Wormhole v1: a quorum of the guardian set, each signature from the guardian at its index; the set is replaced by a message the current set signs. Read from source.
- guardian set replaced by a VAA (action 0x01) signed by current quorum; no owner (reading.keys)

## Impact and exposure

- Value held at block 26,438,999: $415,771 (ETH and 49 priced tokens).
- Activity: 31 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

Guardians sign a new set before members take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
