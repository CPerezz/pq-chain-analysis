---
id: yesno-c39d73fc-fixed-signer
title: "YesNo: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc39d73fca64d4ffe2c78fb17e61b9c8489f7c5fb"
  family: "64e86b8e0977f13470d0d2132bcd6e46"
  copies: 22
  name: "YesNo"
  upgradeable: "no"
  rating: HIGH
  value_usd: 122046
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the operator keeps the key without code, or moves users to a new deployment"
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
  rating: HIGH
  note: "one-sided holders locked without resolution"
---

## Summary

`YesNo` at `0xc39d73fca64d4ffe2c78fb17e61b9c8489f7c5fb`, with 21 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YesNo market resolve: the outcome must be signed by ethAddr, the oracle's address fixed when the market was made. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read: resolve() requires ecrecover(factHash, value) == ethAddr, the oracle fixed at market creation; no setter.
- Before resolution only holders of both Yes and No tokens can redeem (destroying a pair); a holder of one side waits for resolve, so that money stays locked if the oracle's address takes code.
- 22 markets as fixed delegates; no upgrade; dormant.

## Impact and exposure

- Value held at block 26,438,999: $122,046 (ETH and 49 priced tokens, over 22 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
