---
id: unidentified-b8a81383-signer-upgrade-only
title: "GpPurchaserV3 (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-b8a81383
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb03aaf70191c22d1410d72c3ca9a86ae9eb9942c"
  name: "GpPurchaserV3 (study family de424beb), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb03aaf70191c22d1410d72c3ca9a86ae9eb9942c"
  name: "GpPurchaserV3 (study family de424beb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families de424beb"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $9k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb03aaf70191c22d1410d72c3ca9a86ae9eb9942c` (GpPurchaserV3, family `de424beb`, 2 addresses, $9k): GpPurchaser admin signature: the signer must be an owner / GpPurchaser _recoverSigner: returns the signer. Decided by: read (function text).
