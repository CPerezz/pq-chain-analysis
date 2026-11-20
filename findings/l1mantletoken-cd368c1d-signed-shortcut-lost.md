---
id: l1mantletoken-cd368c1d-signed-shortcut-lost
title: "L1MantleToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xcd368c1d80120b0dd92447c87eb570154f8e685c"
  family: "1f340da777120704233319083aa360f0"
  copies: 2
  name: "L1MantleToken"
  label: "Mantle: MNT Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 54348
  last_active: 2026-11-18
  recoveries_14d: 6
fix:
  layer: offchain
  who_acts: "token holder (calls approve / delegate itself)"
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
  note: "signed shortcut lost, approve / delegate stays open to the same holder → LOW."
---

## Summary

L1MantleToken: permit / delegateBySig needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve / delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked / OpenZeppelin 4 upgradeable permit. Read from source. Executed: a real transaction reverts with code at the signer.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $541 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 54,348 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve / delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
