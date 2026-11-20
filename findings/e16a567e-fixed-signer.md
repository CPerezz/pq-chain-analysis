---
id: e16a567e-fixed-signer
title: "0xe16a567e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe16a567ea438a81994ec7859b9abb0184f3d6028"
  family: "6456d1201a826e449a5be0e76a58d837"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner (exit() refund), operator redeploy"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
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

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
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

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
