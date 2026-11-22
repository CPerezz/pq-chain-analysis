---
id: dd17d921-rotate-signer-before-migrating
title: "0xdd17d921: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdd17d9216bd1683c8076b13b045bd1331aadccd7"
  family: "f187596f03c7ef6ad4c429e9c472e4ce"
  upgradeable: "no"
  rating: LOW
  txs_90d: 17878
  last_active: 2026-11-18
  recoveries_14d: 117
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x7b99…d3a3"
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

Unverified contract: identity attestations by a stored signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setIdentitySigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setIdentitySigner(address,bool): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x7b99bed4… EOA, nonce 42

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 17,878 transactions called it in the 90 days before that block; last on 2026-11-18.
- 117 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key with the setter before the signer's account takes non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
