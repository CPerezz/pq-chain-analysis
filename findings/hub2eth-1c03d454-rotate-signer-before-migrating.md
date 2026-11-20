---
id: hub2eth-1c03d454-rotate-signer-before-migrating
title: "Hub2Eth: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1c03d454272382aaff97b46fe0f6cd66a65857c1"
  family: "dc0e406338c9b926bb8b1a017ac235b3"
  copies: 2
  name: "Hub2Eth"
  label: "deployed by Minter Network: Deployer 1"
  upgradeable: "no"
  rating: LOW
  value_usd: 43309
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 219
  last_active: 2026-11-17
  recoveries_14d: 14
fix:
  layer: onchain-config
  who_acts: "current validator set (key holders)"
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
  note: "The key holders themselves rotate the set and are seen signing."
---

## Summary

Hub2Eth (Gravity fork, Minter): batches and valset updates need weighted validator signatures via ecrecover. A validator with code loses its power.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Hub2Eth (Gravity fork): the validator set is replaced by updateValset. Read by hand.
- Hub2Eth.sol:714 updateValset: anyone may call with signatures of the current valset above the power threshold
- Hub2Eth.sol:641 _signer == ecrecover(...), no 1271
- Active: 219 txs in 90 days; the family copy 0x897c27fa shows 14 recoveries in the window up to block 26437080 (validators signing)

## Impact and exposure

- Value held at block 26,438,999: $43,309 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 219 transactions called it in the 90 days before that block; last on 2026-11-17.
- 14 signature recoveries in the study's two-week trace window.

## Remediation

Validators sign a new valset that drops or replaces the migrating key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
