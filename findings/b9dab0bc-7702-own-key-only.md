---
id: b9dab0bc-7702-own-key-only
title: "0xb9dab0bc: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xb9dab0bcbeedb5a37e3fd865b510dc3f6bee5822"
  family: "9ad967295ebd15fc7f7207066858a407"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
  recoveries_14d: 185
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

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Executed: a real transaction reverts once the account holds this logic as real code.
- bytecode: ADDRESS passed as expected signer into the recover helper (0x04ed) after marking the nonce used; no stored signer or setter
- row address holds the logic as its own deployed code (no key behind it); no stored signer/setter seen
- ETH at block 26438999: 0.000000000000000000

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.
- 185 signature recoveries in the study's two-week trace window.

## Remediation

keep the 7702 delegation (exempt) or re-delegate; never install this logic as real code at a keyed account

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
