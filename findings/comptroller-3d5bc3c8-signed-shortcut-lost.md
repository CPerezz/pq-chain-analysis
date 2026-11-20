---
id: comptroller-3d5bc3c8-signed-shortcut-lost
title: "Comptroller: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3d5bc3c8d13dcb8bf317092d84783c2697ae9258"
  family: "fe4e0478962aaa0601af4fa374042be5"
  copies: 2
  name: "Comptroller"
  label: "Cream.Finance: Comptroller"
  upgradeable: "yes"
  rating: NONE
  value_usd: 708
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-10-04
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

`Comptroller` at `0x3d5bc3c8d13dcb8bf317092d84783c2697ae9258` (Etherscan tag: Cream.Finance: Comptroller), with 1 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Comp delegateBySig: whoever signed delegates. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $708 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-10-04.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
