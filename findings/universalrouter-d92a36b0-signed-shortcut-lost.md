---
id: universalrouter-d92a36b0-signed-shortcut-lost
title: "UniversalRouter: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd92a36b0000531ef3063ded4de20a0783308446c"
  family: "772da20887cc7487fc6c699e22760869"
  copies: 3
  name: "UniversalRouter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 19627
  last_active: 2026-11-17
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
  note: "LOW: the signer can call execute itself."
---

## Summary

Uniswap UniversalRouter: executeSigned recovers a RouteSigner (ECDSA) that becomes the context sender.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Uniswap UniversalRouter RouteSigner: execute signed commands; the signer becomes the context sender and could call execute itself. Read (function text).
- contracts/base/RouteSigner.sol:63 signer = ECDSA.recover(digest, signature)
- UniversalRouter.sol:40/70 execute(...) callable directly by anyone, including the would-be signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 19,627 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
