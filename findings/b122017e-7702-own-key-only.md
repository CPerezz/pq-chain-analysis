---
id: b122017e-7702-own-key-only
title: "0xb122017e (tagged deployed by Bitget Wallet: Deployer 2): 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xb122017e36d1b4c5524c32257da9f90a0e882c8f"
  family: "8fe0d4ef007f0c2cd306569e562c31da"
  copies: 129531
  label: "deployed by Bitget Wallet: Deployer 2"
  upgradeable: "no"
  rating: LOW
  value_usd: 57848419
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 554554
  last_active: 2026-11-18
  recoveries_14d: 439
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
  note: "No verified source; read from the bytecode reading"
---

## Summary

deployed by Bitget Wallet: Deployer 2 (129,531 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only. Executed: a real transaction is unaffected by code at the signer.
- Bytecode only (Bitget Wallet deployer): reading.first.json says the recovered address must equal the account itself (isValidSignature, validateUserOp); batch execution goes through an external validator contract/source (dossier 8fe0d4ef007f0c2cd306569e562c31da)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only. Executed: a real transacti
- Activity (measured): txs_90d 554,554, last_active 2026-11-18, value_usd 57848419

## Impact and exposure

- Value held at block 26,438,999: $57.8M (ETH and 49 priced tokens, over 129,531 addresses).
- Activity: 554,554 transactions called it in the 90 days before that block; last on 2026-11-18.
- 439 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
