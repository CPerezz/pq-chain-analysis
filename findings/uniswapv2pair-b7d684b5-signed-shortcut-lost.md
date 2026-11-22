---
id: uniswapv2pair-b7d684b5-signed-shortcut-lost
title: "UniswapV2Pair: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb7d684b55c880585c60d089768d1a46a5294ae3d"
  family: "3ce5486ce08fb2475f875743ad753141"
  copies: 74
  name: "UniswapV2Pair"
  label: "deployed by CitySwap: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1422
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
  note: "Permit has a direct twin. Value $4872, txs_90d 1422 (not rating inputs)."
---

## Summary

UniswapV2Pair: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- source (3ce5486ce08fb2475f875743ad753141): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $4,872 (ETH and 49 priced tokens, over 74 addresses).
- Activity: 1,422 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
