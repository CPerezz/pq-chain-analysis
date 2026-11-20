---
id: bicotokenimplementation-95cc3a10-signed-shortcut-lost
title: "BicoTokenImplementation: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x95cc3a10636c5bdffe4045d7bf00efb787e1bbe1"
  family: "489e3dc2b039ceb339d5bacc4dab1584"
  copies: 2
  name: "BicoTokenImplementation"
  label: "Biconomy: BICO Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 7940
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 41260
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Direct twins exist. Value $7940, txs_90d 41260 (not rating inputs)."
---

## Summary

Biconomy BICO token: approveWithSig and transferWithSig are signed shortcuts; a holder with code calls approve/transfer itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Biconomy token approveWithSig: the owner named must have signed / Biconomy token transferWithSig: the sender named must have signed. Read from source.
- source BicoTokenImplementation.sol:1031 transfer, :1050 approve (msg.sender)
- approveWithSig/transferWithSig require the recovered address to be the owner/sender named

## Impact and exposure

- Value held at block 26,438,999: $7,940 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 41,260 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve/transfer directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
