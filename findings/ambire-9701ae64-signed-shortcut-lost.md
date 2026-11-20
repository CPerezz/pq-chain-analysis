---
id: ambire-9701ae64-signed-shortcut-lost
title: "AmbireAccount7702: signed shortcut lost by users with code"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x9701ae64b07b51050934c683d35265c53c60f481"
  family: "f5967d8dcd9e2017576d3f8379176e12"
  copies: 172118
  name: "AmbireAccount7702"
  label: "Ambire: EIP-7702 Delegator"
  upgradeable: "no"
  rating: LOW
  value_usd: 3452845
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-26
  recoveries_14d: 477
fix:
  layer: account-migration
  who_acts: "the account / privileged key"
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

AmbireAccount7702 delegate logic: execute recovers privileged signers; the account's own key is exempt (delegation indicator), a stored extra key with code fails ECDSA modes.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode…. Read from source. Executed: a real transaction is unaffected by code at the signer. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- AmbireAccount.sol:188 executeBySender for any privileged msg.sender, incl. the account itself (privileges(address(this))=2)
- AmbireAccount.sol:200 executeBySelf for the account
- SignatureValidator.sol:158 SmartWallet mode accepts ERC-1271 from a privileged contract

## Impact and exposure

- Value held at block 26,438,999: $3.5M (ETH and 49 priced tokens, over 172,118 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.
- 477 signature recoveries in the study's two-week trace window.

## Remediation

Act via executeBySender / ERC-1271 mode, or the account resets privileges by its own transaction.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
