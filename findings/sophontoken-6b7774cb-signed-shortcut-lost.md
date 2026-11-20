---
id: sophontoken-6b7774cb-signed-shortcut-lost
title: "SophonToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x6b7774cb12ed7573a7586e7d0e62a2a563ddd3f0"
  family: "8298af5ad7f03fe80e3f99b070718a5a"
  name: "SophonToken"
  label: "Sophon: SOPH Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 57425
  last_active: 2026-11-18
  recoveries_14d: 15
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

SophonToken: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 57,425 transactions called it in the 90 days before that block; last on 2026-11-18.
- 15 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
