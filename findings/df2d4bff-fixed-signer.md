---
id: df2d4bff-fixed-signer
title: "0xdf2d4bff: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdf2d4bffec010debd302674c9fb9cda99bb5e852"
  family: "5b3b5ce256117b81b709fe799c5dc01b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 570
  last_active: 2026-11-17
  recoveries_14d: 53
fix:
  layer: new-deployment
  who_acts: "zone operator / order makers"
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
  note: "The zone dies for good but nothing is locked, so MEDIUM."
---

## Summary

Seaport signed zone (authorizeOrder/validateOrder/getSeaportMetadata only) whose signers live in a mapping that no function writes. Orders routed through it become unfillable, but the zone holds nothing and makers can cancel on Seaport.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signed zone with three selectors: signers in a mapping, no function to change them. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 4 selectors, none writes storage; signer check against storage_map_a (heimdall)
- recovered signer 0xbe51166ce403686d165675c1fd9c465b2948d1ed has no code
- zone balance 0; Seaport orders are approvals, so maker assets never leave maker wallets

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 570 transactions called it in the 90 days before that block; last on 2026-11-17.
- 53 signature recoveries in the study's two-week trace window.

## Remediation

Operator deploys a new zone; makers re-list.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
