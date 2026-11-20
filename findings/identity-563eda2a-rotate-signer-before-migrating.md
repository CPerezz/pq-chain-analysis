---
id: identity-563eda2a-rotate-signer-before-migrating
title: "Identity: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x563eda2afb088b36a1b3735126c409372a6ef46c"
  family: "c8c4077d1cc1d3b678c20c07a7475ce0"
  copies: 3069
  name: "Identity"
  label: "deployed by Ambire Wallet: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 994854
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 268
  last_active: 2026-11-17
  recoveries_14d: 19
fix:
  layer: onchain-config
  who_acts: "identity privileged key"
evidence:
  level: executed
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
  note: "LOW: setter plus direct path."
---

## Summary

Ambire Identity. The recovered signer must hold a privilege.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered signer must hold a privilege in the identity; privileges are set by the identity itself / isValidSignature: the recovered signer must hold a privilege in the identity. Read from source. Executed: a real transaction reverts with code at the signer.
- reading c8c4077d: the owner keeps executeBySender and the ERC-1271 mode; privileges are set by the identity itself
- family c8c4077d: 3,069 addresses, 461.6 ETH total; isValidSignature does not bind the hash to chain or account

## Impact and exposure

- Value held at block 26,438,999: $994,854 (ETH and 49 priced tokens, over 3,069 addresses).
- Activity: 268 transactions called it in the 90 days before that block; last on 2026-11-17.
- 19 signature recoveries in the study's two-week trace window.

## Remediation

Grant the privilege to a new key or use executeBySender.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
