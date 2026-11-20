---
id: tree-ba25b228-signed-shortcut-lost
title: "Tree: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xba25b2281214300e4e649fead9a6d6acd25f1c0a"
  family: "0f8dbb87654b187fb278f3a89cd41a2d"
  copies: 4
  name: "Tree"
  label: "Tree: TREE Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1971
  last_active: 2026-11-18
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
  note: "Permit has a direct twin (EIP-2612 standard); read from the selectors only. Value $3970, txs_90d 1971 (not rating inputs)."
---

## Summary

Tree (TREE): OpenZeppelin 5 ERC20Permit. A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source Tree.sol: contract Tree is ERC20, ERC20Permit, Ownable (OZ5 imports); approve inherited from ERC20
- OZ5 permit: ECDSA.recover == owner, no ERC-1271

## Impact and exposure

- Value held at block 26,438,999: $3,970 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,971 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
