---
id: unidentified-63d7bc5e-signer-upgrade-only
title: "1,091 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-63d7bc5e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x92080d73918fd8087afac8fb3ce836db44831dff"
  name: "unverified code (study family 55094f8d), 1 of 1,091 addresses running it"
  upgradeable: "yes"
families:
- code: "0x92080d73918fd8087afac8fb3ce836db44831dff"
  name: "unverified code (study family 55094f8d)"
  instances: 1091
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 85717
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 55094f8d"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1,091 addresses, $86k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x92080d73918fd8087afac8fb3ce836db44831dff` (unverified, family `55094f8d`, 1,091 addresses, $86k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Decided by: rule.
