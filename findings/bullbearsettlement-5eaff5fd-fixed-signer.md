---
id: bullbearsettlement-5eaff5fd-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5eaff5fd39058968809daf8a8a21291465663509"
  family: "64fa272610be2836465ad7fbbdb0cb49"
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-09-18
fix:
  layer: new-deployment
  who_acts: "operator (BullBear)"
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
  note: "Users keep the same swap directly, and only the operator's fee is lost for good: MEDIUM, matching the precedents."
---

## Summary

Later BullBearSettlement build (verified source, adds executeWithPermit2, Hashflow and a facet split). Same immutable BENCHMARK_ATTESTOR 0xa7001d0c…3cd4: it co-signs executeRelayed routes and fee benchmarks, and a failed benchmark means a zero fee, not a revert. execute(), executeNative() and executeWithPermit2() need no attestor.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear relayed execution: the route must be signed by BENCHMARK_ATTESTOR, fixed in the code / BullBear benchmark: signed by…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source lines 416/966: immutable BENCHMARK_ATTESTOR. Line 1256: executeRelayed reverts RouteNotAttested unless the attestor signs. Lines 1714-1726: a failed benchmark attestation returns false, so the fee is 0.
- Lines 1121/1150: execute() and executeWithPermit2() are self-directed with no attestor (comment at line 1141). Line 7: no owner, admin or upgrade. GUARDIAN 0x4689ec8f… can only pause.
- cast at block 26438999: attestor 0xa7001d0C…, an EOA with nonce 7; balance 0; EIP-1967 slots are 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-18.

## Remediation

The operator deploys a new contract with a replaceable attestor, or keeps the key free of code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
