---
id: perpetuallib-258678a2-entry-by-own-signature-only
title: "PerpetualLib: entry only by one's own signature"
status: not-affected
severity: NONE
patterns: [PQ-21]
impact: none
contracts:
- address: "0x258678a2f13d32f1e031c81162ff58ea0f870d31"
  family: "18f635d89af4fc91e118ef49ad4c87bc"
  copies: 2
  name: "PerpetualLib"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "No ecrecover call in the bytecode, so EIP-8151 has no effect here."
---

## Summary

UMA PerpetualLib: deployed library/factory. Its verified multi-file source bundle includes Voting.sol (snapshotCurrentRound), but that code is not deployed at this address.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: UMA Voting snapshotCurrentRound: the caller must sign the snapshot message; a caller with code cannot. Read (function text).
- facts.json: kind '5 or 6: no recovery found in its bytecode', representative_code.n_ec=0, complete=true (~/dev/pq-chain-analysis/goals/eip-8151-analysis/gate1/readings/18f635d89af4fc91e118ef49ad4c87bc)
- snapshotCurrentRound(bytes) selector 0x110d559a not present in the dossier code.hex
- state.json: 0 ETH at block 26438999; 0 recoveries in the window

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None; drop the row (the study matched a source file in the bundle, not the deployed contract).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
