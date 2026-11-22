---
id: simpleaccount-c30f1d13-signed-shortcut-lost
title: "SimpleAccount: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xc30f1d138a6d51b1b23e5ef086a2f18e12156730"
  family: "a69eaf4d635c7c80d967e2807418b182"
  copies: 15
  name: "SimpleAccount"
  upgradeable: "yes"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1024
  last_active: 2026-11-17
  recoveries_14d: 77
fix:
  layer: offchain
  who_acts: "the account owner (calls execute directly)"
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

ERC-4337 SimpleAccount (proxy): user operations need the owner's ECDSA signature; if the owner has code, user operations fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- SimpleAccount.execute (0xb61d27f6, in implementation 0x74fc…4299) accepts a direct call from the owner (dossier source)
- owner() at block = 0x71B68031aD41FB8Ada675c96523CA9310772bE74

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 1,024 transactions called it in the 90 days before that block; last on 2026-11-17.
- 77 signature recoveries in the study's two-week trace window.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
