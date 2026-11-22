---
id: supervault-007039f3-signed-shortcut-lost
title: "SuperVault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x007039f3d19da05afc533e357e4ac18cb9a4ede4"
  family: "f0d9040fdac1fadeccc0cdcfb8a49a89"
  copies: 29
  name: "SuperVault"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2841
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the controller (calls setOperator)"
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
  note: "direct setOperator covers the act → LOW"
---

## Summary

Superform SuperVault (minimal proxy to 0xb2fa7824…): authorizeOperator sets an operator on the controller's signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SuperVault authorizeOperator: the controller's signature; setOperator is the direct call. Read.
- address is an EIP-1167 clone of 0xb2fa782406453fb345cdd7f2c3586003a3fe2bbb
- implementation selectors include setOperator(address,bool) and authorizeOperator(address,address,bool,bytes32,uint256,bytes)
- setOperator acts for msg.sender, so the controller sets the same operator directly

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 29 addresses).
- Activity: 2,841 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

controller calls setOperator

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
