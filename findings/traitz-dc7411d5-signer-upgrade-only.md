---
id: traitz-dc7411d5-signer-upgrade-only
title: "Traitz: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdc7411d597111c83d7bcbc7c7523e9b2cd22c9eb"
  family: "2a0e98941ae7eafa74253534aada4d40"
  name: "Traitz"
  label: "deployed by Kubz: Deployer"
  upgradeable: "yes"
  admin: "0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c"
  rating: LOW
  value_usd: 14969
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 86
  last_active: 2026-11-17
fix:
  layer: contract-upgrade
  who_acts: "EOA owner 0x759c5f29…"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live owner EOA: LOW."
---

## Summary

Traitz: the recovered address must equal the stored signerAlt, which an owner can change (transferOwnership exists) and the implementation can also be upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the stored signerAlt. Read from source.
- Update path, read at block 26,438,999: proxy to 0xa15af9a878db51eb9b24591890ec4742c36feb88, admin 0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c.
- EIP-1967 admin slot at 26438999 = 0xf025a72e…; owner() = 0x759c5f29edc487aa02186f0099864ebc53191c1
- that owner has no code and nonce 1780 (active EOA)

## Impact and exposure

- Value held at block 26,438,999: $14,969 (ETH and 49 priced tokens).
- Activity: 86 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner upgrades or, per the facts, calls transferOwnership/sets a new signerAlt.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
