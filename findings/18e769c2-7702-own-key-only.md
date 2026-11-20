---
id: 18e769c2-7702-own-key-only
title: "0x18e769c2: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: funds-locked
contracts:
- address: "0x18e769c2823ad22235d3c80484850298c8a8986e"
  family: "fe8fe9efc0e4bfb9cb952c6e507926dd"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  txs_90d: 485
  last_active: 2026-11-17
  recoveries_14d: 84
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
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
  note: "reviewed through the root issue's mechanism and a random sample (D-025)"
---

## Summary

Contract `0x18e769c2823ad22235d3c80484850298c8a8986e`, with 3 more addresses running its code. EIP-7702 account logic that accepts only the account's own key; an account that takes it as real code is locked.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Hinkal Emporium: operations run from a user's Hinkal wallet need the ECDSA signature of the signerAddress named in the call (tryRecover, no ERC-1271); operations without a wallet need none.…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism (D-025): the delegate's signature check requires the recovered address to be the account itself, so an account that later holds real code fails its own check; the account fixes it by re-delegating to logic that does not rely on its own key, or by keeping its EIP-7702 delegation, which EIP-8151 exempts (LOW)
- A random sample of 25 of the 668 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 100 rows over the thresholds (5 ETH or 1,000 transactions in 90 days) were checked one by one: 95 LOW, 5 not affected

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 485 transactions called it in the 90 days before that block; last on 2026-11-17.
- 84 signature recoveries in the study's two-week trace window.

## Remediation

Delegates must not be offered as real-code migration targets; accounts keep the delegation or move to logic with another key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
