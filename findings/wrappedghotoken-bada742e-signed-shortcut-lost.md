---
id: wrappedghotoken-bada742e-signed-shortcut-lost
title: "WrappedGhoToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbada742e7ff54595f9049eef1cc5aaf4364988b9"
  family: "dcdd409a783ae97081c579d23d4cf7d1"
  copies: 4
  name: "WrappedGhoToken"
  label: "Lens: LGHO Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 234051
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 461
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "The signed shortcut is lost, but approve is open to the same owner and nothing is locked: LOW."
---

## Summary

WrappedGhoToken: an EIP-2612-style permit checks ecrecover against the owner named in the call. EIP-8151 makes the permit fail for an owner whose address has code; approve still works for that owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve(address,uint256) 0x095ea7b3 and permit 0xd505accf (or the Vyper variant) are in the runtime code (implementation 0x54aac421143c57f6f7661fc1349dbf7e8acf1223) at block 26438999
- Row note: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve uses msg.sender as owner (standard ERC-20), so an owner with code calls it directly

## Impact and exposure

- Value held at block 26,438,999: $234,051 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 461 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls approve directly (or approves through its smart account); a dapp falls back from permit to approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
