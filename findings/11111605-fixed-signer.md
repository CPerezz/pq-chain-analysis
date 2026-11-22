---
id: 11111605-fixed-signer
title: "0x11111605: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x11111605ef067242653c980b8f6f1ffe50305afe"
  family: "d9953274422210f758b4104c80016a6d"
  copies: 9
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 82815
  last_active: 2026-11-17
  recoveries_14d: 8765
fix:
  layer: new-deployment
  who_acts: "operator"
evidence:
  level: executed
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
  note: "No update path. No money is held, so only the function dies. Whether the router can use the unsigned entry for the same flow is not established, so I did not rate it LOW."
---

## Summary

A stateless swap executor (1inch-called). Selectors 0x4b02d2f6 and 0x2636f7f8 require a signature from 0x4447…7b76, a PUSH32 constant. If that key gets code, the signed entries die for good. An unsigned entry, 0x07e5c0d2, runs the same step interpreter.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: swap executor: a signer that is a constant in the code; the operator's own key. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode contains PUSH32 0x…4447696e7878c0fa2c581768f04c3871a9a57b76 (cast code at block 26438999)
- no setter; EIP-1967 slots zero (reading.first.json)
- cast code 0x4447… = 0x; the contract holds dust only

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 82,815 transactions called it in the 90 days before that block; last on 2026-11-17.
- 8,765 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new executor and repoint the router.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
