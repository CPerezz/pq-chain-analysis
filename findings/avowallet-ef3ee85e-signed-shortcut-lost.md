---
id: avowallet-ef3ee85e-signed-shortcut-lost
title: "AvoWallet: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xef3ee85ef22ceb958a78b557753951cc2a6ab8dc"
  family: "d59e4428ca49ed6d37c4f22a7f156b2d"
  copies: 504
  name: "AvoWallet"
  label: "deployed by Instadapp: Avocado Broadcaster 3"
  upgradeable: "yes"
  rating: LOW
  value_usd: 74528
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-20
fix:
  layer: none
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
  note: "The owner keeps direct control: LOW."
---

## Summary

Avocado wallet v1 (proxy to 0x3718f4bf...): cast through the forwarder needs the owner's ECDSA signature; cast also accepts a direct call from the owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Avocado wallet v1: the forwarder path needs the owner's ECDSA signature; cast also accepts a direct call from the owner (read); the owner cannot be changed. Read (same text as a family read).
- AvoWallet.sol:161-186 cast: msg.sender == avoForwarder needs the signature; else if msg.sender == owner runs directly
- owner() = 0x59FAD02e76c4e08836AA01aB0aB807dB33B35000 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $74,528 (ETH and 49 priced tokens, over 504 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-20.

## Remediation

The owner calls cast directly (paying its own gas).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
