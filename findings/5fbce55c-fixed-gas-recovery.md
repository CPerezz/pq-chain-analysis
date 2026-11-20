---
id: 5fbce55c-fixed-gas-recovery
title: "0x5fbce55c: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x5fbce55cb14b2c99e611a26a9066e77e6d3ae55f"
  family: "b7b87df5355d43eee49107111bc0f29b"
  copies: 6
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "MEDIUM: the function dies but nothing is locked, because the failed-proof branch refunds both players (minus the Oraclize fee). This depends on Provable still delivering the callback."
---

## Summary

Unverified 2-player coin flip: each player deposits exactly 2 ETH, and the second deposit sends the random query. On a failed proof the callback itself returns the funds (half the balance to player 0, the rest to player 1). The game dies, but stakes are not locked. Current balance 0.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code string 'Oracle Proof Failed, Returning Funds...' (39 bytes = the errorLog 0x27 branch), followed by transfer(balance/2) to players[0] and transfer(balance) to players[1] [bytecode strings + heimdall decompile]
- deposit 0xd0e30db0 requires msg.value==2 ETH and balance<=4 ETH; at 4 ETH it sends the Ledger random query [decompile]
- ETH balance 0 and players array empty (slot 5 = 0) at block 26438999 [cast]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with working randomness; no funds are stuck.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
