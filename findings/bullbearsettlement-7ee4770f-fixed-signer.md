---
id: bullbearsettlement-7ee4770f-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7ee4770f87f28eb55deded758445b1093fdb43e1"
  family: "5be1dfd5073586300828ab64b60af66d"
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4
  last_active: 2026-09-06
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
  note: "Only the operator's fee revenue dies, with no update path, and users lose nothing: MEDIUM, matching the BullBear precedents. LOW is arguable, since no user-facing act is lost at all."
---

## Summary

Earlier BullBearSettlement build (verified source). The immutable BENCHMARK_ATTESTOR 0xa7001d0c…3cd4 only signs fee benchmarks; in this build executeRelayed needs only the user's Permit2 signature, not the attestor's. If the attestor takes code, the fee is zero for good and every swap path keeps working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear benchmark: signed by BENCHMARK_ATTESTOR, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source lines 350/666: immutable BENCHMARK_ATTESTOR. Lines 1027-1039: _benchmarkAttested returns false on a bad signature. Lines 940-948: the surplus fee is charged only when the benchmark is attested, otherwise the fee is 0 and nothing reverts.
- executeRelayed (lines 764-798) has no _recoverAttestor check. execute() pulls tokens from msg.sender. No owner, admin or upgrade (line 7); EIP-1967 slots are 0.
- cast at block 26438999: attestor 0xa7001d0C…, an EOA with nonce 7; FEE_RECIPIENT 0xC24d1419…; balance 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-09-06.

## Remediation

The operator deploys a new contract with a replaceable attestor if it wants to keep the surplus fee.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
