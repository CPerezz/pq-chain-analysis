---
id: caliburentry-ce890746-7702-own-key-only
title: "CaliburEntry: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xce890746664e17a3220e1f64d1b7f86c1e4be4b2"
  family: "545783d93e913a4554fc99faccb15177"
  copies: 159930
  name: "CaliburEntry"
  label: "Uniswap: EIP-7702 Delegator 1"
  upgradeable: "no"
  rating: LOW
  value_usd: 34914988
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 382964
  last_active: 2026-11-18
  recoveries_14d: 17291
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
  note: "Registered keys other than the own key are unaffected"
---

## Summary

CaliburEntry (159,930 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: 7702 account logic (159,930 accounts): the account's own key, and keys it registered (compared with values the scanner cannot name). Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- Uniswap CaliburEntry (Delegator 1): same logic; root key = the account, plus registered secp256k1/P-256/WebAuthn keys/source (dossier 545783d93e913a4554fc99faccb15177)
- Study note: 7702 account logic (159,930 accounts): the account's own key, and keys it registered (compared with values the scanner cannot name). Bytecode and names. Executed: a real transaction reverts once the account holds this lo
- Activity (measured): txs_90d 382,964, last_active 2026-11-18, value_usd 34914988

## Impact and exposure

- Value held at block 26,438,999: $34.9M (ETH and 49 priced tokens, over 159,930 addresses).
- Activity: 382,964 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,291 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
