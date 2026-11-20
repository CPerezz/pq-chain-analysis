---
id: comp-2ba592f7-signed-shortcut-lost
title: "Comp: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2ba592f78db6436527729929aaf6c908497cb200"
  family: "71f9b32c56a5d1d67b9fd7327d06e666"
  name: "Comp"
  label: "Cream.Finance: CREAM Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1645
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $14436, txs_90d 1645."
---

## Summary

Comp token with Compound-style delegateBySig; under EIP-8151 a holder whose address has code cannot delegate by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Compound delegateBySig (variant). Read from source.
- Comp: delegateBySig recovers the signer and delegates for it (dossier source, Compound delegateBySig (variant))
- delegate(address) is a public function that delegates for msg.sender (dossier source)
- approve(address,uint256) also present for the token's own approvals

## Impact and exposure

- Value held at block 26,438,999: $14,436 (ETH and 49 priced tokens).
- Activity: 1,645 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder calls delegate(address) itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
