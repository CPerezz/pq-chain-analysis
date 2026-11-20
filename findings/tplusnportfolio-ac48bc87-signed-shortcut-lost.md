---
id: tplusnportfolio-ac48bc87-signed-shortcut-lost
title: "TPlusNPortfolio: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xac48bc871f6712bafa956d27a69ee4956f0d428e"
  family: "7d87a95008512487f9254d4b38f4c3f3"
  copies: 11
  name: "TPlusNPortfolio"
  label: "Endaoment: Beverly Hills Private Wealth SMA Portfolio"
  upgradeable: "no"
  rating: NONE
  txs_90d: 21
  last_active: 2026-11-03
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
  ref: "triage entry eip-8151-signed-shortcut-lost"
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

`TPlusNPortfolio` at `0xac48bc871f6712bafa956d27a69ee4956f0d428e` (Etherscan tag: Endaoment: Beverly Hills Private Wealth SMA Portfolio), with 10 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: ERC20 permit (variant). Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 21 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
