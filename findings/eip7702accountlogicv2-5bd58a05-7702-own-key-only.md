---
id: eip7702accountlogicv2-5bd58a05-7702-own-key-only
title: "EIP7702AccountLogicV2: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x5bd58a0544b165cc90f7a4b083e0e0df7d2347ea"
  family: "b854fdece6b69d736391b0ea392125ed"
  copies: 11587
  name: "EIP7702AccountLogicV2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4066
  last_active: 2026-11-18
  recoveries_14d: 369
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
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd None, txs_90d 4066."
---

## Summary

EIP7702AccountLogicV2: approveAndSend / sendNative authorised by the EOA own signature. Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- EIP7702AccountLogicV2.sol:700 and :730 require(recovered == address(this), "Invalid signer")
- no ERC-1271 or code check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 11,587 addresses).
- Activity: 4,066 transactions called it in the 90 days before that block; last on 2026-11-18.
- 369 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
