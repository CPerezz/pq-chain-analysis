---
id: unipeg-44b28991-signed-shortcut-lost
title: "Unipeg: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x44b28991b167582f18ba0259e0173176ca125505"
  family: "342a9baa9b248bab0ff610283cf8b716"
  name: "Unipeg"
  label: "Unipeg: uPEG Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 299
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 30198
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
evidence:
  level: bytecode
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

Unipeg: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 47e68d92: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Template.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $299 (ETH and 49 priced tokens).
- Activity: 30,198 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
