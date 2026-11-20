---
id: pangeadvn-5fa03555-rotate-signer-before-migrating
title: "PangeaDVN: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5fa03555f186e53a644405817e1beac894bd6562"
  family: "4182627aab6a850c13e186cbe177a088"
  name: "PangeaDVN"
  upgradeable: "no"
  rating: LOW
  txs_90d: 13749
  last_active: 2026-11-18
  recoveries_14d: 606
fix:
  layer: onchain-config
  who_acts: "admin EOA 0x9362…8ab6"
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

LayerZero PangeaDVN: verifications need a quorum of distinct stored signers.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (approver, oracle, attester or author) and distinct; enough of them are needed. Read from source. Executed: a real transaction reverts with code at the signer.
- PangeaDVN.sol:298 setSigners(address[],uint8) onlyAdmin; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- admin() = 0x93620a4a… EOA, nonce 6923

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 13,749 transactions called it in the 90 days before that block; last on 2026-11-18.
- 606 signature recoveries in the study's two-week trace window.

## Remediation

Admin calls setSigners with new keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
