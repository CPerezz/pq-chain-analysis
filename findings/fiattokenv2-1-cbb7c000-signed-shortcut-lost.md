---
id: fiattokenv2-1-cbb7c000-signed-shortcut-lost
title: "FiatTokenV2_1: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcbb7c0000ab88b473b1f5afd9ef808440eed33bf"
  family: "56e8ea9990520420c2702e6ceaf7efbe"
  copies: 7
  name: "FiatTokenV2_1"
  label: "Coinbase: cbBTC Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 6857
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 207291
  last_active: 2026-11-18
  recoveries_14d: 317
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
  note: "Direct twins exist. Value $6857, txs_90d 207291 (not rating inputs)."
---

## Summary

USDC FiatTokenV2_1: permit, transferWithAuthorization and receiveWithAuthorization are ECDSA-only in this version; a holder with code calls transfer/approve itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: transferWithAuthorization: `from` must equal the recovered address; the holder can call transfer itself / receiveWithAuthorization: `from` must equal the recovered address, caller must be the payee;…. Read from source. Executed: a real transaction reverts with code at the signer.
- source FiatTokenV2_1: EIP-3009/2612 with ecrecover == from/owner
- standard transfer/approve present; row upgradeable yes

## Impact and exposure

- Value held at block 26,438,999: $6,857 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 207,291 transactions called it in the 90 days before that block; last on 2026-11-18.
- 317 signature recoveries in the study's two-week trace window.

## Remediation

Call transfer/approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
