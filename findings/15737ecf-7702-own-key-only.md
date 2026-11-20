---
id: 15737ecf-7702-own-key-only
title: "0x15737ecf: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x15737ecf3e802ab57c92a307bf9225cac9d7e47d"
  family: "b781c554f507a82a1ca019c3c30585fe"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-10-30
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

Delegate-style wallet logic that accepts only signatures recovering to address(this); as 7702 delegate code it is unaffected, only an account holding it as real code could not sign for itself.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- bytecode: recovered address SUB/EQ ADDRESS in 1626ba7e/execute paths; isRelayer gating; not delegated (direct code)
- row address holds the logic as its own deployed code (no key behind it); no stored signer/setter seen
- ETH at block 26438999: 0.000000000000000000

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-10-30.

## Remediation

keep the 7702 delegation (exempt) or re-delegate; never install this logic as real code at a keyed account

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
