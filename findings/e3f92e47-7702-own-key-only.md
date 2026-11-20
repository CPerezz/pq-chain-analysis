---
id: e3f92e47-7702-own-key-only
title: "0xe3f92e47: 7702 logic that accepts only the account's own key"
status: not-affected
severity: NONE
patterns: [PQ-20]
impact: none
contracts:
- address: "0xe3f92e478527e8874dbe1559591abd803de14a3a"
  family: "0b92d59d1b664b77b1237dd34c49082a"
  upgradeable: "no"
  rating: NONE
  value_usd: 22557
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-12
  recoveries_14d: 2
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
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Code is checked first, so a signer with code is refused today. Not a 7702 own-key logic. value $22,557 (held), txs_90d 2"
---

## Summary

Game contract with real code at its own address (no 7702 delegation). Its signed entry functions refuse any caller with code before they recover, so EIP-8151 only adds gas.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: a game contract (13 ETH with tokens): the caller signs its own call. An account with any code (even a 7702 delegation) is already refused by the code-length check today. Bytecode and names.
- heimdall decompile (functions 0x336d477f, 0x7be8f3c7, 0x973cbcd8): `require(!msg.sender.code.length, "No contract calls allowed")` comes before the recover, and then `recovered == msg.sender`
- cast code at 26438999: 22,448 hex chars of real bytecode, not 0xef0100…

## Impact and exposure

- Value held at block 26,438,999: $22,557 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-12.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
