---
id: relaycontract-6cb5fe1d-rotate-signer-before-migrating
title: "RelayContract: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6cb5fe1d0b5adf12362b0fbb203b0a7898c7ec69"
  family: "fe57b600c32505cc9ff2679aa59b968b"
  copies: 5074
  name: "RelayContract"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 277000
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-11
fix:
  layer: none
  who_acts: "controller (must keep key code-free)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No setter: not LOW. Only the controller's own wallet funds at stake and the controller causes it, so MEDIUM."
---

## Summary

RelayContract wallet: one stored controller signs (to,data,value); anyone submits.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: RelayContract: the signer named must be the controller and must have signed / RelayContract.recoverSignerAddress: returns the signer. Read from source.
- controller slot_0=0x4fa66cdf…1c91 set once by initializer, no setter (reading.keys)
- no proxy, no direct-call path for the controller

## Impact and exposure

- Value held at block 26,438,999: $277,000 (ETH and 49 priced tokens, over 5,074 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

Controller must not put code on its key; else funds stuck.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
