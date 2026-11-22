---
id: 149e280c-rotate-signer-before-migrating
title: "0x149e280c: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x149e280cc6597a461eab7db69c66a5c09a04caa5"
  family: "fb29630b5be431a7557b6e80bf76269b"
  upgradeable: "no"
  rating: LOW
  value_usd: 138951
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7068
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "Safe at slot0"
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
  verdict: confirmed
  rating: LOW
  note: "setter + live Safe"
---

## Summary

Unverified ERC-1271 contract whose validity depends on operator set by setOperator.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ERC-1271 contract with an operator that setOperator replaces. Bytecode and names.
- setOperator 0x558a7297 requires msg.sender == slot0 (heimdall)
- slot0 = 0xdfe83a7d… Safe, 3 of 5 owners (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $138,951 (ETH and 49 priced tokens).
- Activity: 7,068 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

slot0 Safe sets new operator

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
