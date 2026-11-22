---
id: citizenchartersale-e3bda258-rotate-signer-before-migrating
title: "CitizenCharterSale: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe3bda2582594eef116c6acc63dc89a60f7cc4b17"
  family: "2b4c53bb9e7507f7c1de8c74f1dc32d1"
  name: "CitizenCharterSale"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1562
  last_active: 2026-10-08
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xfeb8a535 (3-of-5)"
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
  note: "The setter is callable by a live Safe owner. Last active 2026-10-08."
---

## Summary

CitizenCharterSale. The sale checks signatures from a stored allocator. Under EIP-8151 an allocator with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAllocator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall: setAllocator(address) requires msg.sender == owner, non-reentrant, nonzero
- probed owner Safe 0xfeb8a535 3-of-5 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,562 transactions called it in the 90 days before that block; last on 2026-10-08.

## Remediation

The Safe calls setAllocator with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
