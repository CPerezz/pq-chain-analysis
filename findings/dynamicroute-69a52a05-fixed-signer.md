---
id: dynamicroute-69a52a05-fixed-signer
title: "DynamicRoute: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x69a52a0570636ca391175ce619bbb9d348040bbc"
  family: "1244851b2205da27f0cd58e0e5294bd5"
  copies: 2
  name: "DynamicRoute"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 128057
  last_active: 2026-11-18
  recoveries_14d: 5147
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
  note: "No update path. The contract holds no money by design, so only the function dies."
---

## Summary

DynamicRoute requires an AUTH_SIGNER signature on every sellBase/sellQuote, and AUTH_SIGNER is immutable. If 0x9a2d…e6 gets code, the adapter reverts for good. It is a pass-through adapter with no admin.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: CallerAuth: the signer must be AUTH_SIGNER, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CallerAuth.sol:9 `address public immutable AUTH_SIGNER`; _runJit always calls _verifyCallerAuth
- cast call AUTH_SIGNER() = 0x9a2D…e0d6e6; cast code = 0x
- Not a proxy, no admin (source comment, line 24)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 128,057 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,147 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new adapter and point the router at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
