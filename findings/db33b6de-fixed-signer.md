---
id: db33b6de-fixed-signer
title: "0xdb33b6de: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdb33b6dec9bad3ce5669d358a651a4e5b52505ee"
  family: "3543a91baca584af8a9ab2b0e60864b5"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 36
  last_active: 2026-11-13
  recoveries_14d: 9
fix:
  layer: new-deployment
  who_acts: "paymaster owner"
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
  note: "No update path and the function dies, but the operator's money still leaves (MEDIUM)."
---

## Summary

A verifying paymaster (EntryPoint v0.8). verifyingSigner equals the owner 0x61df…acdf, an EOA with a 7702 delegation indicator, so its signatures still recover today. There is no setter or upgrade. If it gets real code, sponsorship stops. The owner still withdraws the deposit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: verifying paymaster: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyingSigner() = owner() = 0x61df…aCDf, code 0xef0100e6ca… (a delegation, not real code)
- cast call --from owner withdrawTo(owner, 836121037479905) succeeds
- No setter or upgrade selector in the bytecode

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-13.
- 9 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new paymaster and withdraw the deposit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
