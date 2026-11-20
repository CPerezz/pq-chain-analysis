---
id: vowtoken-1bbf25e7-signed-shortcut-lost
title: "VOWToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x1bbf25e71ec48b84d773809b4ba55b6f4be946fb"
  family: "5c11c1734692c876d1e89e0d4a5bde03"
  name: "VOWToken"
  label: "Vow: VOW Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5523
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
  note: "Direct twin exists. Value $3970, txs_90d 5523 (not rating inputs)."
---

## Summary

VOW token: a proxy submits a transfer that `from` signed (checkProxying); `from` can send/transfer itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: VOW token proxy transfer: `from` signs a transfer a proxy submits; it can send itself. Read from source.
- source VOWToken.sol:1011 checkProxying: ECDSA.recover(...)== _from
- transfer :715 and send :774 are msg.sender calls

## Impact and exposure

- Value held at block 26,438,999: $3,970 (ETH and 49 priced tokens).
- Activity: 5,523 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call transfer/send directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
