---
id: lightaccount-07978dad-rotate-signer-before-migrating
title: "LightAccount: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x07978dad11e3797695f9a8c6f7523cc58e5b5015"
  family: "a286e26eac8b5b4fbd25e9fb04d445f1"
  copies: 7
  name: "LightAccount"
  upgradeable: "yes"
  rating: NONE
  value_usd: 110
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`LightAccount` at `0x07978dad11e3797695f9a8c6f7523cc58e5b5015`, with 6 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ee56db4b: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself…. Template.
- Not affected: the reading for this address says the owner is checked through SignatureChecker, so an owner with code is asked through ERC-1271, or that a real transaction was unaffected by code at the signer (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $110 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
