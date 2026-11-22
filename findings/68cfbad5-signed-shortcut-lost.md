---
id: 68cfbad5-signed-shortcut-lost
title: "0x68cfbad5: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x68cfbad56d6db48e93eda71898659bd2b861ff19"
  family: "c3c085d9ab49eed56f4ca2fc73786f18"
  upgradeable: "no"
  rating: LOW
  value_usd: 85717
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "The signed shortcut is lost, but approve is open to the same owner and nothing is locked: LOW."
---

## Summary

unverified token: an EIP-2612-style permit checks ecrecover against the owner named in the call. EIP-8151 makes the permit fail for an owner whose address has code; approve still works for that owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- approve(address,uint256) 0x095ea7b3 and permit 0xd505accf (or the Vyper variant) are in the runtime code (own code) at block 26438999
- Row note: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- approve uses msg.sender as owner (standard ERC-20), so an owner with code calls it directly

## Impact and exposure

- Value held at block 26,438,999: $85,717 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls approve directly (or approves through its smart account); a dapp falls back from permit to approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
