---
id: gsp-201939f5-signed-shortcut-lost
title: "GSP: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x201939f5c74f5fd3beef1cf03a9cfcc75beba9d9"
  family: "1a139437e81220621d999d5d9bae9d93"
  copies: 4
  name: "GSP"
  upgradeable: "no"
  rating: LOW
  value_usd: 5
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2764
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

GSP: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 8e54df5e: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.
- bytecode at block 26438999 (proxy + implementation) holds direct selectors
- EIP-1167 clone; implementation 0xb375ccf52923287ec525351c2c11030fd95b856f holds approve 0x095ea7b3 and permit 0xd505accf

## Impact and exposure

- Value held at block 26,438,999: $5 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 2,764 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
