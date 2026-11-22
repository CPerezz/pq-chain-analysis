---
id: pendleusdesy-d29a7d69-signed-shortcut-lost
title: "PendleUSDESY: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd29a7d69cf5f06ccd777e53d6e437032804abf89"
  family: "2507aec0ce02fd681967b8cac78c198d"
  copies: 4
  name: "PendleUSDESY"
  label: "Pendle: SY-USDe Token 4"
  upgradeable: "no"
  rating: LOW
  value_usd: 177208
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 12
  last_active: 2026-11-18
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

PendleUSDESY: an EIP-2612-style permit checks ecrecover against the owner named in the call. EIP-8151 makes the permit fail for an owner whose address has code; approve still works for that owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve(address,uint256) 0x095ea7b3 and permit 0xd505accf (or the Vyper variant) are in the runtime code (own code) at block 26438999
- Row note: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve uses msg.sender as owner (standard ERC-20), so an owner with code calls it directly

## Impact and exposure

- Value held at block 26,438,999: $177,208 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 12 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The owner calls approve directly (or approves through its smart account); a dapp falls back from permit to approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
