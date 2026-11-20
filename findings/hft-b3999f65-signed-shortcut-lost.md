---
id: hft-b3999f65-signed-shortcut-lost
title: "HFT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xb3999f658c0391d94a37f7ff328f3fec942bcadc"
  family: "55163616a3b288d4277328fa5aa1f83e"
  name: "HFT"
  upgradeable: "no"
  rating: LOW
  value_usd: 21
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 29844
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

HFT: permit / delegateBySig needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve / delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template d927799d: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant). Template.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $21 (ETH and 49 priced tokens).
- Activity: 29,844 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve / delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
