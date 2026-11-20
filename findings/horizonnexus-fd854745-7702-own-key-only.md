---
id: horizonnexus-fd854745-7702-own-key-only
title: "HorizonNexus: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xfd854745a0d1de5ec2a6f33f6ca03b8a4fde694c"
  family: "66056dfd368c20933edc31c76c52de29"
  copies: 1151
  name: "HorizonNexus"
  upgradeable: "yes"
  rating: LOW
  value_usd: 46919
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 326
  last_active: 2026-11-14
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Own-key check confirmed from source, but it is gated to 7702 accounts, which keep working while delegated. LOW (re-delegate or stay delegated). value $46,919 (held), txs_90d 326"
---

## Summary

HorizonNexus account as a real-code proxy. The own-key recover only runs for 7702-delegated Nexus accounts (exempt); this proxy signs through validator modules.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Solady LibPREP: proves once, at initialisation, that the account's address comes out of a 7702 authorisation whose s is the hash of r, a key nobody holds. Read from source.
- verified source: HorizonNexus wraps Nexus 1.2.0 (dependencies/nexus-1.2.0): own-key check only on the _amIERC7702() init path; LibPREP init; validators for other signatures
- cast code at 26438999: real code (proxy, 276 ERC-1967 hex chars). On real code _amIERC7702() is false, so the own-key branch is skipped and validators sign

## Impact and exposure

- Value held at block 26,438,999: $46,919 (ETH and 49 priced tokens, over 1,151 addresses).
- Activity: 326 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
