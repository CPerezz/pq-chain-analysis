---
id: cebfc5df-rotate-signer-before-migrating
title: "0xcebfc5df: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcebfc5dfbd5ce21694fe2acefa63ad6f828831d2"
  family: "c41a1cf301b820318a861b43076ed11c"
  copies: 3
  upgradeable: "no"
  rating: LOW
  value_usd: 22016
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner Safe"
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
  note: "There is an Ownable setter and a live 3-of-5 Safe owner. The contract is paused at the block, which does not change the rating."
---

## Summary

Unverified bridge/refund contract: signer and market-maker signer maps are kept in storage. A signer that gets code fails recovery.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setExternalBridgeRouter, setMarketMakerSigner, setRefundExecutor, setSigner). Whoever holds it must replace it before that account…. Rule: stored-key.
- decompiled: 0x31cb6105 (emits SignerUpdated) and 0x90238882 (MMSignerUpdated) both require msg.sender == owner (Ownable)
- owner 0x83fc…906b is a Safe, threshold 3, 5 owners; paused()=true

## Impact and exposure

- Value held at block 26,438,999: $22,016 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner Safe updates the signer maps to keys without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
