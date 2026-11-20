---
id: dc32a78d-fixed-signer
title: "0xdc32a78d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdc32a78d3868be38a9a047a93c238f6981d2b16d"
  family: "107cc427f434064db84ea87381fc4887"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 88
  last_active: 2026-11-17
  recoveries_14d: 13
fix:
  layer: new-deployment
  who_acts: "owner"
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
  note: "The function dies for good, but nothing is locked: the contract holds no money by design."
---

## Summary

A manifest registry: it emits an event only when the pair is signed by the owner stored in slot 0 (0x96b0…8c53, an EOA). No function changes slot 0. If that key gets code, announcements stop for good. The contract holds no money.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: three selectors; the recovered address is compared with one stored address; no function to replace it. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- owner() = 0x96b0af9f…8c53, no code at block 26438999
- Decompile: only 3 selectors (owner, 0x612b22e5, 0xb7358d7a) and no setter; the dossier reading says no storage writes at runtime
- balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 88 transactions called it in the 90 days before that block; last on 2026-11-17.
- 13 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with a new owner key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
