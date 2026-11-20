---
id: avowallet-aadb40bc-signed-shortcut-lost
title: "AvoWallet: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xaadb40bc935220cd94444f5bef0a1c9354dd87f1"
  family: "22e89b71d6799f97a21e2adafcfd8396"
  copies: 339
  name: "AvoWallet"
  label: "deployed by Instadapp: Avocado Broadcaster 4"
  upgradeable: "yes"
  rating: LOW
  value_usd: 23820
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58
  last_active: 2026-11-13
  recoveries_14d: 12
fix:
  layer: offchain
  who_acts: "the wallet owner"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $23820, txs_90d 58."
---

## Summary

Avocado wallet v1: cast runs via a forwarder with the owner's ECDSA signature or directly when msg.sender is the owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Avocado wallet v1: the forwarder path needs the owner's ECDSA signature; cast also accepts a direct call from the owner (read); the owner cannot be changed. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- cast(): signature path, else `msg.sender == owner` passes (AvoWallet.sol:161-190)
- The owner cannot be changed, but needs no change: the direct call works for an owner with code
- Study: a real transaction reverts with code at the signer (signed path only)

## Impact and exposure

- Value held at block 26,438,999: $23,820 (ETH and 49 priced tokens, over 339 addresses).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-13.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls cast directly instead of through the forwarder.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
