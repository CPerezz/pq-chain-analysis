---
id: universalrouter-23617e59-signed-shortcut-lost
title: "UniversalRouter: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x23617e59a5925b2a4bf75d73ff6711cd0b29de85"
  family: "6b42ff09141416ba7eff1967b7d9c4ab"
  name: "UniversalRouter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 723679
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the signer (calls execute directly)"
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
  note: "signed shortcut lost, same act open by a direct call to the same party → LOW."
---

## Summary

Uniswap UniversalRouter: executeSigned recovers a route signer with ECDSA.recover; a signer with code cannot use signed execution.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Uniswap UniversalRouter RouteSigner: execute signed commands; the signer becomes the context sender and could call execute itself. Read (function text).
- RouteSigner._setSignatureContext: signer = ECDSA.recover(digest, signature), no ERC-1271 (dossier source)
- UniversalRouter.execute(commands, inputs[, deadline]) is public: the signer can run the commands itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 723,679 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
