---
id: prelaunchdistribution-93eaca7b-rotate-signer-before-migrating
title: "PrelaunchDistribution: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x93eaca7be5ead8f319fcd9f31cfeee8bcc6ce487"
  family: "706844b29c85768682277a8a9a02e297"
  name: "PrelaunchDistribution"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5888
  last_active: 2026-11-17
  recoveries_14d: 700
fix:
  layer: onchain-config
  who_acts: "admin EOA 0x2a05…5b5f"
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
  note: "setter callable by a live EOA."
---

## Summary

PrelaunchDistribution: claims signed by the stored issuer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- PrelaunchDistribution.sol:85 setIssuer onlyAdmin; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- admin() = 0x2a05a3e3… EOA, nonce 25

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5,888 transactions called it in the 90 days before that block; last on 2026-11-17.
- 700 signature recoveries in the study's two-week trace window.

## Remediation

Admin calls setIssuer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
