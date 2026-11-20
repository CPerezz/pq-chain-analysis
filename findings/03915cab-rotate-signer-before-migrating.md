---
id: 03915cab-rotate-signer-before-migrating
title: "0x03915cab: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x03915cab1e7a833342039c72af03a2df2d71d7a6"
  family: "38344ceaf5c037b68fa5defbf4235623"
  copies: 6
  upgradeable: "yes"
  rating: NONE
  value_usd: 205
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-09-18
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

Contract `0x03915cab1e7a833342039c72af03a2df2d71d7a6`, with 5 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ee56db4b: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself…. Template.
- Not affected: the reading for this address says the owner is checked through SignatureChecker, so an owner with code is asked through ERC-1271, or that a real transaction was unaffected by code at the signer (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $205 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-18.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
