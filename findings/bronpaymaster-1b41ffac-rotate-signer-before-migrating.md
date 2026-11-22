---
id: bronpaymaster-1b41ffac-rotate-signer-before-migrating
title: "BronPaymaster: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1b41ffaca6450020e0e6c757db91fcbef327dce1"
  family: "b22797544c6e62cbce16b6579fac13a9"
  copies: 2
  name: "BronPaymaster"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5491
  last_active: 2026-11-17
  recoveries_14d: 958
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xa5b7…4ad7"
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

BronPaymaster: sponsorship needs the stored verifying signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- BronPaymaster.sol:85 setVerifyingSigner onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0xa5b7329f… EOA, nonce 20

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5,491 transactions called it in the 90 days before that block; last on 2026-11-17.
- 958 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setVerifyingSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
