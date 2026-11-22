---
id: 5d0ae8cb-rotate-signer-before-migrating
title: "0x5d0ae8cb: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d0ae8cbad6a88eda0fbe5e916992f9aed417bbb"
  family: "4c7e2b3086e8a8b1c5535c5cbf61b27a"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5672
  last_active: 2026-11-18
  recoveries_14d: 604
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xc87d…1920"
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
  note: "add and remove issuer both callable by a live EOA."
---

## Summary

VoucherPaymaster: vouchers signed by an active issuer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (removeIssuer). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- decompile: 0xfb2a7e83(address,uint32) activates an issuer, requires msg.sender == owner; eth_call from owner succeeds, from 0x…dEaD reverts 0x82b42900; removeIssuer(address) also owner-gated
- owner() = 0xc87d11ae… EOA, nonce 11

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5,672 transactions called it in the 90 days before that block; last on 2026-11-18.
- 604 signature recoveries in the study's two-week trace window.

## Remediation

Owner activates a new issuer and removes the old.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
