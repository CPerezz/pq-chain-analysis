---
id: boostdelegationv3-d37a6aa3-signed-shortcut-lost
title: "BoostDelegationV3: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd37a6aa3d8460bd2b6536d608103d880695a23cd"
  family: "b86f90e66b64e8df7b4d90b6439e5ea0"
  name: "BoostDelegationV3"
  upgradeable: "no"
  rating: LOW
  txs_90d: 53134
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
evidence:
  level: source-read
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
  verdict: confirmed
  rating: LOW
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

BoostDelegationV3: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit: the owner named; approve is the direct call. Read (function text).
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: Vyper permit: the owner named; approve is the direct call. Read (function text).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 53,134 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
