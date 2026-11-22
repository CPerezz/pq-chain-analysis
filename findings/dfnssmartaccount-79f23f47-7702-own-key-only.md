---
id: dfnssmartaccount-79f23f47-7702-own-key-only
title: "DfnsSmartAccount: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x79f23f471a194421096b7d1a2bcdf789bf087130"
  family: "4b927346928337186365f7a656877b5a"
  copies: 1343
  name: "DfnsSmartAccount"
  upgradeable: "no"
  rating: LOW
  value_usd: 11910
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-13
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
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $11,910 (held), txs_90d 6"
---

## Summary

DfnsSmartAccount: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- verified source: DfnsSmartAccount.sol:47 `require(address(this) == digest.recover(r, vs))`
- cast code at 26438999: 0xef0100; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $11,910 (ETH and 49 priced tokens, over 1,343 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
