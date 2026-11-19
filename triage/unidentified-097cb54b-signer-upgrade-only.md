---
id: unidentified-097cb54b-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-097cb54b
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2eff34eb555d45e7a855513ee6047151be4db150"
  name: "unverified code (study family 5cae3d8d), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x2eff34eb555d45e7a855513ee6047151be4db150"
  name: "unverified code (study family 5cae3d8d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5cae3d8d"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2eff34eb555d45e7a855513ee6047151be4db150` (unverified, family `5cae3d8d`, 2 addresses, $0): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
