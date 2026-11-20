---
id: tethertoken-93d07077-signed-shortcut-lost
title: "TetherToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x93d070772066c977d605d69b602d316adafc25e3"
  family: "57df7c13b8e7a2be124845948fb20764"
  copies: 4
  name: "TetherToken"
  label: "deployed by DeversiFi: Deployer 2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 356501
  last_active: 2026-11-18
  recoveries_14d: 217
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

TetherToken: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit. Read from source. Executed: a real transaction is unaffected by code at the signer.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $541 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 356,501 transactions called it in the 90 days before that block; last on 2026-11-18.
- 217 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
