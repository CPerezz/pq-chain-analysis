---
id: ba412d8b-rotate-signer-before-migrating
title: "0xba412d8b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xba412d8b36bfd7d65dff5cc0df7b3c29a7eae687"
  family: "9e1a9c30be9b176309353ac4957e8590"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 33023
  last_active: 2026-11-18
  recoveries_14d: 11464
fix:
  layer: onchain-config
  who_acts: "the owner sets a new fee signer (selector 0xfffac7ed)"
evidence:
  level: executed
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
  note: "The fee signer sits in storage slot 2 and the owner replaces it with 0xfffac7ed, so the key is rotated before it takes code: LOW under the rotation root issue."
---

## Summary

The fee signer sits in storage slot 2, and the owner can replace it with selector 0xfffac7ed. The key is settable.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: swap executor: one stored signer, no function name that changes it; the operator's own key. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast storage slot2 = 0x57ed…6d05 (signer), slot0 low 20 bytes = 0x0bc6…dcd8 (owner, no code)
- cast call --from 0x0bc6…dcd8 0xfffac7ed(0x1111…) succeeds at block 26438999
- swaps with all fee fields zero skip the check (reading.first.json)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 33,023 transactions called it in the 90 days before that block; last on 2026-11-18.
- 11,464 signature recoveries in the study's two-week trace window.

## Remediation

The owner sets a new signer before migrating the old key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
