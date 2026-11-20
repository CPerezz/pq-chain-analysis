---
id: bronaccount-34839351-7702-own-key-only
title: "BronAccount: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x34839351adaa85caa15b38dd9973e03c9084d3db"
  family: "b2dab712f0fbf35c5b9779df4f3d4ed4"
  copies: 591
  name: "BronAccount"
  upgradeable: "no"
  rating: LOW
  value_usd: 23288388
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10970
  last_active: 2026-11-17
  recoveries_14d: 958
fix:
  layer: account-migration
  who_acts: "each account owner"
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
  note: "Pure own-key check; re-delegation fixes it -> LOW."
---

## Summary

BronAccount (591 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: BronAccount: OpenZeppelin SignerEIP7702 (line read): the recovered address must be the account itself. Read by hand. Executed: a real transaction reverts once the account holds this logic as real code.
- BronAccount: OpenZeppelin SignerEIP7702._rawSignatureValidation: tryRecoverCalldata == address(this) (per reading.first.json and the note)/source (dossier b2dab712f0fbf35c5b9779df4f3d4ed4)
- Study note: BronAccount: OpenZeppelin SignerEIP7702 (line read): the recovered address must be the account itself. Read by hand. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 10,970, last_active 2026-11-17, value_usd 23288388

## Impact and exposure

- Value held at block 26,438,999: $23.3M (ETH and 49 priced tokens, over 591 addresses).
- Activity: 10,970 transactions called it in the 90 days before that block; last on 2026-11-17.
- 958 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
