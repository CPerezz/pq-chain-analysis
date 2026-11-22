---
id: lptokenvault-01bcf8b3-signed-shortcut-lost
title: "LpTokenVault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x01bcf8b3c8b7889c5a753c3d7a43e394399290c4"
  family: "8d47ddd0d854d62072630ec49e4c288f"
  copies: 16
  name: "LpTokenVault"
  upgradeable: "no"
  rating: LOW
  value_usd: 80
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 209
  last_active: 2026-11-13
fix:
  layer: none
  who_acts: "nobody for funds; the team adds ERC-1271 to keep gasless flows"
evidence:
  level: bytecode
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`LpTokenVault` at `0x01bcf8b3c8b7889c5a753c3d7a43e394399290c4`, with 15 more addresses running its code. It lets a user act through an ECDSA signature or by a direct call; a user whose account has code loses the signed path only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the named owner must sign; the holder can call approve itself. Rule: standard permit text.
- Reviewed through the root issue's mechanism: the reading states a direct path for the signed act (approve next to permit, delegate next to delegateBySig, castVote next to castVoteBySig, a direct call next to a meta-transaction, or an order the maker can place or approve on chain), so a holder whose account has code keeps the act: LOW
- Mechanical checks: where the reading names permit, delegateBySig or castVoteBySig, this address's code holds that function and its direct twin; the scanner finds an ecrecover call in the code
- A random sample of 25 of the 18,891 rows below Anon's thresholds: 24 held at LOW, 1 (an NFT exchange whose orders can only be signed) was MEDIUM; readings of that kind were sent to one-by-one checks

## Impact and exposure

- Value held at block 26,438,999: $80 (ETH and 49 priced tokens, over 16 addresses).
- Activity: 209 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
