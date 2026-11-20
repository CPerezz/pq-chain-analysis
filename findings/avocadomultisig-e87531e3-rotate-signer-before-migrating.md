---
id: avocadomultisig-e87531e3-rotate-signer-before-migrating
title: "AvocadoMultisig: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xe87531e34e042262c03bcbbefcb36ccc45bfe34f"
  family: "99e85c8b47473cb1668e2fc9fa941475, 65a5926d7eb962a1076341cae3553976"
  copies: 519
  name: "AvocadoMultisig"
  label: "deployed by Instadapp: Avocado Broadcaster 1"
  upgradeable: "yes"
  rating: NONE
  value_usd: 12895386
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 959
  last_active: 2026-11-16
  recoveries_14d: 238
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "The code is checked first, so the claim fails."
---

## Summary

AvocadoMultisig (518 proxies). The wallet tests each signer's code first and sends signers with code to ERC-1271 without calling 0x01.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Avocado multisig: each signer must be in the allowed list; a signer with code is taken as a contract signer, otherwise ECDSA.recover must equal it. Read from source. Executed: a real transaction reverts with code at the signer.
- reading 99e85c8b: the EIP changes no outcome; a signer with code is taken as a contract signer
- reading 99e85c8b: _verifySig reads the signer code size before calling ecrecover, so a signer with code never reaches the precompile

## Impact and exposure

- Value held at block 26,438,999: $12.9M (ETH and 49 priced tokens, over 519 addresses).
- Activity: 959 transactions called it in the 90 days before that block; last on 2026-11-16.
- 238 signature recoveries in the study's two-week trace window.

## Remediation

None needed; a migrated signer's code must implement isValidSignature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
