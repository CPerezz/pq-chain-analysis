---
id: mintedtokencappedcrowdsale-cf5839f8-rotate-signer-before-migrating
title: "MintedTokenCappedCrowdsale: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcf5839f8309f6315749c084d5c5eb8e35aca2439"
  family: "ca3f26dd0e923ed0b881dba58a751f07"
  copies: 2
  name: "MintedTokenCappedCrowdsale"
  upgradeable: "no"
  rating: LOW
  value_usd: 1210679
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "crowdsale owner (EOA)"
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
  note: "LOW: live EOA owner. The sale may be closed."
---

## Summary

MintedTokenCappedCrowdsale. investWithSignedAddress checks a server signature against signerAddress.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- reading ca3f26dd: owner setter setRequireSignedAddress
- owner() = 0xFeAACDBB (EOA, nonce 506)

## Impact and exposure

- Value held at block 26,438,999: $1.2M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sets a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
