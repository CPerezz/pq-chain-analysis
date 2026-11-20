---
id: designatedvotingfactory-de7c02ad-entry-by-own-signature-only
title: "DesignatedVotingFactory: entry only by one's own signature"
status: not-affected
severity: NONE
patterns: [PQ-21]
impact: none
contracts:
- address: "0xde7c02ad2b925587bd16724810f994a2948c4a38"
  family: "526eb915c67baa4e2c4a749ea5d2e7af"
  name: "DesignatedVotingFactory"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`DesignatedVotingFactory` at `0xde7c02ad2b925587bd16724810f994a2948c4a38`. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: UMA Voting snapshotCurrentRound: the caller must sign the snapshot message; a caller with code cannot. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Add a direct call or ERC-1271 to the entry path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
