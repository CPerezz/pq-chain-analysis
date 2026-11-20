---
id: v4utilsrouter-cb3d2a42-signed-shortcut-lost
title: "V4UtilsRouter: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcb3d2a42022741b06f9b38459e3dd1ee9a64d129"
  family: "59620062d890ebf5b8a47ef189168c33"
  name: "V4UtilsRouter"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2990
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: offchain
  who_acts: "the position owner (acts on the position manager directly)"
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
  note: "automation convenience lost; direct path for the owner → LOW"
---

## Summary

Krystal V4UtilsRouter automation: executeAutomation by an operator needs the position owner's signed order; with code at the owner it reverts.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Krystal V3Automation: the order must be signed by the user it acts for; an automation service, the same acts are open to the user on the position manager itself / EIP712._recover: returns the signer…. Read from source. Executed: a real transaction reverts with code at the signer.
- selectors at block: executeAutomation(address,uint256,bytes,bytes,bytes) (operator role), execute(address,bytes)
- order signer recovered via EIP712._recover and dual-checked against the owner (study reading from source)
- the same position actions stay open to the owner on the position manager / execute itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,990 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

owner manages the position directly

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
