---
id: 99f5a2e5-7702-own-key-only
title: "0x99f5a2e5: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x99f5a2e5d81f22ddb130f4a194584532a3dc3c2e"
  family: "69f97e983dca194fccaee1d3f5ab6d21"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 1187
  last_active: 2026-11-05
  recoveries_14d: 1
fix:
  layer: account-migration
  who_acts: "the account holder"
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
  verdict: confirmed
  rating: LOW
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd None, txs_90d 1187."
---

## Summary

Unverified TrustlessProposer-style delegate (gated caller 0x9ccc2f3e..., withdrawGas to 0x99f5...). Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: 7702 delegate: the recovered address must be the account itself. Bytecode and names.
- heimdall decompile 0xab98c5f8: require(msg.sender == 0x9ccc2f3e...) then EIP-712 domain cache check and recover compared with address(this)
- same gated caller and layout as 0xf2e3 (TrustlessProposer)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,187 transactions called it in the 90 days before that block; last on 2026-11-05.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
