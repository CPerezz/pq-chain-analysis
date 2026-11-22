---
id: ambire-9701ae64-7702-own-key-only
title: "AmbireAccount7702: 7702 logic that accepts only the account's own key"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-20]
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
  who_acts: "each account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Hand-rated in the study: the fixed key is Ambire's relayer/paymaster; the account's privileges can be changed by the account (setAddrPrivilege, msg.sender == address(this))"
---

## Summary

AmbireAccount7702 (172,118 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode…. Read from source. Executed: a real transaction reverts once the account holds this logic as real code. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- AmbireAccount7702: the signer must hold a privilege; `if (key == address(this)) return bytes32(uint256(2))` (line 17) gives the account itself a privilege; the signature library also takes contract signers via ERC-1271 and Schnorr/source (dossier f5967d8dcd9e2017576d3f8379176e12)
- Study note: Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode…. Read from source. Execute
- Activity (measured): txs_90d 1, last_active 2026-09-26, value_usd 3452845

## Impact and exposure

- Value held at block 26,438,999: $3.5M (ETH and 49 priced tokens, over 172,118 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.
- 477 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
