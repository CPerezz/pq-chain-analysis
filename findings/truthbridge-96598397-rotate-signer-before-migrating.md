---
id: truthbridge-96598397-rotate-signer-before-migrating
title: "TruthBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x965983977c29158ec53a296a6f47be145ddecc36"
  family: "043cea7a492572278b66a8e6f9976fe9"
  copies: 4
  name: "TruthBridge"
  label: "Truth: Node Rewards Distributor"
  upgradeable: "yes"
  admin: "Safe 0x1B3cA21fe2A490635554e1B531Db9fD786C1947B (2/6) on proxy 0x50c02710"
  rating: LOW
  value_usd: 44934
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1235
  last_active: 2026-11-18
  recoveries_14d: 239
fix:
  layer: onchain-config
  who_acts: "bridge authors (key holders) or proxy owner Safe 0x1B3cA21f"
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
  note: "Key holders can rotate themselves and a live Safe controls the upgrade."
---

## Summary

TruthBridge implementation; the live proxy 0x50c02710 runs it. Lowers and roots need a quorum of author signatures recovered via raw ecrecover → t1AddressToId; an author with code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (validator, attester, author, oracle), distinct or ordered; a quorum or weight is needed / returns the recovered address or its id to a…. Read from source.
- The row address is the implementation: owner()=0, numActiveAuthors()=0, empty slots; the scanner context is proxy 0x50c02710b06d6addb864d6b038010ef6fa1bcd92 (impl slot → 0x9659…)
- TruthBridge.sol:150-200 addAuthor/removeAuthor rotate authors on author confirmations; _authorizeUpgrade onlyOwner
- Proxy at block 26438999: owner = Safe 0x1B3cA21fe2A490635554e1B531Db9fD786C1947B (threshold 2 of 6 owners), numActiveAuthors = 5

## Impact and exposure

- Value held at block 26,438,999: $44,934 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,235 transactions called it in the 90 days before that block; last on 2026-11-18.
- 239 signature recoveries in the study's two-week trace window.

## Remediation

Authors rotate a migrating key out via removeAuthor/addAuthor, or the Safe upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
