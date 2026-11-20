---
id: 24d2eb5a-fixed-signer
title: "0x24d2eb5a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x24d2eb5a4aff03715dae837ca14f049fc01a9721"
  family: "c20bb46e289ae10b39b8cc7535a36c51"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new factory with a signer that can be replaced."
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
  note: "MEDIUM because only creation of new workspace contracts would stop; the code shows no user funds held and locked. The 'presale' label in the study note does not match this code."
---

## Summary

The signer is a hardcoded constant EOA (0xf0d8…5041) and nothing can replace it. If that account gets real code, signed workspace creation stops. No existing funds are locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant signWallet decimal value equals 0xf0d8c6284a1305fe5359cf26c194ce6fc6a05041, the address compared in Unresolved_8b8bb3ab
- 0xf0d8c6284a1305fe5359cf26c194ce6fc6a05041 has no code at block 26438999 (EOA)
- Unresolved_e49d0045 reverts with 'WorkspaceAccessFactoryUpgradeable: INVALID_SIGNATURE' when the signature check fails
- The only setter-like functions are transferOwnership and renounceOwnership, which change only owner storage

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new factory whose signer is in storage with an owner-only setter, or that accepts ERC-1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
