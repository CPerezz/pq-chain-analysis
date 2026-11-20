---
id: 6a9d5e41-rotate-signer-before-migrating
title: "0x6a9d5e41: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x6a9d5e41a227f0b52072568ced39a703d8c893d6"
  family: "1438797960198e4b9172b8e351d8a2d2"
  copies: 3
  upgradeable: "yes"
  rating: NONE
  value_usd: 3
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

Contract `0x6a9d5e41a227f0b52072568ced39a703d8c893d6`, with 2 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ee56db4b: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself…. Template.
- Not affected: the reading for this address says the owner is checked through SignatureChecker, so an owner with code is asked through ERC-1271, or that a real transaction was unaffected by code at the signer (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
