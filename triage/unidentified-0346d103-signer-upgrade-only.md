---
id: unidentified-0346d103-signer-upgrade-only
title: "629 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-0346d103
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xff04af64385973bc3697fa17949a0b2a9b437fc9"
  name: "unverified code (study family f6630b11), 1 of 629 addresses running it"
  upgradeable: "yes"
families:
- code: "0xff04af64385973bc3697fa17949a0b2a9b437fc9"
  name: "unverified code (study family f6630b11)"
  instances: 629
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f6630b11"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 629 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xff04af64385973bc3697fa17949a0b2a9b437fc9` (unverified, family `f6630b11`, 629 addresses, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule.
