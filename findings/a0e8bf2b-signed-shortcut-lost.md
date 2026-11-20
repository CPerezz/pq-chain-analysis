---
id: a0e8bf2b-signed-shortcut-lost
title: "0xa0e8bf2b: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xa0e8bf2b304a9761cbbf82369182f748cbeae6b5"
  family: "52ce4acc7c49e8e372ff8562aa5ee16b"
  upgradeable: "no"
  rating: LOW
  value_usd: 11369
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "maker with code"
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
  note: "Matches standard EtherDelta, where an on-chain order replaces the signature. Read from bytecode, not source. Value $11369, txs_90d 0 (not rating inputs)."
---

## Summary

An unverified EtherDelta clone (identified by its function names). A maker with code loses signed orders but can place them on chain.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta pattern by its function names. Bytecode and names.
- heimdall decompile at block: selectors order(address,uint256,address,uint256,uint256,uint256) 0x0b927666, trade 0x0a19b14a, orders(address,bytes32) 0xbb5f4629, deposit/withdraw/withdrawToken present
- facts: admin() 0x4065574e… (changeAdmin setter); no upgrade path, not needed for LOW

## Impact and exposure

- Value held at block 26,438,999: $11,369 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Place orders with order() instead of signing them.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
