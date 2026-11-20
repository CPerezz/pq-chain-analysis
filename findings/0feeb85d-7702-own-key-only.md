---
id: 0feeb85d-7702-own-key-only
title: "0x0feeb85d: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x0feeb85d237db3917c444fd1c14e812913781a29"
  family: "aaf036674e52bc8dc16309ffe9dc774d"
  copies: 14
  upgradeable: "no"
  rating: LOW
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the account holder (keep or re-delegate the 7702 delegation)"
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
  note: "Own-key check found; the fix is a 7702 re-delegation/keeping the delegation, so LOW."
---

## Summary

EOA delegated via EIP-7702 whose delegate accepts only the account's own key; the 0xef0100 indicator is exempt under EIP-8151, so it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- account is 7702-delegated (-> 0x4ed1b9f4…), nonce 20; delegate 6171d1c9 requires recovered == address(this) (5cd5d233)
- row address code is 0xef0100 delegation indicator (cast code @26438999)
- ETH at block 26438999: 0.000000027160937240

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

keep the 7702 delegation (exempt) or re-delegate; never install this logic as real code at a keyed account

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
