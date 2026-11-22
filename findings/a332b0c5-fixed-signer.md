---
id: a332b0c5-fixed-signer
title: "0xa332b0c5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa332b0c5c306f676d4b491d259d190193a5c71e9"
  family: "89b8ce12a196e13c7c956289b5e9c56c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "operator 0x3d5ca9af"
evidence:
  level: bytecode
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
  note: "MEDIUM: no update path, operator's own bankroll only, and an operator withdraw path exists. The same voucher caveat applies as for 0x9e84f5ae. reading1 (a tight sender gas limit) is unrelated."
---

## Summary

This is the same one-shot USDC game design as 0x9e84f5ae. The payout a63684e1(amount, sig) needs a signature from the constant 0x39bc8fbb. The bankroll comes only from operator 0x3d5ca9af (ca7c43bc) and goes back through a1d9c9bc after a block deadline.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code; selectors unnamed. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: constant 0x39bc8fbb (PUSH32 at pc 0x0fc4 in the check; getter at 0x11b7). Operator 0x3d5ca9af hard-coded in ca7c43bc (USDC transferFrom from the operator) and a1d9c9bc (USDC transfer to msg.sender==operator once block.number > deadline). No setter, no proxy slot.
- Trace of tx 0x938546fa (block 26437953, deployed at 26437904): 0x01 returns 0x39bc8fbb, payout amount 0.
- At block 26438999: USDC balance 0; 0x39bc8fbb has no code, nonce 0. 0x3d5ca9af is an EOA (latest, block ~26452927).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Operator: redeploy with a replaceable signer; withdraw any bankroll via a1d9c9bc.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
