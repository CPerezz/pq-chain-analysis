---
id: 52e172c8-fixed-signer
title: "0x52e172c8: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x52e172c80cea31816ed0e3431401b60f70842333"
  family: "0744755a4c156701de3e178a4c797003"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-11-07
  recoveries_14d: 6
fix:
  layer: new-deployment
  who_acts: "operator (BullBear)"
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
  note: "No update path. Users keep direct swaps, and only the operator's fee and relay service are lost: MEDIUM. The LOW precedent 0x0db4… uses the same key and mechanism, so the reviewer should settle MEDIUM vs LOW once for the whole family."
---

## Summary

Unverified BullBearSettlement build (BENCHMARK_ATTESTOR, quoteFee, rescue, UNIV4_FACET), newest in the family. The constant attestor 0xf41a73ae…e56e, the same key as the LOW precedent 0x0db4…, gates the two relayed entry points and the fee benchmark. If it takes code, relayed swaps and the attested fee die, but direct execute paths and the GUARDIAN rescue still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: settlement contract: an attestor that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Heimdall: 0xf41a73ae… is inlined as a constant; the relayed variants (0xc20f39e8, 0xf0c397ee) `require(attestor)` before recovering, and the fee check 0x8bc1d750 compares the recovered address to it.
- Its dispatch is a superset of the verified 0x0db4… BullBear (plus PROTO_BEBOP, rescue, quoteFee, facet getters), with the same direct execute selectors (0x08b1c516 and others), which need no attestor.
- rescue(address) requires msg.sender == GUARDIAN 0x03db85dc… (an EOA with nonce 0) and pays FEE_RECIPIENT 0xC24d1419…. EIP-1967 slots are 0; balance 0.
- cast at block 26438999: BENCHMARK_ATTESTOR() = 0xf41a73aE…, no code, nonce 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-07.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

The operator deploys a new contract with a replaceable attestor.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
