---
id: 10735575-rotate-signer-before-migrating
title: "0x10735575: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10735575e14fc4ed86d68fea5bcbdc2455c7154a"
  family: "e9da47a7c47e4f5076499adad0f9732b"
  upgradeable: "no"
  rating: LOW
  value_usd: 68754
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "operator/owner EOA 0xb9e2…24c7"
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
  note: "Operator-gated setter verified by simulation; active EOA."
---

## Summary

Unverified contract with one stored signer checked by ecrecover; a signer with code makes signed calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner(address) simulated at block 26438999: succeeds from 0xb9e29984…24c7, reverts from a random caller with ONLY_CONTRACT_OPERATOR
- owner() = operator() = 0xb9e29984…24c7, an EOA with nonce 754

## Impact and exposure

- Value held at block 26,438,999: $68,754 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator calls setSigner with a fresh EOA key before migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
