---
id: 2bd45d29-rotate-signer-before-migrating
title: "0x2bd45d29 (tagged Alchemy: Paymaster 1): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2bd45d293f1e3b790f2923fb36782170b559d84c"
  family: "694a18490b049ed7f926b640ab13364a"
  copies: 3
  label: "Alchemy: Paymaster 1"
  upgradeable: "yes"
  admin: "owner EOA 0x4f0cf2a1d11de183e989ff6287cc0973670f0583"
  rating: LOW
  txs_90d: 41301
  last_active: 2026-11-18
  recoveries_14d: 4357
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x4f0c…0583"
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
  note: "setter callable by a live EOA."
---

## Summary

Upgradeable verifying paymaster: user operations need the stored verifying signer; a signer with code fails sponsorship.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateVerifyingSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- updateVerifyingSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts (Ownable revert)
- owner() = 0x4f0cf2a1… EOA, nonce 35; also upgradeable (impl 0xa91dc668…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 41,301 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,357 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls updateVerifyingSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
