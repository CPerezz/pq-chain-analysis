---
id: enclavesdex-bf45f428-signed-shortcut-lost
title: "EnclavesDEX: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbf45f4280cfbe7c2d2515a7d984b8c71c15e82b7"
  family: "54c1454e58eff3293036c56cc5464a1b"
  copies: 2
  name: "EnclavesDEX"
  upgradeable: "yes"
  rating: LOW
  value_usd: 13173
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-01
fix:
  layer: offchain
  who_acts: "maker with code"
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
  note: "The same act (placing an order) stays open by a direct call for the same party. Value $13173, txs_90d 1 (not rating inputs)."
---

## Summary

EnclavesDEX, an EtherDelta-style exchange: trade() accepts an order when the maker placed it on chain or signed it. Under EIP-8151 a maker whose address has code can't use a signed order, but can still place it on chain.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EnclavesDEX checkSig: true when the user named signed; orders can also be placed on chain. Read from source.
- source (54c1454e58eff3293036c56cc5464a1b): order() sets orders[msg.sender][hash]=true; the trade check is orders[user][hash]
- ecrecover(...)==user
- deposit/withdraw are direct msg.sender calls; cancelOrder also accepts the on-chain order

## Impact and exposure

- Value held at block 26,438,999: $13,173 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

A maker with code places orders with order() and cancels them directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
