---
id: presale-b5f2b7d8-fixed-signer
title: "Presale: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5f2b7d8936cc1455b23b178fdb053591996af27"
  family: "80af2596a4437a965ea2816bfe53c4a6"
  name: "Presale"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 50564
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner distributes or refunds by direct withdrawal"
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
  note: "claims stop; owner can move funds"
---

## Summary

`Presale` at `0xb5f2b7d8936cc1455b23b178fdb053591996af27`. Deposits and claims need a signature of SIGNER, fixed in the code; a SIGNER with code stops them, but the owner can still move the funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: deposit and claim check SIGNER, a constant; no setter.
- withdraw(address) and unlock are owner functions without a signature; the owner is 0xff189035a74fd4e5ff710f1db96fc4126df55446.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $50,564 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner refunds or distributes directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
