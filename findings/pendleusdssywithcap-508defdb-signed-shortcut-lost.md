---
id: pendleusdssywithcap-508defdb-signed-shortcut-lost
title: "PendleUSDSSYWithCap: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x508defdb5dd2adeefe36f58fdcd75d6efa36697b"
  family: "71c3a38adeb2d3761ed962d149e0d7a7"
  copies: 2
  name: "PendleUSDSSYWithCap"
  label: "Pendle: SY-USDS Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 55400
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 35
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

PendleUSDSSYWithCap: an EIP-2612-style permit checks ecrecover against the owner named in the call. EIP-8151 makes the permit fail for an owner whose address has code; approve still works for that owner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve(address,uint256) 0x095ea7b3 and permit 0xd505accf (or the Vyper variant) are in the runtime code (implementation 0x6bcfb216cee6241640c51ce035161b05fc9eaa13) at block 26438999
- Row note: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- approve uses msg.sender as owner (standard ERC-20), so an owner with code calls it directly

## Impact and exposure

- Value held at block 26,438,999: $55,400 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 35 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls approve directly (or approves through its smart account); a dapp falls back from permit to approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
