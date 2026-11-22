---
id: bullbearsettlement-aacb24e5-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaacb24e5d0e0b426b22f99e280e494770265f8a4"
  family: "ccec11fd0f24089b90473e89508361df"
  copies: 3
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 43
  last_active: 2026-10-08
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
  note: "Users keep the same act by a direct call; only the operator's fee is at stake, with no update path (MEDIUM)."
---

## Summary

In BullBearSettlement, the immutable BENCHMARK_ATTESTOR 0xa700…3cd4 (an EOA) signs benchmark attestations. A missing or invalid attestation sets the fee to zero and never reverts. Relayed execution also needs its signature. Users keep execute() directly. The attestor-gated fee revenue (the operator's own money) is lost for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear relayed execution: the route must be signed by BENCHMARK_ATTESTOR, fixed in the code / BullBear benchmark: signed by…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BENCHMARK_ATTESTOR() = 0xa7001d0C…3CD4, no code; immutable, and the source says no owner, admin or upgrade
- Source _benchmarkAttested: returns false when the signature fails, so fee = 0; execute() needs no attestor signature
- Source read is 0x917a… (gate1 dossier); this row's bytecode differs (md5) but has the same ABI shape and the same attestor getter

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 43 transactions called it in the 90 days before that block; last on 2026-10-08.

## Remediation

Deploy a new settlement with a new attestor.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
