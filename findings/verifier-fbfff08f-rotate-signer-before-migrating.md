---
id: verifier-fbfff08f-rotate-signer-before-migrating
title: "Verifier: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfbfff08fe4169853f7b1b5ac67ec10dc8806801d"
  family: "8979ad2d81e5e92c66e4edcda374e97a"
  name: "Verifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 24342
  last_active: 2026-11-18
  recoveries_14d: 38024
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x5c47…6aac)"
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
  note: "setter held by a live Safe."
---

## Summary

Chainlink Data Streams Verifier v0.5: reports need f+1 distinct signers of the config; a signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (oracle, committee member, validator) and distinct; a quorum is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Verifier.sol:274 setConfig(configDigest,signers,f,…) onlyOwner
- owner() = 0x5c4785fd…, a 4-of-8 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 24,342 transactions called it in the 90 days before that block; last on 2026-11-18.
- 38,024 signature recoveries in the study's two-week trace window.

## Remediation

Owner sets a new config with replacement signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
