---
id: bf7fe109-fixed-signer
title: "0xbf7fe109: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf7fe109f674ab1341d69e67a262e50ce87eb7c1"
  family: "015573baed7231d9b4b7c2b0856f3f9d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 17945
  last_active: 2026-11-18
  recoveries_14d: 101529
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
  note: "No update path, and nothing is held. Unredeemed signed claims are the operator's to make good."
---

## Summary

The eNAT tax router checks every claim against the constant operator 0x342b…0a21. If that key gets code, claimDeposit and batchClaimDeposit die for good. The router holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: deposit claims are checked against a signer that is a constant in the code; no upgrade path. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode PUSH32 …342bf884…0a21 at pc 417 and 2201; no setter, no owner function, no proxy (reading.first.json)
- eNAT balanceOf(router) = 0 and ETH = 0 at block 26438999
- cast code 0x342b… = 0x

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 17,945 transactions called it in the 90 days before that block; last on 2026-11-18.
- 101,529 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new router (this is tied to the 0x56d0 wrapper, which has the same fixed operator).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
