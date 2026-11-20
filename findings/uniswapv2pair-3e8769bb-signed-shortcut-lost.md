---
id: uniswapv2pair-3e8769bb-signed-shortcut-lost
title: "UniswapV2Pair: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x3e8769bb28fed24c6eef161b48b7689a5fb0e320"
  family: "3b28342b0f070d14c1f9ca4d898de8c2"
  copies: 528187
  name: "UniswapV2Pair"
  label: "Uniswap V2: WISE 8"
  upgradeable: "no"
  rating: LOW
  value_usd: 347100800
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4273091
  last_active: 2026-11-18
  recoveries_14d: 20
fix:
  layer: account-migration
  who_acts: "the token holder"
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
  note: "Standard signed shortcut; same act open by direct call → LOW."
---

## Summary

UniswapV2Pair (Uniswap V2: WISE 8): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $347.1M (ETH and 49 priced tokens, over 528,187 addresses).
- Activity: 4,273,091 transactions called it in the 90 days before that block; last on 2026-11-18.
- 20 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
