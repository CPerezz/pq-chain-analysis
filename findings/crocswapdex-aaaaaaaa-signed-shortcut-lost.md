---
id: crocswapdex-aaaaaaaa-signed-shortcut-lost
title: "CrocSwapDex: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xaaaaaaaaa24eeeb8d57d431224f73832bc34f688"
  family: "c755b7634a69a4917ce374771113fd54"
  name: "CrocSwapDex"
  label: "Ambient Finance: Croc Swap Dex"
  upgradeable: "yes"
  rating: LOW
  value_usd: 164576
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 15241
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the client"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same command is open by direct call: LOW."
---

## Summary

Ambient CrocSwapDex: a relayer can submit a command signed by the client. A client with code loses the relayed route; it can send the same command itself with userCmd.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Ambient overCurve: no signature (matched on a word) / Ambient recoverCmd: no signature (matched on a word) / Ambient relayer call: whoever signed is the client; the client can send the same command…. Read from source.
- userCmd(uint16,bytes) 0xa15112f9 in runtime code at block 26438999
- Row note: the client can send the same command directly
- overCurve/recoverCmd matched on a word, no signature

## Impact and exposure

- Value held at block 26,438,999: $164,576 (ETH and 49 priced tokens).
- Activity: 15,241 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The client calls userCmd directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
