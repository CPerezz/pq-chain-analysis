---
id: bullbearsettlement-128716ea-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x128716eaab226a68299d3c0198a38c1e90c52356"
  family: "3125adc24cbb44e40c51bbb5f19e00f8"
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 37
  last_active: 2026-09-14
fix:
  layer: new-deployment
  who_acts: "BullBear operator"
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
  note: "Only the operator's fee is at stake, with no update path (MEDIUM). Users keep the same act."
---

## Summary

BullBearSettlement (own source verified): the immutable BENCHMARK_ATTESTOR 0xa700…3cd4 (an EOA) signs fee benchmarks. Failure means the fee is 0 and nothing reverts. Users keep execute() directly. The operator loses its attested fee for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear benchmark: signed by BENCHMARK_ATTESTOR, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BENCHMARK_ATTESTOR() = 0xa7001d0C…3CD4, no code; the source says no owner or admin or upgrade
- Source _benchmarkAttested returns false (fee 0) when the recovery fails
- The gate1 dossier's address equals this row

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 37 transactions called it in the 90 days before that block; last on 2026-09-14.

## Remediation

Deploy a new settlement with a new attestor.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
