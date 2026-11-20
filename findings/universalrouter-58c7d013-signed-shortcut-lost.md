---
id: universalrouter-58c7d013-signed-shortcut-lost
title: "UniversalRouter: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x58c7d013ffa6e77b89282fd7a64e12a4583a16aa"
  family: "0b0ce09562a57a2de7a7a857b52ee770"
  copies: 2
  name: "UniversalRouter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2271
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the signer (calls execute itself)"
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
  note: "direct execute path for the same party → LOW"
---

## Summary

Uniswap UniversalRouter with RouteSigner: signed command execution stores the ECDSA-recovered signer as context sender.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Uniswap UniversalRouter RouteSigner: execute signed commands; the signer becomes the context sender and could call execute itself. Read (function text).
- RouteSigner.sol:63 signer = ECDSA.recover(digest, signature); stored in transient slot as the route signer
- plain execute(commands, inputs) remains, with msg.sender as context, so the signer can run the same commands directly
- no ERC-1271 in RouteSigner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,271 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

signer calls execute directly

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
