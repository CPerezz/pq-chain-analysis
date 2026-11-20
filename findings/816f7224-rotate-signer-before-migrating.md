---
id: 816f7224-rotate-signer-before-migrating
title: "0x816f7224 (tagged Orderly Network: Vault): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x816f722424b49cf1275cc86da9840fbd5a6167e9"
  family: "de3f7a67285bf43cf0b963df0652511c"
  copies: 2
  label: "Orderly Network: Vault"
  upgradeable: "yes"
  rating: LOW
  value_usd: 4463760
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1434
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "Orderly owner (Safe 2/3)"
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
  note: "Setter plus a live Safe owner: LOW."
---

## Summary

Orderly Network vault (EIP-1967 proxy). The swap signer in slot 0xa8 is checked by ECDSA only; delegate swaps revert if it takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setCCTPConfig, setCrossChainManager). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- reading de3f7a67: rotation by the owner via selector 0x80ca29f4
- owner() = 0x4e834Ca9, a Safe with threshold 2 of 3 owners; 1967 admin 0xa2ea0a58 has owner() = the same Safe

## Impact and exposure

- Value held at block 26,438,999: $4.5M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,434 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The owner Safe sets a new swap signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
