---
id: fintoch-1fc03ab8-fixed-signer
title: "Fintoch: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1fc03ab8842718c3ac511f2d0a5dd1d09459384f"
  family: "bec1df86e699d7156b90d0f9eaf49def"
  copies: 3980
  name: "Fintoch"
  upgradeable: "no"
  rating: HIGH
  value_usd: 16
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No update path, and the owners' own funds lock once two owners have code, so HIGH."
---

## Summary

This is an Ownbit-style 2-of-3 multisig whose owners are set in the constructor with no add/replace function. Every spend path (spend, spendERC20, spendAny, toSwap, crossChain, liquidatedAssets, setBorrowInfo) checks the signatures with raw ecrecover. Once two owners have code, nothing moves the wallet's funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Fintoch (Ownbit clone): distinct owners by ECDSA; owners fixed / Fintoch (Ownbit clone), any-call variant. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: `address[] private owners` is assigned only in the constructor and `required` is immutable (= 2); _validSignature uses `ecrecover(message, vs[i]+27, rs[i], ss[i])`.
- There is no unsigned exit function, only receive.
- Owners 0x3a89…5cc, 0x800a…72fa, 0x8195…46ed have no code at block 26438999.

## Impact and exposure

- Value held at block 26,438,999: $16 (ETH and 49 priced tokens, over 3,980 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds out before two of them migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
