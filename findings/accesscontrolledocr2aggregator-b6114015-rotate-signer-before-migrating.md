---
id: accesscontrolledocr2aggregator-b6114015-rotate-signer-before-migrating
title: "AccessControlledOCR2Aggregator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb611401574061947abac7d2406711f115be22a6e"
  family: "094a5af90fa2fcbca2ead3fb7d8a74ac"
  copies: 382
  name: "AccessControlledOCR2Aggregator"
  upgradeable: "no"
  rating: LOW
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1041089
  last_active: 2026-11-18
  recoveries_14d: 128836
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x21f73D42…73CA"
evidence:
  level: source-read
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
  note: "Owner setter, live Safe."
---

## Summary

Chainlink OCR2 aggregator: reports need a quorum of distinct signer ecrecovers. Signers with code fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (oracle, committee member, validator) and distinct; a quorum is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- OCR2Aggregator.sol:611 ecrecover per signer; setConfig (196) replaces the signer set (standard onlyOwner)
- owner() = 0x21f73D42Eb58Ba49dDB685dc29D3bF5c0f0373CA, a Safe, 4 of 9 owners

## Impact and exposure

- Value held at block 26,438,999: $3,068 (ETH and 49 priced tokens, over 382 addresses).
- Activity: 1,041,089 transactions called it in the 90 days before that block; last on 2026-11-18.
- 128,836 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setConfig with new signer keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
