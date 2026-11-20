---
id: bullbearsettlement-0db4be5e-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0db4be5e475db21f27a735c86c00b4b1f2414b2b"
  family: "4a0a4fd7a2f46b9dedbe67ff11f721ed"
  copies: 2
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: LOW
  txs_90d: 16
  last_active: 2026-11-13
  recoveries_14d: 8
fix:
  layer: none
  who_acts: "users"
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
  rating: LOW
  note: "The same swap stays open to the affected party by a direct call: LOW."
---

## Summary

BullBearSettlement: BENCHMARK_ATTESTOR is immutable (EOA 0xf41a73ae…). It co-signs relayed routes; when its benchmark attestation is missing, the fee is zero and nothing reverts. If it takes code, executeRelayed dies, but users can do the same swap themselves with execute()/executeNative(), which need no attestor.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear relayed execution: the route must be signed by BENCHMARK_ATTESTOR, fixed in the code / BullBear benchmark: signed by…. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BullBearSettlement.sol:435,1090,1380: immutable BENCHMARK_ATTESTOR; _executeRelayed reverts RouteNotAttested; no owner, admin or upgrade (header, line 7).
- Lines 855-858: an invalid benchmark attestation gives a zero fee and no revert.
- execute() (line 1245) pulls from msg.sender with no attestor; contract balance 0; attestor has no code (cast).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 16 transactions called it in the 90 days before that block; last on 2026-11-13.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

None needed; users call execute directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
