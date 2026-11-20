---
id: 0fb6e8ec-signed-shortcut-lost
title: "0x0fb6e8ec: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x0fb6e8ecd8ca55c79122f4e114fb46afe1924089"
  family: "3b68a91f800e64356492b5f384579200"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3726
  last_active: 2026-11-17
  recoveries_14d: 470
fix:
  layer: offchain
  who_acts: "the user (acts on the target protocol directly)"
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
  note: "relay/automation convenience lost; nothing held for the user → LOW. Bytecode only, no source"
---

## Summary

Unverified operator automation contract: executeMulticallWithUserOrder runs a multicall on a user's order signed by that user; with code at the user, recovery fails and the order reverts.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: automation by user orders (by its function names): the user named signs; a service. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- selectors at block: executeMulticallWithUserOrder, executeMulticallWithAgentAllowance, cancelOrder, grantOperator, sweep*; AccessControl/pausable
- no ERC-1271 selector in code
- the contract holds no user positions (only sweep functions); orders act on user approvals, so the user can do the same acts directly on the target protocols
- txs_90d 3726, recoveries_14d 470

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,726 transactions called it in the 90 days before that block; last on 2026-11-17.
- 470 signature recoveries in the study's two-week trace window.

## Remediation

user performs the actions directly or via its own smart account; operator may add ERC-1271 in a new deployment

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
