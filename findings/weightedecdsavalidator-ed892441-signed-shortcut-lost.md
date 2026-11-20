---
id: weightedecdsavalidator-ed892441-signed-shortcut-lost
title: "WeightedECDSAValidator: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xed89244160cfe273800b58b1b534031699dfeeee"
  family: "cb2cbf36aea2370a461e2eeee7d205a3"
  name: "WeightedECDSAValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7389
  last_active: 2026-11-18
  recoveries_14d: 1001
fix:
  layer: none
  who_acts: "guardian (direct approve) or the Kernel account (renew)"
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
  note: "Direct approve open to the same guardian."
---

## Summary

Kernel WeightedECDSAValidator: guardian approveWithSig votes fail for a guardian whose address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Kernel weighted validator approveWithSig: guardians of the account vote by signature; a guardian can also approve by its own call; the account replaces guardians with renew / Kernel weighted…. Read from source. Executed: a real transaction reverts with code at the signer.
- src/validator/WeightedECDSAValidator.sol:141 approve(bytes32,address) lets a guardian vote by its own call
- WeightedECDSAValidator.sol:121 renew(...) lets the account replace guardians

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,389 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,001 signature recoveries in the study's two-week trace window.

## Remediation

Guardian calls approve directly; account can renew guardians.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
