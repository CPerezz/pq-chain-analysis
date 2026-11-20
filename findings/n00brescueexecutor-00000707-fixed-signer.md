---
id: n00brescueexecutor-00000707-fixed-signer
title: "n00bRescueExecutor: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x00000707fe2c9416baf1df3df986c31de293aef4"
  family: "98b1e27e9e9c5eeeb719b53042288955"
  copies: 2
  name: "n00bRescueExecutor"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 286
  last_active: 2026-11-17
  recoveries_14d: 83
fix:
  layer: new-deployment
  who_acts: "n00b Rescue team"
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
  note: "The function dies but nothing is locked, so MEDIUM."
---

## Summary

n00bRescueExecutor runs batched calls only with signatures by `signer` 0x00000ec1…. That address is a storage initializer with no setter, so the rescue service dies. The contract holds no funds by design.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: n00bRescueExecutor: calls must be signed by `signer`, an address written in the source with no setter. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: `address public signer = 0x00000eC17b02b488F99A421B7d283f2630d5aec2;` with no function writing it; verify() compares recoverSigner to signer
- signer has no code
- contract balance 0; it only forwards msg.value

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 286 transactions called it in the 90 days before that block; last on 2026-11-17.
- 83 signature recoveries in the study's two-week trace window.

## Remediation

Team deploys a new executor with a fresh signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
