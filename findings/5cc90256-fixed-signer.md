---
id: 5cc90256-fixed-signer
title: "0x5cc90256: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x5cc90256cf88c4bc8b4cfd5f01363d481508c03f"
  family: "705b7868add9f098d6ca4901aee9e19c"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 4
  last_active: 2026-11-15
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: the only path that reaches the check is closed for good by state (accepted=true). The fixed signer is the Safe's own replaceable owner."
---

## Summary

This is a Safe module. Its only ecrecover sits in the one-shot accept() (0xd8aaf4e6), which requires !accepted. accepted() is already true, so the signed path is closed for good. The scheduled withdraw() runs without any signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile: d8aaf4e6 requires msg.sender==Safe 0x483cc4a5, !store_a (accepted), and recovered==0x1c3eaeeb, then sets accepted. facts.json n_ec=1.
- At block 26438999: accepted()=true, acceptedAt()=1794655727, Safe getOwners()=[0x1c3eaeeb], threshold 1. The signer 0x1c3eaeeb is an EOA with nonce 8.
- Trace of tx 0x0586ad6f (block 26412927): the Safe CREATE2-deploys the module, calls accept() (the one recovery, signed by 0x1c3eaeeb), then calls enableModule.
- 3ccfd60b withdraw(): requires accepted, the Safe owner set and the window. No ecrecover.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-15.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

None needed. The Safe owner can also disable the module and deploy a new one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
