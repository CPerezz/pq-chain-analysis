---
id: liquiditygaugev6-fc3212bd-signed-shortcut-lost
title: "LiquidityGaugeV6: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xfc3212bd9ad9a28da6b2bd50a2918969c126894f"
  family: "2bc2a3d7e6e27da9daaeaef906c1058c"
  name: "LiquidityGaugeV6"
  label: "created by Curve: Stableswap Factory"
  upgradeable: "no"
  rating: LOW
  value_usd: 46738
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3461
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $46738, txs_90d 3461."
---

## Summary

LiquidityGaugeV6 exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit (Curve gauge): ecrecover must equal _owner. Read from source.
- Gauge permit: `assert ecrecover(digest, _v, _r, _s) == _owner`; the docstring claims ERC-1271 support but the code has no 1271 branch (LiquidityGaugeV6.vy:546-573)
- approve(_spender,_value) is external, called by the holder (LiquidityGaugeV6.vy:514)
- Same party in both paths

## Impact and exposure

- Value held at block 26,438,999: $46,738 (ETH and 49 priced tokens).
- Activity: 3,461 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
