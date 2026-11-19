---
id: unidentified-157875c3-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-157875c3
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0c0988e882ceffff0f8da4a645759265d2ca51a5"
  name: "unverified code (study family 358ff96a), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x0c0988e882ceffff0f8da4a645759265d2ca51a5"
  name: "unverified code (study family 358ff96a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 358ff96a"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $2k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x0c0988e882ceffff0f8da4a645759265d2ca51a5` (unverified, family `358ff96a`, 2 addresses, $2k): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule.
