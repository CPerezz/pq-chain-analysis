---
id: marsmaiers-1e4cc5f2-rotate-signer-before-migrating
title: "MarsMaiers: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1e4cc5f267853aa2e2142ea7f0532a776117cfff"
  family: "d6480790f802188ae9c0a6e6942e7f06"
  name: "MarsMaiers"
  upgradeable: "no"
  rating: LOW
  value_usd: 9384
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-09
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0xb369e3f9…0516 (EOA)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Role setter with a live EOA admin."
---

## Summary

MarsMaiers signedRefund needs a receipt signed by a RECEIPT_SIGNER_ROLE holder (ecrecover). A signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- MarsMaiers.sol:235 hasRole(RECEIPT_SIGNER_ROLE, recover(sig)); OZ AccessControl lets DEFAULT_ADMIN grant/revoke
- RoleGranted logs: RECEIPT_SIGNER role to 0xc93bd864…; DEFAULT_ADMIN to 0xb369e3f9…
- hasRole(0x00, 0xb369e3f94f11825dae8ffbddb115b8b5eba20516) = true at block; no code, nonce 20
- Direct path: refund(string[]) (line 243) also exists

## Impact and exposure

- Value held at block 26,438,999: $9,384 (ETH and 49 priced tokens).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

The admin grants RECEIPT_SIGNER_ROLE to a key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
