---
id: bridge-b323692b-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb323692b6d4db96af1f52e4499a2bd0ded9af3c5"
  family: "8c9ffb6ab93ac1e19a29f1c6e8fda728"
  name: "Bridge"
  upgradeable: "no"
  rating: LOW
  value_usd: 574572
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 81
  last_active: 2026-10-07
fix:
  layer: onchain-config
  who_acts: "current oracles (2/3 quorum)"
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
  note: "Committee-signed rotation, live while quorum stays EOA."
---

## Summary

Oracle-committee bridge unlocking tokens on 2/3 of 9 oracle signatures; an oracle with code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: bridge with an oracle set changed by votes (voteForNewOracleSet). Bytecode and names.
- voteForNewOracleSet with >= (2n+2)/3 current oracle signatures (reading.keys)
- oracleSet length 9 (state.json slot_1); not upgradeable

## Impact and exposure

- Value held at block 26,438,999: $574,572 (ETH and 49 priced tokens).
- Activity: 81 transactions called it in the 90 days before that block; last on 2026-10-07.

## Remediation

Oracles vote a new set before members take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
