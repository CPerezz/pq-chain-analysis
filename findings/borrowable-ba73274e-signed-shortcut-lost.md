---
id: borrowable-ba73274e-signed-shortcut-lost
title: "Borrowable: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xba73274e749938d0442f106f3b4abb8f9fcc0ea5"
  family: "8c9e836d154791272b3028684a882adb"
  copies: 71
  name: "Borrowable"
  upgradeable: "no"
  rating: LOW
  value_usd: 83190
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 62
  last_active: 2026-11-14
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

Borrowable: an EIP-2612-style permit checks ecrecover against the owner named in the call. EIP-8151 makes the permit fail for an owner whose address has code; approve still works for that owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- approve(address,uint256) 0x095ea7b3 and permit 0xd505accf (or the Vyper variant) are in the runtime code (own code) at block 26438999
- Row note: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- approve uses msg.sender as owner (standard ERC-20), so an owner with code calls it directly

## Impact and exposure

- Value held at block 26,438,999: $83,190 (ETH and 49 priced tokens, over 71 addresses).
- Activity: 62 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The owner calls approve directly (or approves through its smart account); a dapp falls back from permit to approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
