---
id: version-073c4ea5-entry-by-own-signature-only
title: "Version: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x073c4ea5a89d0e5aa0408a1b6dd8bbfcdba985c0"
  family: "bb9157d2bcfaa25dea3fa3e370bb8e5a"
  copies: 5
  name: "Version"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the fund manager (sign from an EOA)"
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
  note: "Entry only; nothing held is behind the signature."
---

## Summary

Melonport competition Version: setupFund requires termsAndConditionsAreSigned (ecrecover == msg.sender). A manager with code cannot create a fund.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Melonport Version termsAndConditionsAreSigned: the caller must sign the terms to create a fund; a caller with code cannot. Read (function text).
- source/Version.sol L2790-2824: the signature gates only setupFund
- shutDownFund (L2828) needs no signature; Version holds no assets (funds hold them)
- state.json: 0 ETH at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
