---
id: customsetoracle-e67d778d-signed-shortcut-lost
title: "CustomSetOracle: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xe67d778d2d5eed4e4c410a79d9037e411c958c03"
  family: "fe05a8f2d4c3297c7c95126b758f8000"
  name: "CustomSetOracle"
  upgradeable: "no"
  rating: NONE
  txs_90d: 12726
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "No signed path in the deployed contract; the row attributed bundled library code to it."
---

## Summary

Tokemak CustomSetOracle, a role-gated price oracle; the flagged AutopoolToken permit belongs to a library bundled in the verified source, not to this contract.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Tokemak AutopoolToken permit: ECDSA.recover must equal the owner named in the call. Read (function text).
- CustomSetOracle.sol imports only Roles, Errors, SystemComponent, SecurityBase, interfaces, BaseOracleDenominations; no ECDSA/AutopoolToken
- deployed code at 26438999 lacks the permit (0xd505accf) and approve (0x095ea7b3) selectors

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 12,726 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
