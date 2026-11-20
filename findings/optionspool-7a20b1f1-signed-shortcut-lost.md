---
id: optionspool-7a20b1f1-signed-shortcut-lost
title: "OptionsPool: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7a20b1f1f32433e8a4af3bf1aa0e7e3f8e106de1"
  family: "6eba56f31f3c1be2d4433a7cef4f9967"
  copies: 2
  name: "OptionsPool"
  upgradeable: "no"
  rating: NONE
  value_usd: 145
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-18
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

`OptionsPool` at `0x7a20b1f1f32433e8a4af3bf1aa0e7e3f8e106de1`, with 1 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (Compound style): whoever signed delegates; zero rejected. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $145 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-18.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
