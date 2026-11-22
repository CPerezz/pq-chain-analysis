---
id: vault-ba122222-signed-shortcut-lost
title: "Vault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xba12222222228d8ba445958a75a0704d566bf2c8"
  family: "48bbdc1ef0b0b62784ead6a9af2120dd"
  copies: 2
  name: "Vault"
  label: "Balancer: Vault"
  upgradeable: "no"
  rating: LOW
  value_usd: 5822593
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 340285
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the user"
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
  note: "Same act open by direct call → LOW."
---

## Summary

Balancer v2 Vault: relayers may act for a user who signed; EIP-8151 makes a code-holding user's relayer signature fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Balancer v2 relayer signature: the user named must have signed for this relayer call; the user can instead approve the relayer by its own call (setRelayerApproval). Read from source.
- VaultAuthorization.sol:97 setRelayerApproval(sender,relayer,approved) authenticateFor(sender): the user approves the relayer by its own call
- swap/batchSwap/manageUserBalance are callable by the user directly

## Impact and exposure

- Value held at block 26,438,999: $5.8M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 340,285 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The user approves the relayer once by direct call, or acts directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
