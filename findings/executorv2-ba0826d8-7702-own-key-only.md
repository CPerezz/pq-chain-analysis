---
id: executorv2-ba0826d8-7702-own-key-only
title: "ExecutorV2: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xba0826d815b3d9f5a28816144ca6b81bec92abff"
  family: "a26b4c788fab1ce853b7266e478b1909"
  copies: 1399
  name: "ExecutorV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 121266
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1860
  last_active: 2026-11-17
  recoveries_14d: 135
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
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $121,266 (held), txs_90d 1860"
---

## Summary

ExecutorV2: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: batchExecuteRelayed (read) hands the recovered signer to _requireValidSigner; the deployed code compares it with the account's own address and nothing else. Read (same text as a family read). Executed: a real transaction reverts once the account holds this logic as real code.
- verified source: source/src/utils/SanityChecks.sol:18 `if (_signer != address(this))` revert; ExecutorV2.sol:138 ECDSA.recover
- cast code at 26438999: 0xef0100; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $121,266 (ETH and 49 priced tokens, over 1,399 addresses).
- Activity: 1,860 transactions called it in the 90 days before that block; last on 2026-11-17.
- 135 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
