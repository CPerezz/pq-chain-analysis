---
id: 2c6f0179-fixed-signer
title: "0x2c6f0179: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2c6f01799fa9db1e7f2797e5ba892b72b865571d"
  family: "748e11a011a4c6590d5f666ba008a6a3"
  upgradeable: "no"
  rating: LOW
  txs_90d: 101
  last_active: 2026-09-27
fix:
  layer: none
  who_acts: "account owners"
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
  rating: LOW
  note: "Checked this row's own bytecode for the same bypass, not only the template. The same act stays open by direct call."
---

## Summary

Same Executor 7702 delegate as 0x005c: functions signed by the constant operator 0x135e…6bfb move the account's assets, but self-calls skip the signature check. Account owners keep the same act directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 7702 delegate used by 11,283 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode contains the constant 0x135e7a48…6bfb, which has no code
- Disassembly at pc 0x190f: ADDRESS, CALLER, SUB, ISZERO, JUMPI, the same self-call bypass as in 0x005c
- facts.json: the same exit set as 0x005c (withdrawEth, transfer…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 101 transactions called it in the 90 days before that block; last on 2026-09-27.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
