---
id: b7c0f937-fixed-signer
title: "0xb7c0f937: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7c0f937edd57c416a082a7a737dbce1681c1cca"
  family: "29c1a29310c49ed0124fee2746371775"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "operator"
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
  note: "MEDIUM: no update path. The signed forwarding function dies for good, but the contract holds no money by design (pull and push in one tx), so nothing is locked."
---

## Summary

This is a fee-quote token forwarder. a771788d needs a quote signed by the constant AUTHORIZED_QUOTE_SIGNER 0x8907efa2. It pulls the user's tokens and pushes them to the recipient, with a fee to TREASURY, in the same tx. If the signer takes code the router dies, but it holds nothing.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a quote signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: PUSH32 0x8907efa2… then EQ against the recovered address at pc 0x0abe-0x0b0c. The constant is also exposed as AUTHORIZED_QUOTE_SIGNER(). Storage is only usedNonces (slot 2). No owner, no proxy slot.
- Trace of tx 0xf9f37edc (block 26438523): 0x01 returns 0x8907efa2, then USDT transferFrom(user→contract), transfer to recipient 0x1511dc7f, and fee 0x7a315 to TREASURY 0xae171ef1.
- 0x8907efa2 at block 26438999: no code, nonce 0. 0xae171ef1: EOA (latest, block ~26452927).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new forwarder with a replaceable signer. Users can transfer tokens directly in the meantime.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
