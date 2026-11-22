---
id: pulsesmartwallet-b7510f3f-signer-upgrade-only
title: "PulseSmartWallet: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7510f3fb42970adfeb2466bb678c9d804cae928"
  family: "3add81478116adfd9e5d9eac1074c16c"
  name: "PulseSmartWallet"
  upgradeable: "yes"
  rating: LOW
  value_usd: 20
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xf34cbdfa5c05efa341c916a66114f195533e5e49 with upgradeToAndCall(address,bytes), called through its own checks)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`PulseSmartWallet` at `0xb7510f3fb42970adfeb2466bb678c9d804cae928`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Coinbase Smart Wallet: the owner at the given index is an address checked with Solady SignatureCheckerLib (ecrecover, then the owner's ERC-1271), or a passkey. Read (function text).
- Update path, read at block 26,438,999: proxy to 0xf34cbdfa5c05efa341c916a66114f195533e5e49 with upgradeToAndCall(address,bytes), called through its own checks.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $20 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
