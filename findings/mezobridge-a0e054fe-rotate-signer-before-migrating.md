---
id: mezobridge-a0e054fe-rotate-signer-before-migrating
title: "MezoBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa0e054fe86c7810592c2d3091acac6a7da02c599"
  family: "741a551bb43c339d6ce30235116b495c"
  copies: 3
  name: "MezoBridge"
  label: "deployed by Threshold Network: Deployer 1"
  upgradeable: "no"
  rating: LOW
  value_usd: 6654856
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6972
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "bridge owner (Safe 4/7)"
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
  note: "LOW for the live bridge. The row address is an uninitialised implementation with no owner; nothing is held there."
---

## Summary

MezoBridge (Threshold). Validator batch attestations are recovered; a validator with code stops counting but can attest by direct call.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (signer, validator, authority, relayer), distinct or ordered; a quorum or weight is needed. Read from source.
- setter: addBridgeValidator/removeBridgeValidator onlyOwner (Ownable2StepUpgradeable)
- the row address is a bare implementation: owner() = 0, no proxy slot, 0 ETH
- the live family proxy 0xf6680ea3 (impl 0x58d28da1) has owner() = 0x98D8899c, a Safe with getThreshold 4 of 7 owners

## Impact and exposure

- Value held at block 26,438,999: $6.7M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 6,972 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner Safe rotates validators; validators attest directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
