---
id: e794ffec-rotate-signer-before-migrating
title: "0xe794ffec: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72"
  family: "3a1ff29795951c167c163fc0f92bb1ec"
  copies: 10
  upgradeable: "no"
  rating: LOW
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "pool operations account 0x5d2f2d96… (EOA)"
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
  note: "Setter with a live EOA caller."
---

## Summary

Hashflow pool clone (impl 0xacfaaa9d…): RFQ trades require a quote signed by the stored signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a signer with a setter (updateSigner). Bytecode and names.
- heimdall decompile: updateSigner(address) requires msg.sender == operations ('HashflowPool: Account not authorized')
- pool slot 4 (operations) = 0x5d2f2d96…: EOA, nonce 17; signer at slot 3 = 0xb882b3ee…

## Impact and exposure

- Value held at block 26,438,999: $14,978 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operations calls updateSigner with a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
