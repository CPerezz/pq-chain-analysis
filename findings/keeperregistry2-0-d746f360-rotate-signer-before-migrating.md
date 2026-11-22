---
id: keeperregistry2-0-d746f360-rotate-signer-before-migrating
title: "KeeperRegistry2_0: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd746f3601ea520baf3498d61e1b7d976dbb33310"
  family: "ce352dafd798bd0fbdc1da708e27f2c8"
  name: "KeeperRegistry2_0"
  upgradeable: "no"
  rating: LOW
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-11
fix:
  layer: onchain-config
  who_acts: "owner Safe"
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
  note: "There is a setter and a live 4-of-12 Safe owner."
---

## Summary

Chainlink KeeperRegistry2_0: reports must be signed by enough distinct signers of the stored OCR config (raw ecrecover).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: each recovered address must be an active signer of the stored configuration; enough distinct signers are counted. Read from source.
- KeeperRegistry2_0.sol:279-286 setConfig(signers,…) onlyOwner replaces the signer set
- owner 0xcc4b…950d is a Safe, threshold 4, 12 owners

## Impact and exposure

- Value held at block 26,438,999: $18,407 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-11.

## Remediation

Owner Safe calls setConfig with new signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
