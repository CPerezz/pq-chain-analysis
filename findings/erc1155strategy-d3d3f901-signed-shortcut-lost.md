---
id: erc1155strategy-d3d3f901-signed-shortcut-lost
title: "ERC1155Strategy: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd3d3f901b2d9c587988333f00b154d57fce9dd07"
  family: "ab28790c1ac58a055eed27ae17487e6a"
  copies: 2
  name: "ERC1155Strategy"
  upgradeable: "yes"
  rating: LOW
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 28
  last_active: 2026-11-02
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $14436, txs_90d 28."
---

## Summary

ERC1155Strategy exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source.
- ERC1155Strategy: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $14,436 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 28 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
