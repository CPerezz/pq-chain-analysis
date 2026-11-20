---
id: facility-af895c51-rotate-signer-before-migrating
title: "Facility: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xaf895c514d2448150b67f3c0b828250bd947ce7e"
  family: "af9cc07b5dd599ac17f3ca1bb1dc1a30"
  copies: 2
  name: "Facility"
  upgradeable: "no"
  rating: NONE
  value_usd: 152846
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5052
  last_active: 2026-11-17
  recoveries_14d: 12
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
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
  note: "code at the signer is routed to ERC-1271; the executed revert only shows the test code lacks isValidSignature"
---

## Summary

Facility guardian quorum uses Solady SignatureCheckerLib.isValidSignatureNowCalldata.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: recover here returns an order's funds; no signature / a loop of recoveries: each signer must be in the stored set (validator, operator, guardian, admin, owner), distinct or ordered; a threshold is…. Read from source. Executed: a real transaction reverts with code at the signer.
- FacilityRoles._checkSignatures → SignatureCheckerLib (lib/grunt/src/facility/base/FacilityRoles.sol:43)
- SignatureCheckerLib: extcodesize(signer)!=0 → ERC-1271 isValidSignature, never ecrecover

## Impact and exposure

- Value held at block 26,438,999: $152,846 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5,052 transactions called it in the 90 days before that block; last on 2026-11-17.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

none needed; a signer with code must answer ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
