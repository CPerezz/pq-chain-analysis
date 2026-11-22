---
id: ethstonks-de3f362a-signer-upgrade-only
title: "EthStonks: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde3f362a8f2e89c72eece8dc7b1d7a0cf8cbdb0b"
  family: "7920edf8f46b2404637a577bdcacfee4"
  name: "EthStonks"
  label: "deployed by Mr F"
  upgradeable: "no"
  rating: LOW
  value_usd: 2857
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 310
  last_active: 2026-09-24
fix:
  layer: none
  who_acts: "admin"
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
  note: "The same act stays open through another path"
---

## Summary

EthStonks claimBroker accepts an admin signature. The same grant stays open through grantBroker(addr), a direct onlyAdmin call.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the admin. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- claimBroker requires recovered == admin; grantBroker is onlyAdmin and sets the same flag (dossier source)
- admin = slot 0 = 0x38857ed3…, which today is an EIP-7702 delegated EOA (0xef0100…, latest block ~26452920)

## Impact and exposure

- Value held at block 26,438,999: $2,857 (ETH and 49 priced tokens).
- Activity: 310 transactions called it in the 90 days before that block; last on 2026-09-24.

## Remediation

The admin grants brokers by direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
