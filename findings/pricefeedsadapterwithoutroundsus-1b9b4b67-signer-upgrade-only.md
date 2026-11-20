---
id: pricefeedsadapterwithoutroundsus-1b9b4b67-signer-upgrade-only
title: "PriceFeedsAdapterWithoutRoundsUsdeSusdeV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1b9b4b6705797968954a597362898ace5f30c1c5"
  family: "1454f72b9a94eb03b9cfc45c74b37605"
  name: "PriceFeedsAdapterWithoutRoundsUsdeSusdeV2"
  upgradeable: "yes"
  admin: "0x8223a6271d1e0bda019ee55d545d7b86eff1f573"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x8d6d49ddd5fe84b6b43d9420d1dac96b88dba9a1, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`PriceFeedsAdapterWithoutRoundsUsdeSusdeV2` at `0x1b9b4b6705797968954a597362898ace5f30c1c5`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x8d6d49ddd5fe84b6b43d9420d1dac96b88dba9a1, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
