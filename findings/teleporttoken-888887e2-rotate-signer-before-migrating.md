---
id: teleporttoken-888887e2-rotate-signer-before-migrating
title: "TeleportToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x888887e2d0e716ba1ecf857fe0f2a49125655288"
  family: "6312e4721c06f91aabd35fbe182dcc9e"
  copies: 2
  name: "TeleportToken"
  label: "Alien Worlds Trilium: TLM Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6384
  last_active: 2026-11-18
  recoveries_14d: 255
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x0c09…8815"
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

TeleportToken: claims need threshold (3) distinct oracle signatures; an oracle with code is skipped.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: TeleportToken recoverSigner: returns the signer or zero / TeleportToken claim: signatures of distinct oracles are counted, others skipped; the count must reach the threshold. Read from source. Executed: a real transaction is unaffected by code at the signer.
- TeleportToken.sol:181 regOracle / :187 unregOracle onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x0c09eea3… EOA, nonce 6

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6,384 transactions called it in the 90 days before that block; last on 2026-11-18.
- 255 signature recoveries in the study's two-week trace window.

## Remediation

Owner registers replacement oracles.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
