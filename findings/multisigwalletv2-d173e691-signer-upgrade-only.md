---
id: multisigwalletv2-d173e691-signer-upgrade-only
title: "MultiSigWalletV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd173e69192b9ff22069aa913ef6e6e94b19f0778"
  family: "978e51eba7d5dcb5a60428d7d2da20f9"
  copies: 8
  name: "MultiSigWalletV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 21
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the wallet's owners"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A setter replaces the key"
---

## Summary

MultiSigWalletV2 proxy: the owners are replaceable through ownerSetup(...), which is onlySelf, i.e. a signed execTransaction, so the key is not fixed.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MultiSigWalletV2 checkSignature: validator and operator thresholds of stored owners / MultiSigWalletV2 checkSingleSignature: a stored owner must sign. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x06b7c1460154a4d0cf79954298d6ba8d5b2d38f7: no admin, no upgrade function in the implementation.
- OwnerManager.ownerSetup is public onlySelf (dossier source)
- The proxy delegates to 0x06b7c146… (survey)

## Impact and exposure

- Value held at block 26,438,999: $21 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the signers by a signed self-call before migrating

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
