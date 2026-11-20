---
id: lottery-e16a567e-fixed-gas-recovery
title: "Lottery: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xe16a567ea438a81994ec7859b9abb0184f3d6028"
  family: "6456d1201a826e449a5be0e76a58d837"
  name: "Lottery"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner (exit() refund), operator redeploy"
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
  note: "MEDIUM: the draw dies, but the owner's exit() pays all ticket holders, so nothing is locked. Risk: owner newGame() in stage 3 would orphan the ticket list."
---

## Summary

Lottery: on a failed proof the callback sets stage=3 and pays nothing. Owner-only exit() refunds the balance equally to every ticket holder (tickets[1..numTickets-1]), with no stage check. Owner is set. Current balance 0, stage 2.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- exit(): if msg.sender==owner, it transfers balance/(numTickets-1) to each tickets[i] [sourcify source]
- __callback: proofVerify returnCode != 0 sets stage=3 with no transfer, so ETH stays [source]
- owner (slot 14) = 0x8c9bb9c5632309dc9bcc60e2e5a21cc6da7a1079, stage (slot 11) = 2, numTickets (slot 9) = 2, balance 0 at block 26438999 [cast storage/balance]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls exit() to refund ticket holders after a failed draw; redeploy for future games.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
