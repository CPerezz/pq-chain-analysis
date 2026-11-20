---
id: moonbirds-23581767-rotate-signer-before-migrating
title: "Moonbirds: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x23581767a106ae21c074b2276d25e5c3e136a68b"
  family: "aa90cf4ee137c7282b6e58a4d384f57e"
  name: "Moonbirds"
  upgradeable: "no"
  rating: LOW
  value_usd: 7
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3865
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x80d1…d044"
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
  note: "stored-key setter callable by a live Safe"
---

## Summary

Moonbirds ERC-721 with mint signers kept in a stored set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addSigner, grantRole, removeSigner, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- addSigner/removeSigner are onlyOwner in decompile
- owner() = 0x80d154d71f2e1400311c539ef5d08710bd37d044 at block 26438999: Safe, threshold 2 of 4

## Impact and exposure

- Value held at block 26,438,999: $7 (ETH and 49 priced tokens).
- Activity: 3,865 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Safe adds a fresh EOA signer and removes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
