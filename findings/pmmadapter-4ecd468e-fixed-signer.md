---
id: pmmadapter-4ecd468e-fixed-signer
title: "PMMAdapter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4ecd468e1010e006f768ec034e5a6d8803183469"
  family: "2c7a3f1aa6e1f68f4d20ff611c6dddaf"
  name: "PMMAdapter"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 40164
  last_active: 2026-11-18
  recoveries_14d: 1596
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
  note: "No update path. The contract holds no money by design."
---

## Summary

PMMAdapter checks the immutable AUTH_SIGNER only for order type 4. If 0x9a2d…e6 gets code, V4 fills through this adapter die for good. V1-V3 orders skip the check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: CallerAuth: the signer must be AUTH_SIGNER, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CallerAuth: AUTH_SIGNER immutable; cast call AUTH_SIGNER() = 0x9a2D…e6, cast code = 0x
- PmmAdaptor.sol:125-132: only orderType 4 calls _verifyCallerAuth
- No proxy, no admin, no funds held (reading.first.json)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 40,164 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,596 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new adapter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
