---
id: stakedtokenv1-be989514-signed-shortcut-lost
title: "StakedTokenV1: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xbe9895146f7af43049ca1c1ae358b0541ea49704"
  family: "a89eb8f1fe965079c5a9c052f97bfe5c"
  copies: 2
  name: "StakedTokenV1"
  label: "Coinbase: cbETH Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17751
  last_active: 2026-11-18
  recoveries_14d: 30
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

StakedTokenV1: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / transferWithAuthorization: `from` must equal the recovered address; the holder can call…. Read from source. Executed: a real transaction reverts with code at the signer.
- implementation 0x31724ca0c982a31fbb5c57f4217ab585271fc9a5 (admin-slot proxy) holds approve/transfer/permit/transferWithAuthorization selectors
- transferWithAuthorization with an ERC-1271 owner reverts 'FiatTokenV2: invalid signature'

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 17,751 transactions called it in the 90 days before that block; last on 2026-11-18.
- 30 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
