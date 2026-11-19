---
id: unidentified-a71d501c-signer-upgrade-only
title: "6 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-a71d501c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbdf5e32c9b525e7dceaada11da50037274125f16"
  name: "unverified code (study families 0f196c7e, 3afcb2ec), 1 of 6 addresses running it"
  upgradeable: "yes"
families:
- code: "0xbdf5e32c9b525e7dceaada11da50037274125f16"
  name: "unverified code (study families 0f196c7e, 3afcb2ec)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0f196c7e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xbdf5e32c9b525e7dceaada11da50037274125f16` (unverified, family `0f196c7e`, 6 addresses, $0): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
