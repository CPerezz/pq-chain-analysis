---
id: 0f8dd218-signed-shortcut-lost
title: "0x0f8dd218: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x0f8dd218ee17eee03d254805f84c7ba613e45e62"
  family: "10059bd17031e81adebc528438e7818b"
  copies: 216
  upgradeable: "yes"
  rating: LOW
  value_usd: 1104030
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 952
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the account owner / registry admin"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Funds and actions open by direct call → LOW. Bytecode only; registry state not read."
---

## Summary

Unverified per-user vault account logic (214 proxies): ERC-1271 isValidSignature recovers an ECDSA signer and asks an external registry; a signer with code makes it return 0xffffffff.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: vault accounts (214 proxies, about 612 ETH with tokens): isValidSignature recovers the signer (with the low-s check) and asks the account's external security scheme whether that signer may act for…. Bytecode and names.
- withdraw 0x69328dec, deposit and gated calls are direct calls checked against the owner in slot 2 / registry (code.listing ~1868)
- isValidSignature has no nested ERC-1271 path; only signatures from that signer are lost
- proxy upgradeable (row)

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 216 addresses).
- Activity: 952 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Funds move by direct call; registry role change or proxy upgrade restores signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
