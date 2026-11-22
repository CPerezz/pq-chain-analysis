---
id: intentdelegationsubmissionlib-125ee93f-signed-shortcut-lost
title: "IntentDelegationSubmissionLib: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x125ee93fff9e791b153fd16959f6f041e5691201"
  family: "7aabace52b2069df2b8e85b62db94472"
  copies: 17
  name: "IntentDelegationSubmissionLib"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 4254
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "intent owner"
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
  note: "Direct submit open to the same party."
---

## Summary

deBridge IntentDelegationSubmissionLib: submitDelegationsWithSig fails for an intent owner whose address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: deBridge submitDelegationsWithSig: the intent owner signs delegations; it can submit them itself. Read (function text).
- contracts/libraries/IntentDelegationSubmissionLib.sol:52 submitDelegations(...) direct path
- IntentDelegationSubmissionLib.sol:27 submitDelegationsWithSig is the signed variant

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 17 addresses).
- Activity: 4,254 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Intent owner calls submitDelegations itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
