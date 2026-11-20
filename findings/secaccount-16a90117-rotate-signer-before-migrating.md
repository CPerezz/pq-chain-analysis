---
id: secaccount-16a90117-rotate-signer-before-migrating
title: "SecAccount: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x16a90117bcb95a787323023613629730c803380e"
  family: "1fc3ddeb66671f4eeea7a5a646f2798d"
  copies: 31
  name: "SecAccount"
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

`SecAccount` at `0x16a90117bcb95a787323023613629730c803380e`, with 30 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ee56db4b: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself…. Template.
- Not affected: the reading for this address says the owner is checked through SignatureChecker, so an owner with code is asked through ERC-1271, or that a real transaction was unaffected by code at the signer (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens, over 31 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
