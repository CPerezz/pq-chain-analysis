---
id: aggregator-2f68417a-rotate-signer-before-migrating
title: "Aggregator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2f68417a18da681589f4ea64b9cc9839209acff7"
  family: "e1f15b474e4fba9c98544ed5a5a5c0d8"
  copies: 3
  name: "Aggregator"
  upgradeable: "yes"
  admin: "Safe 0x21835332cbdf1b3530fae9f6cd66feb9477dfc02"
  rating: LOW
  txs_90d: 38509
  last_active: 2026-11-18
fix:
  layer: contract-upgrade
  who_acts: "owner (Safe 0x2183…fc02)"
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
  note: "LOW holds via the live upgrade path, not via a setter; the setter claim in the note is unconfirmed."
---

## Summary

UUPS Aggregator; the study names SWAP_EXECUTOR as the replaceable key, but SWAP_EXECUTOR() returns a contract address and no signer setter appears in the implementation's selectors.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (SWAP_EXECUTOR). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- implementation 0xb480bd00… exposes only Ownable + upgradeToAndCall among admin functions; no signer setter found
- upgradeToAndCall(currentImpl,0x) succeeds by eth_call from owner 0x21835332… (3-of-7 Safe) and reverts from 0x…dEaD

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 38,509 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner Safe upgrades the implementation to rotate the key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
