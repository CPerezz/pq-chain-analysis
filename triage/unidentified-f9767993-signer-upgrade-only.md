---
id: unidentified-f9767993-signer-upgrade-only
title: "651 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-f9767993
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5651289f4b55a4e1c813839b09c857f2efc1e2b2"
  name: "unverified code (study family be19aac4), 1 of 651 addresses running it"
  upgradeable: "yes"
families:
- code: "0x5651289f4b55a4e1c813839b09c857f2efc1e2b2"
  name: "unverified code (study family be19aac4)"
  instances: 651
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 26527
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families be19aac4"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 651 addresses, $27k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x5651289f4b55a4e1c813839b09c857f2efc1e2b2` (unverified, family `be19aac4`, 651 addresses, $27k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Decided by: rule.
