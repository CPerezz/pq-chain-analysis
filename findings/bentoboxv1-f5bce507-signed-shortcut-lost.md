---
id: bentoboxv1-f5bce507-signed-shortcut-lost
title: "BentoBoxV1: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xf5bce5077908a1b7370b9ae04adc565ebd643966"
  family: "75f4f52f424c556471d91e214e8bcaeb"
  name: "BentoBoxV1"
  label: "SushiSwap: BentoBoxV1"
  upgradeable: "no"
  rating: LOW
  value_usd: 297391
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 93
  last_active: 2026-11-17
fix:
  layer: account-migration
  who_acts: "the user"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same act open by direct call → LOW."
---

## Summary

SushiSwap BentoBoxV1: setMasterContractApproval by signature; a user with code fails the signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: BentoBox setMasterContractApproval: with an empty signature the user must be the caller; otherwise the user named must have signed. Read from source.
- BentoBoxV1.sol:541 setMasterContractApproval: with an empty signature the user must be msg.sender (direct path)
- withdraw :866 and transfer :919 are direct

## Impact and exposure

- Value held at block 26,438,999: $297,391 (ETH and 49 priced tokens).
- Activity: 93 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

User approves the master contract by its own call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
