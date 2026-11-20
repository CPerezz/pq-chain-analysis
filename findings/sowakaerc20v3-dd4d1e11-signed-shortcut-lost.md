---
id: sowakaerc20v3-dd4d1e11-signed-shortcut-lost
title: "SowakaERC20V3: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xdd4d1e110980e3d63bfdf11f7d9b18553139c0e5"
  family: "849de8153fa2ecee6187f0d9cde8a232"
  copies: 2
  name: "SowakaERC20V3"
  upgradeable: "no"
  rating: LOW
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1520
  last_active: 2026-11-17
  recoveries_14d: 8
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $3609, txs_90d 1520 (not rating inputs)."
---

## Summary

SowakaERC20V3: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked. Read from source.
- source (849de8153fa2ecee6187f0d9cde8a232): signed functions [delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $3,609 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,520 transactions called it in the 90 days before that block; last on 2026-11-17.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
