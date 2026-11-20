---
id: smartvault-2452b803-rotate-signer-before-migrating
title: "SmartVault: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2452b803e81d7eee43b283d234a875528d2c5a50"
  family: "22475f9126f5edd254ac3cba0ba1d5f6"
  copies: 748
  name: "SmartVault"
  label: "deployed by Pimlico: ERC-4337 Bundler 3"
  upgradeable: "yes"
  rating: NONE
  value_usd: 868715
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16655
  last_active: 2026-11-18
  recoveries_14d: 40
fix:
  layer: none
  who_acts: "vault owner"
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
  note: "ERC-1271 for the same signer: refuted (otherwise LOW)."
---

## Summary

SmartVault 4337 account. Solady SignatureCheckerLib on stored signers: ecrecover, then ERC-1271 on the signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SmartVault signer check: Solady SignatureCheckerLib on a stored signer (ecrecover, then the signer's ERC-1271). Read from source. Executed: a real transaction reverts with code at the signer.
- reading 22475f91: falls through to the signer's ERC-1271; the owner, passkey and other signers remain
- family 22475f91: 748 addresses, 243.2 ETH total; least spare gas traced 110,777, well above the 3,100 cold-recovery surcharge

## Impact and exposure

- Value held at block 26,438,999: $868,715 (ETH and 49 priced tokens, over 748 addresses).
- Activity: 16,655 transactions called it in the 90 days before that block; last on 2026-11-18.
- 40 signature recoveries in the study's two-week trace window.

## Remediation

The signer's code implements ERC-1271, or the owner swaps signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
