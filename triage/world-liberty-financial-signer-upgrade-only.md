---
id: world-liberty-financial-signer-upgrade-only
title: "WLFIStakingAccountingLib (3 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: world-liberty-financial
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x196fee96efeaad585483a6d950e70286b6851923"
  name: "WLFIStakingAccountingLib (study family e8962d18), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0x196fee96efeaad585483a6d950e70286b6851923"
  name: "WLFIStakingAccountingLib (study family e8962d18)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 12214886
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e8962d18"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $12.2M held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x196fee96efeaad585483a6d950e70286b6851923` (WLFIStakingAccountingLib, family `e8962d18`, 3 addresses, $12.2M): the recovered address must be the reward signer passed in from storage. Decided by: read (function text).
