---
id: tethertoken-ba2a995b-signed-shortcut-lost
title: "TetherToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xba2a995bd4ab9e605454ccef88169352cd5f75a6"
  family: "9611444e159c7ffd3a793c9ce7ba341c"
  copies: 3
  name: "TetherToken"
  label: "deployed by Tether: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-26
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
  note: "Permit has a direct twin. Value $11188, txs_90d 2 (not rating inputs)."
---

## Summary

TetherToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit. Read from source.
- source (9611444e159c7ffd3a793c9ce7ba341c): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $11,188 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
