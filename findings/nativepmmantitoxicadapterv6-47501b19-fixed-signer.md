---
id: nativepmmantitoxicadapterv6-47501b19-fixed-signer
title: "NativePmmAntiToxicAdapterV6: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x47501b19d6db513308d126a3460382cdc61ab3a7"
  family: "bfe89089af5b7c0aca8a07c84c9c4cc4"
  name: "NativePmmAntiToxicAdapterV6"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 7172
  last_active: 2026-11-18
  recoveries_14d: 6583
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
  note: "No update path. No money is held by design."
---

## Summary

NativePmmAntiToxicAdapterV6 always checks the immutable AUTH_SIGNER 0x9a2d…e6 on sellBase/sellQuote. If that key gets code, the adapter dies for good. It holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: CallerAuth (variant): the signer must be AUTH_SIGNER, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CallerAuth.sol:8 immutable AUTH_SIGNER; cast call = 0x9a2D…e6, cast code = 0x
- both entries call _verifyNativeAuth; there is no ERC-1271 path and no owner bypass
- not a proxy

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,172 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6,583 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new adapter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
