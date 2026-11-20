---
id: 9e84f5ae-fixed-signer
title: "0x9e84f5ae: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9e84f5ae2cae54e3f58328a8b74b118ce24880f5"
  family: "9dd61ef88c8cd259f33050e4762847c3"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "operator 0x8b2fe6db"
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
  note: "MEDIUM: no update path, and only the operator's own bankroll is at stake; the operator's withdraw moves it (Helmets2117 precedent). Players deposit no USDC (the only inflow is the operator's transferFrom). Attention: a winner holding an unredeemed signed payout would lose the prize. That is voucher-like, but nothing the player deposited is lost."
---

## Summary

This is a one-shot USDC game. The payout dd3b846f(amount, sig) pays msg.sender only with a signature from the constant 0x58cb02f8. The bankroll comes only from operator 0x8b2fe6db (ca785126 transferFrom), and the operator takes it back with e58f9b54. A signer with code ends payouts, but the operator's own money is still withdrawable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code; selectors unnamed. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: constant 0x58cb02f8 (PUSH32 at pc 0x0ef9 in the check; also a getter at 0x10ec). The operator 0x8b2fe6db is hard-coded in ca785126 (USDC transferFrom from the operator), e58f9b54 (USDC transfer to the operator after a block deadline) and 74d4e825. No setters for either, no proxy slot.
- Trace of tx 0xe96273c3 (block 26438139, 3 blocks after deploy at 26438136): 0x01 returns 0x58cb02f8, then 0.691151 USDC goes to the caller 0xcb920fc2.
- At block 26438999: USDC balance 0; signer 0x58cb02f8 has no code, nonce 0. 0x8b2fe6db is an EOA (latest, block ~26452927).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Operator: redeploy the game with a replaceable signer, and withdraw any bankroll with e58f9b54.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
