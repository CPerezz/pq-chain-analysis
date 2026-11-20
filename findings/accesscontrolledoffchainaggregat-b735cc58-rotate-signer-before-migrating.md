---
id: accesscontrolledoffchainaggregat-b735cc58-rotate-signer-before-migrating
title: "AccessControlledOffchainAggregator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb735cc58d71deac4cfc46de68d3b04988f7d7b2d"
  family: "6b45b05e1d7332651cf9d689f15ce9d6"
  copies: 280
  name: "AccessControlledOffchainAggregator"
  upgradeable: "no"
  rating: LOW
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x21f73d42eb58ba49ddb685dc29d3bf5c0f0373ca (4 of 9)"
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
  note: "LOW: setter callable by a live Safe."
---

## Summary

Chainlink OCR AccessControlledOffchainAggregator: transmit recovers each report signature and requires a distinct configured signer. A signer with code drops out of the quorum.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (approver, oracle, attester or author) and distinct; enough of them are needed. Read from source.
- OffchainAggregator.sol:161-170: setConfig(signers, transmitters, threshold, …) is onlyOwner
- OffchainAggregator.sol:666: ecrecover per signature, checked against s_oracles
- owner = Safe 0x21f73d…: 9 owners, threshold 4 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $12,993 (ETH and 49 priced tokens, over 280 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner Safe calls setConfig with replacement signer keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
