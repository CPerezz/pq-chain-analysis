---
id: ethereumdidregistry-dca7ef03-signed-shortcut-lost
title: "EthereumDIDRegistry: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xdca7ef03e98e0dc2b855be647c39abe984fcf21b"
  family: "554bb9ff9b8faf55c1e3dc72ec7d08c2"
  name: "EthereumDIDRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2325
  last_active: 2026-11-17
  recoveries_14d: 2126
fix:
  layer: offchain
  who_acts: "the identity owner (direct calls)"
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
  note: "every signed act has a direct twin → LOW"
---

## Summary

ERC-1056 EthereumDIDRegistry: *Signed variants recover the identity owner; with code at the owner they fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: the recovered address must be the owner recorded for the identity (by default the identity itself); the owner can make every change by its own call and can hand the identity over. Read from source. Executed: a real transaction reverts with code at the signer.
- recovered address must equal identityOwner(identity) (source)
- changeOwner/addDelegate/revokeDelegate/setAttribute/revokeAttribute have msg.sender-owner versions
- owner can also hand the identity to a new owner by direct call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,325 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2,126 signature recoveries in the study's two-week trace window.

## Remediation

owner uses the direct (non-Signed) functions

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
