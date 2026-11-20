---
id: eip7702proxy-96732e45-7702-own-key-only
title: "EIP7702Proxy: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x96732e45457c78e34d02fcea65c99420dbc45219"
  family: "bd7d59480bdfece2d9b2b87d7ebca996"
  copies: 97191
  name: "EIP7702Proxy"
  upgradeable: "yes"
  rating: LOW
  value_usd: 54639550
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 448437
  last_active: 2026-11-18
  recoveries_14d: 8709
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
  note: "The implementation behind it (e.g. Coinbase Smart Wallet) may accept other owners and passkeys; only the proxy's own fallback is own-key. Upgradeable by the account's own signature"
---

## Summary

EIP7702Proxy (97,191 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs / isValidSignature: the implementation is asked first; otherwise the recovered address must be the account…. Read from source. Executed: a real transaction is unaffected by code at the signer.
- Coinbase EIP7702Proxy isValidSignature: asks the implementation first, then falls back to tryRecover == address(this) (lines 123-134); setImplementation needs ECDSA.recover == address(this) (line 100)/source (dossier bd7d59480bdfece2d9b2b87d7ebca996)
- Study note: the recovered address must be the address the code runs at: the account's own key signs / isValidSignature: the implementation is asked first; otherwise the recovered address must be the account…. Read from source. Execu
- Activity (measured): txs_90d 448,437, last_active 2026-11-18, value_usd 54639550

## Impact and exposure

- Value held at block 26,438,999: $54.6M (ETH and 49 priced tokens, over 97,191 addresses).
- Activity: 448,437 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8,709 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
