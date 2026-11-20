---
id: fraxswappair-c416be7d-signed-shortcut-lost
title: "FraxswapPair: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc416be7d09818abfe2713090c81fe8f3f7eeb553"
  family: "42215f48bb522e36d0d6a69470f85655"
  copies: 14
  name: "FraxswapPair"
  label: "Frax Finance: FS-V1 Token 7"
  upgradeable: "no"
  rating: LOW
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1677
  last_active: 2026-11-17
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
  note: "Permit has a direct twin. Value $3790, txs_90d 1677 (not rating inputs)."
---

## Summary

FraxswapPair: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- source (42215f48bb522e36d0d6a69470f85655): signed functions [executeVirtualOrders,executeVirtualOrdersInternal,executeVirtualOrdersUntilTimestamp,executeVirtualOrdersUntilTimestampView,executeVirtualTradesAndOrderExpiries,permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $3,790 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 1,677 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
