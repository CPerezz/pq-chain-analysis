---
id: gassponsor-cb4f19e6-7702-own-key-only
title: "GasSponsor: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xcb4f19e685922d6f0a7d53d3f975e019566231d9"
  family: "4349ff8d8ae98ccbea6f271bc71e7ceb"
  copies: 51
  name: "GasSponsor"
  upgradeable: "no"
  rating: LOW
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 28638
  last_active: 2026-11-18
  recoveries_14d: 5211
fix:
  layer: account-migration
  who_acts: "the account holder"
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
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd 1083, txs_90d 28638."
---

## Summary

GasSponsor 7702 delegate (sponsored batch execution and ERC-1271 for the delegating EOA). Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- GasSponsor.sol:209 isValidSignature returns 0x1626ba7e only if recovered == address(this)
- GasSponsor.sol:250-253 and :282 execute paths revert InvalidSignerError unless digest.recover(signature) == address(this)
- no code/0xef0100 check in src/

## Impact and exposure

- Value held at block 26,438,999: $1,083 (ETH and 49 priced tokens, over 51 addresses).
- Activity: 28,638 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,211 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
