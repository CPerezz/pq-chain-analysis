---
id: bridge-31341687-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x313416870a4da6f12505a550b67bb73c8e21d5d3"
  family: "e3292b2ff17d314660a5f87bcf4548d4"
  name: "Bridge"
  label: "Sora: HASHI"
  upgradeable: "no"
  rating: LOW
  value_usd: 611565
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 472
  last_active: 2026-11-16
  recoveries_14d: 6
fix:
  layer: onchain-config
  who_acts: "current peers (2/3 quorum)"
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
  note: "Rotation path live as long as quorum of peers stays EOA; peers are the key holders."
---

## Summary

Sora bridge: releases funds on 2/3 of distinct stored peer signatures; a peer with code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Sora bridge checkSignatures: signatures of distinct peers are counted, others skipped; two thirds of the peers are needed; peers are added and removed by calls the current peers sign / Sora bridge…. Read from source.
- addPeerByPeer/removePeerByPeer, signed by a quorum of current peers (reading.keys)
- peersCount=3 (state.json slot_2); no owner/admin

## Impact and exposure

- Value held at block 26,438,999: $611,565 (ETH and 49 priced tokens).
- Activity: 472 transactions called it in the 90 days before that block; last on 2026-11-16.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Remaining EOA peers sign removal/replacement of a peer before (or after) it takes code, while a quorum stays EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
