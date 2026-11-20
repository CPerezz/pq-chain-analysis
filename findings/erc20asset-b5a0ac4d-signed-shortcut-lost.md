---
id: erc20asset-b5a0ac4d-signed-shortcut-lost
title: "ERC20Asset: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb5a0ac4dcf22010213989258cb08c50f0f56c605"
  family: "195f669c5dec8824bfeb1275245dd53f"
  copies: 1598
  name: "ERC20Asset"
  upgradeable: "no"
  rating: LOW
  txs_90d: 51363
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

ERC20Asset: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source. Executed: a real transaction reverts with code at the signer.
- approve(address,uint256) is the holder's direct path
- row note: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source. Executed: a real transaction reverts with code at the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 1,598 addresses).
- Activity: 51,363 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
