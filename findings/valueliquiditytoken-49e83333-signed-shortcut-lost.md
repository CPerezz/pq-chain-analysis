---
id: valueliquiditytoken-49e83333-signed-shortcut-lost
title: "ValueLiquidityToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x49e833337ece7afe375e44f4e3e8481029218e5c"
  family: "89b63a51b77f70d72a461445fe2a3319"
  name: "ValueLiquidityToken"
  label: "Value DeFi Protocol: VALUE Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 17685
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 726
  last_active: 2026-11-14
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $17685, txs_90d 726."
---

## Summary

ValueLiquidityToken token with Compound-style delegateBySig; under EIP-8151 a holder whose address has code cannot delegate by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (Compound style): whoever signed delegates; zero rejected. Read from source.
- ValueLiquidityToken: delegateBySig recovers the signer and delegates for it (dossier source, delegateBySig (Compound style): whoever signed delegates; zero rejected)
- delegate(address) is a public function that delegates for msg.sender (dossier source)
- approve(address,uint256) also present for the token's own approvals

## Impact and exposure

- Value held at block 26,438,999: $17,685 (ETH and 49 priced tokens).
- Activity: 726 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The holder calls delegate(address) itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
