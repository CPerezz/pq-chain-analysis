---
id: usm-03eb7ce2-signed-shortcut-lost
title: "USM: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x03eb7ce2907e202bb70bae3d7b0c588573d3cecc"
  family: "3cfc50ab5ee4c84f78bac455c0f3a9fd"
  name: "USM"
  upgradeable: "no"
  rating: LOW
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Direct twins exist for both signed paths. Value $12993, txs_90d 0 (not rating inputs)."
---

## Summary

USM (Yield/USM): permit and addDelegateBySignature are signed shortcuts. A user with code still approves and adds delegates directly.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Yield v1 permit: the owner named must have signed / USM addDelegateBySignature: the user named must have signed. Read from source.
- source USM.sol:891 addDelegate(delegate) → _addDelegate(msg.sender, delegate)
- addDelegateBySignature(user,…) at :901 is the signed twin; standard approve present

## Impact and exposure

- Value held at block 26,438,999: $12,993 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Call approve / addDelegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
