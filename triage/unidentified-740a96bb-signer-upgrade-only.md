---
id: unidentified-740a96bb-signer-upgrade-only
title: "14 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-740a96bb
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x61d895084594df523ca7df5b4d14642c0b17dcff"
  name: "unverified code (study family 69fedfd0), 1 of 14 addresses running it"
  upgradeable: "yes"
families:
- code: "0x61d895084594df523ca7df5b4d14642c0b17dcff"
  name: "unverified code (study family 69fedfd0)"
  instances: 14
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 69fedfd0"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 14 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x61d895084594df523ca7df5b4d14642c0b17dcff` (unverified, family `69fedfd0`, 14 addresses, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
