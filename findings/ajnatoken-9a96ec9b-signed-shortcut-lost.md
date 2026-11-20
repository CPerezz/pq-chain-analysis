---
id: ajnatoken-9a96ec9b-signed-shortcut-lost
title: "AjnaToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x9a96ec9b57fb64fbc60b423d1f4da7691bd35079"
  family: "6e547333bd642213a11824a9037b8426"
  name: "AjnaToken"
  label: "Ajna: AJNA Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1789
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "the holder (calls approve/delegate/transfer directly)"
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
  note: "signed shortcut only; the same act stays open to the same party by direct call → LOW"
---

## Summary

AjnaToken is an ERC-20 with permit, delegateBySig; under EIP-8151 a holder whose address has non-delegation code can no longer use the signed path.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 4 ERC20Votes) / OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- signed path(s) in code: permit, delegateBySig
- direct calls in code: approve, delegate, transfer (msg.sender-based ERC-20/votes, callable by the holder itself)
- no ERC-1271 isValidSignature selector (0x1626ba7e) in code: signer with code not handled on the signed path
- txs_90d 1789, last_active 2026-11-17; value not material to rating

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,789 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
