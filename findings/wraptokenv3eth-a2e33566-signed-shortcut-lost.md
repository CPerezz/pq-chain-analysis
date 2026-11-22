---
id: wraptokenv3eth-a2e33566-signed-shortcut-lost
title: "WrapTokenV3ETH: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa2e3356610840701bdf5611a53974510ae27e2e1"
  family: "573c1a66d0702541fb4bcb0881e03034"
  copies: 2
  name: "WrapTokenV3ETH"
  label: "Binance: wBETH Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2716404
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4623
  last_active: 2026-11-18
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

WrapTokenV3ETH (Binance: wBETH Token): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / transferWithAuthorization: `from` must equal the recovered address; the holder can call…. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / transferWithAuthorization: `from` must equal the recovered address; the h

## Impact and exposure

- Value held at block 26,438,999: $2.7M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4,623 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
