---
id: hskimplementationv1-4f380192-signed-shortcut-lost
title: "HSKImplementationV1: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x4f380192c76a959b0dd271d2bf6b8fecebe74479"
  family: "24ced299cc88c1ee526988f7efb27329"
  copies: 4
  name: "HSKImplementationV1"
  upgradeable: "yes"
  rating: NONE
  value_usd: 16
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5566
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "the claimed lost path accepts ERC-1271 for a signer with code → refuted per the rubric (a signer whose code does not implement ERC-1271 still fails, but it keeps approve/transfer)."
---

## Summary

HSKImplementationV1: the signed path named in the row checks ERC-1271 for a signer with code, so EIP-8151 does not take it away.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- permit(v,r,s) with an owner whose code returns the ERC-1271 magic value (state override, block 26438999) succeeds (returns 0x)
- HSK implementation: permit routes through CheckSig, which asks a signer with code through ERC-1271 (bytecode has PUSH4 0x1626ba7e; decompiled CheckSig branches on owner.code.length).
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $16 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 5,566 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
