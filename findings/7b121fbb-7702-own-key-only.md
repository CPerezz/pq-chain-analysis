---
id: 7b121fbb-7702-own-key-only
title: "0x7b121fbb: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x7b121fbb6dde5cf206bfefbc575157d63101fbcc"
  family: "26016e0771365068e1bc97542082377c"
  copies: 336
  upgradeable: "no"
  rating: LOW
  value_usd: 20211
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1981
  last_active: 2026-11-17
  recoveries_14d: 71
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
evidence:
  level: executed
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
  note: "Own-key-only check confirmed from the disassembly. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $20,211 (held), txs_90d 1981"
---

## Summary

unnamed 7702 delegate: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Executed: a real transaction reverts once the account holds this logic as real code.
- heimdall disassemble of delegate 0x13e00e08… (ERC-4337 v0.6 account): at pc 0x5dc it keeps ADDRESS as the expected signer, recovers over the "\x19Ethereum Signed Message:\n32" hash (0x7cc), compares (SUB/JUMPI 0x661) and returns 1 on a match, else recovers again over the raw hash and compares again; no other signer
- cast code at 26438999: 0xef010013e00e089f81ad9f36b655c9e9a07c6bf1489a5a; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $20,211 (ETH and 49 priced tokens, over 336 addresses).
- Activity: 1,981 transactions called it in the 90 days before that block; last on 2026-11-17.
- 71 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
