---
id: 00000000-rotate-signer-before-migrating
title: "0x00000000: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x000000000804ff442be7d200445362c46a008add"
  family: "f441c4cb49a72abfcfc0ccbd58df3d5d"
  copies: 3
  upgradeable: "yes"
  admin: "owner EOA 0xddf32240b4ca3184de7ec8f0d5aba27dec8b7a5c"
  rating: LOW
  txs_90d: 26339
  last_active: 2026-11-18
  recoveries_14d: 1174
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xddf3…7a5c"
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
  note: "setter and upgrade held by a live EOA."
---

## Summary

Upgradeable verifying paymaster; sponsorship needs the stored verifying signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateVerifyingSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- updateVerifyingSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0xddf32240… EOA, nonce 127; UUPS impl 0x084d6307…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 26,339 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,174 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls updateVerifyingSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
