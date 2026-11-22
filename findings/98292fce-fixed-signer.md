---
id: 98292fce-fixed-signer
title: "0x98292fce: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x98292fce9d7eb9e843038bda166fbe1b05939180"
  family: "1caf5e40b94851882e3614c15ac5f49c"
  copies: 21
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 191
  last_active: 2026-11-13
  recoveries_14d: 45
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
  note: "The function dies for good, but nothing is locked: the contract holds no funds and has no state-changing function. What other contracts gate on this view was not traced."
---

## Summary

This is a signature checker with view functions only: in a real call to copy 0xa262…b635, ecrecover returned 0x10b8…f087 (an EOA, no code) and the result was compared with a stored registered key (VERIFIER 0x65ac… then checks a P-256 passkey, THRESHOLD 2). No function writes the registered keys, so if that key gets code the check fails for good, but the contract holds and moves no money.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 21 contracts with one stored verifier and a fixed threshold; no setter name. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ABI (heimdall decompile): every function is view or pure, so nothing can replace the registered keys after deployment
- debug_traceTransaction 0xc8ed1811…: ecrecover output 0x10b8…f087, which has no code; scanner flow eq_storage
- balance 0 at block 26438999; FACTORY 0xfacf… (20 KB), VERIFIER is a contract that calls precompile 0x100

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 21 addresses).
- Activity: 191 transactions called it in the 90 days before that block; last on 2026-11-13.
- 45 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with a new key, or with keys that can be rotated.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
