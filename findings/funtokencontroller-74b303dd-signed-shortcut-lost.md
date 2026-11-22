---
id: funtokencontroller-74b303dd-signed-shortcut-lost
title: "FUNTokenController: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x74b303dd79bbf44d23d60891bdd0f31df87bc7b8"
  family: "e4dc6ee7d871b6390a7860faa16a623d"
  name: "FUNTokenController"
  upgradeable: "no"
  rating: LOW
  txs_90d: 39482
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
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
  note: "LOW holds on substance: a participant with code sends the call itself. Template note is wrong (not Wyvern); only fails if both participants have code. Attention: template mismatch; decompiled rather than read from source."
---

## Summary

FunFair FUNTokenController: fate-channel opening (selector 0xa26d4a81) checks by ecrecover the signature of whichever participant (player or house) is not msg.sender; EIP-8151 makes a signer with code fail that check.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template e2853c9a: Wyvern validateOrder: valid if the maker approved it on chain by its own call, or signed it. Template.
- heimdall decompile at block: 0xa26d4a81 requires msg.sender to be a participant; if the player is not the sender the player's signature is checked, else the house signature is checked
- so either participant can open by sending itself, needing only the other side's signature; no ERC-1271
- the row's template note (Wyvern validateOrder) does not match this bytecode; owner() = 0x41211648c51acb9a5f39a93c657e894a0bdb88e4 (facts)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 39,482 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
