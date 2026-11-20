---
id: universalrouter-88767899-signed-shortcut-lost
title: "UniversalRouter: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x8876789976decbfcbbbe364623c63652db8c0904"
  family: "21dd67a11696f6fa086435efb8149dd6"
  copies: 2
  name: "UniversalRouter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 330288
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

Uniswap UniversalRouter (same RouteSigner code): executeSigned recovers a route signer; a signer with code cannot use signed execution.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Uniswap UniversalRouter RouteSigner: execute signed commands; the signer becomes the context sender and could call execute itself. Read (function text).
- RouteSigner: signer = ECDSA.recover(digest, signature) (study note, same code as 0x23617e59 dossier)
- execute(bytes,bytes[]) 0x24856bc3 is public: the signer can run the commands itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 330,288 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
