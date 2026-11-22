---
id: smartwalletentry-405c6f5a-7702-own-key-only
title: "SmartWalletEntry: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x405c6f5acd29dc6b72f3cce8e4f6a76fa3d53c7a"
  family: "099a9a9fdb147cdb55cfae5217bcf9bc"
  copies: 9172
  name: "SmartWalletEntry"
  upgradeable: "yes"
  rating: LOW
  value_usd: 4722894
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72510
  last_active: 2026-11-18
  recoveries_14d: 588
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
  note: "Passkeys and external validators keep working; UUPS-upgradeable by self-call only"
---

## Summary

SmartWalletEntry (9,172 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; longer ones go to other signers the account added. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- SmartWalletEntry 1.1.0: owners are key hashes mapped to a validator (built-in ECDSA, built-in passkey, or an external contract whose code.length is checked, line 274); the own key is the default owner/source (dossier 099a9a9fdb147cdb55cfae5217bcf9bc)
- Study note: a 65-byte signature must recover to the account itself; longer ones go to other signers the account added. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 72,510, last_active 2026-11-18, value_usd 4722894

## Impact and exposure

- Value held at block 26,438,999: $4.7M (ETH and 49 priced tokens, over 9,172 addresses).
- Activity: 72,510 transactions called it in the 90 days before that block; last on 2026-11-18.
- 588 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
