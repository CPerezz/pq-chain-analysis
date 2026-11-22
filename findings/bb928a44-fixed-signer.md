---
id: bb928a44-fixed-signer
title: "0xbb928a44: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbb928a44c681f57fb5fe7c13e6d1e014d92a1251"
  family: "b076e64a294cf83a2b37dd18c71554ba"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 380
  last_active: 2026-11-18
  recoveries_14d: 380
fix:
  layer: new-deployment
  who_acts: "relayer 0x39f1b4be409f2dfc8fcb84c1196537728df727f3 (EOA)"
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
  note: "Operator-only money that remains withdrawable, so MEDIUM."
---

## Summary

Paymaster that validates user ops only with signatures from the constant relayer 0x39f1b4be…, so sponsorship dies. Its 0.075 ETH EntryPoint deposit is the operator's and stays withdrawable through the relayer-gated call().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: paymaster checking a relayer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: PUSH32 0x39f1b4be… at pc 159/816/970; selectors validatePaymasterUserOp, postOp, call, relayer only
- EntryPoint v0.7 balanceOf(paymaster) = 75357576920183258 wei
- cast call --from relayer call(EntryPoint, 0, withdrawTo(relayer, full), 200000) succeeds
- relayer has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 380 transactions called it in the 90 days before that block; last on 2026-11-18.
- 380 signature recoveries in the study's two-week trace window.

## Remediation

Relayer withdraws the deposit and deploys a new paymaster.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
