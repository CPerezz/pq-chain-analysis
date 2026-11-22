---
id: yearnv3vault-18286313-signed-shortcut-lost
title: "YearnV3Vault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x182863131f9a4630ff9e27830d945b1413e347e8"
  family: "17911193c1017abf77b08e79d3c85968"
  copies: 2
  name: "YearnV3Vault"
  upgradeable: "no"
  rating: LOW
  value_usd: 10
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1092
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

YearnV3Vault: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Yearn v3 vault permit (Vyper): ecrecover must equal the owner named. Read (function text).
- bytecode at block 26438999 (proxy + implementation) holds direct selectors
- EIP-1167 clone; implementation 0xca78af7443f3f8fa0148b746cb18ff67383cdf3f holds approve 0x095ea7b3 and permit 0xd505accf

## Impact and exposure

- Value held at block 26,438,999: $10 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,092 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
