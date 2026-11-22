---
id: caliburentry-ea6294f6-7702-own-key-only
title: "CaliburEntry: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xea6294f6d4b231141f04562887a0d06f8df3bd49"
  family: "6d5daa999c3fe77f76a54093d0567224"
  copies: 47265
  name: "CaliburEntry"
  upgradeable: "no"
  rating: LOW
  value_usd: 35728664
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 414542
  last_active: 2026-11-18
  recoveries_14d: 7269
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
  note: "Own key is the root/admin; other registered keys (incl. passkeys) keep working when the account has real code. Fix stays LOW: re-delegate or rely on a registered non-own key"
---

## Summary

CaliburEntry (47,265 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: 7702 account logic (47,265 accounts): as above. Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- Uniswap CaliburEntry: root key = the account itself (secp256k1); the account can register extra keys (secp256k1, P-256, WebAuthn) via key management; imports OZ P256/source (dossier 6d5daa999c3fe77f76a54093d0567224)
- Study note: 7702 account logic (47,265 accounts): as above. Bytecode and names. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 414,542, last_active 2026-11-18, value_usd 35728664

## Impact and exposure

- Value held at block 26,438,999: $35.7M (ETH and 49 priced tokens, over 47,265 addresses).
- Activity: 414,542 transactions called it in the 90 days before that block; last on 2026-11-18.
- 7,269 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
