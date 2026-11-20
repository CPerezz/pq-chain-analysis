---
id: clankertoken-b67555b4-signed-shortcut-lost
title: "ClankerToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb67555b4881c7df3c26417fb355ee13973cb8b07"
  family: "26641b988cd26727dd285d4253d234c1"
  copies: 1414
  name: "ClankerToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14266
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "the affected holder, by calling approve/delegate itself"
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
  note: "LOW: same act open by approve/delegate to the same party; only a signing convenience is lost."
---

## Summary

ClankerToken: permit and delegateBySig require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- delegate(address) is the direct path for delegateBySig (0x5c19a95c present)
- row note: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 1,414 addresses).
- Activity: 14,266 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

holder calls approve/delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
