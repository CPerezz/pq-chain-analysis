---
id: arcenhanced-76505b87-signed-shortcut-lost
title: "ARCEnhanced: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x76505b870f19f5632d9223bd6b4939cb7bbc4f79"
  family: "125bccc5d59c6b56d33e4730ca6d76a2"
  copies: 10
  name: "ARCEnhanced"
  label: "ARC: ARC Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 15
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7494
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls approve / delegate itself)"
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
  note: "signed shortcut lost, approve / delegate stays open to the same holder → LOW."
---

## Summary

ARCEnhanced: permit / delegateBySig needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve / delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use delegateBySig, permit; it can still call approve, delegate itself: a way of signing is lost, no right. Rule: permit-like.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $15 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 7,494 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve / delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
