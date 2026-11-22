---
id: multisourceloan-b05872a1-signed-shortcut-lost
title: "MultiSourceLoan: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb05872a1f2f0e9806a5a375c0bc99eeb18178904"
  family: "a41093cc06b9741a528845be85e9760e"
  copies: 2
  name: "MultiSourceLoan"
  upgradeable: "no"
  rating: LOW
  txs_90d: 17874
  last_active: 2026-11-18
  recoveries_14d: 2246
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
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
  note: "LOW: loan signatures already handle code signers; permit is covered by approve."
---

## Summary

Gondi MultiSourceLoan: offer signatures check code first (ERC-1271 for contracts, else ECDSA); the solmate permit is the only pure-ECDSA path.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / code first: an owner or signer that is a contract is asked through ERC-1271;…. Read from source. Executed: a real transaction reverts with code at the signer.
- MultiSourceLoan.sol:1099-1104 if signer.code.length != 0 → IERC1271.isValidSignature, else ECDSA recover
- solmate ERC20.sol:68 approve / l.116 permit present in source; direct approve for the holder

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 17,874 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,246 signature recoveries in the study's two-week trace window.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
