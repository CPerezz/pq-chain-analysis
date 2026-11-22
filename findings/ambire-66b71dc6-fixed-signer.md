---
id: ambire-66b71dc6-fixed-signer
title: "AmbireAccount7702: signer fixed in code"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x66b71dc6f3c3ab6ffab508d9b5266f68bb39e67c"
  family: "f5967d8dcd9e2017576d3f8379176e12"
  copies: 172117
  name: "AmbireAccount7702"
  label: "Ambire: EIP-7702 Delegator"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3452882
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 15661
  last_active: 2026-11-18
  recoveries_14d: 470
fix:
  layer: account-migration
  who_acts: "the account's key holder (re-delegates) / Ambire for its relayer key"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "There is a live 7702 re-delegation path, and the affected key belongs to the operator, not the user. LOW holds. I did not re-read the Ambire source myself; I relied on the row's hand reading."
---

## Summary

An Ambire EIP-7702 account. Only Ambire's paymaster relayer key is fixed in the code. If that key held real code, relayed/sponsored paths would fail. The account's own keys are privileges that can be replaced, and contract signers go through ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode…. Read from source. Executed: a real transaction is unaffected by code at the signer. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code at 26438999 = 0xef0100 5a7fc113…: an EOA delegated by 7702, nonce 5, so its key holder is live and can re-delegate
- row note (read from source, rated by hand): the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced; ERC-1271 and Schnorr modes exist

## Impact and exposure

- Value held at block 26,438,999: $3.5M (ETH and 49 priced tokens, over 172,117 addresses).
- Activity: 15,661 transactions called it in the 90 days before that block; last on 2026-11-18.
- 470 signature recoveries in the study's two-week trace window.

## Remediation

Ambire ships a new delegate with a new relayer key and accounts re-delegate. Or Ambire keeps the relayer an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
