---
id: validatorannounce-8ebbfe20-entry-by-own-signature-only
title: "ValidatorAnnounce: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x8ebbfe204e7eda4be46b9d09c5dfa8b3e1500462"
  family: "86dc737e382127659ddd6fd0c2b88897"
  copies: 3
  name: "ValidatorAnnounce"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the validator (sign with its EOA validator key)"
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
  verdict: confirmed
  rating: LOW
  note: "Registration metadata only; nothing held."
---

## Summary

Hyperlane ValidatorAnnounce: announce requires the declared validator to sign its storage location. A validator address with code cannot announce.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Hyperlane ValidatorAnnounce announce: the validator named must sign its own announcement. Read (function text).
- ValidatorAnnounce.sol L59-84: the signature only gates publishing storage locations (metadata)
- No funds are held or moved by this contract; state.json: 0 ETH at block 26438999
- Hyperlane validators sign checkpoints offchain with EOA keys by design

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
