---
id: 5bd25d2f-rotate-signer-before-migrating
title: "0x5bd25d2f (tagged Galxe: SpaceStationV1_1(Deprecated)): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5bd25d2f4f26bc82a34de016d34612a28a0cd492"
  family: "86e245378e689ce6a2a9fb4d0b03a197"
  label: "Galxe: SpaceStationV1_1(Deprecated)"
  upgradeable: "no"
  rating: LOW
  value_usd: 19489
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "manager"
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
  note: "There is a setter and a live EOA manager."
---

## Summary

Unverified Galaxy campaign claim contract: claims are signed by a stored galaxySigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateGalaxySigner, updateManager, updateTreasureManager). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompiled: updateGalaxySigner requires msg.sender == manager
- manager() = 0x9d0E…1b9f, an EOA with nonce 392

## Impact and exposure

- Value held at block 26,438,999: $19,489 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Manager calls updateGalaxySigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
