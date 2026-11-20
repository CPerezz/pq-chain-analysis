---
id: erc20t-01c0dd69-signed-shortcut-lost
title: "ERC20T: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x01c0dd693e6f68e4dcde159110e4fa200ab0ed03"
  family: "f97034b79d01b90eb8ae90bd70eaf07a"
  copies: 49
  name: "ERC20T"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1925
  last_active: 2026-11-15
fix:
  layer: offchain
  who_acts: "the holder (calls approve/delegate/transfer directly)"
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
  note: "signed shortcut only; the same act stays open to the same party by direct call → LOW"
---

## Summary

ERC20T: EIP-1167 clone of 0x2df7dcf4…0eee (Solady ERC20 with permit); a holder with code loses permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template f6c2a819: Solady ERC20 permit (assembly): the recovered address must be the owner named. Template.
- runtime code is a minimal proxy to 0x2df7dcf4d19a7924e00ae96629cc1d1261670eee
- implementation selectors include permit(address,address,uint256,uint256,uint8,bytes32,bytes32), approve, transfer
- no ERC-1271 selector in implementation

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 49 addresses).
- Activity: 1,925 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
