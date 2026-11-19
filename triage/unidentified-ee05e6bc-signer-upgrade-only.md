---
id: unidentified-ee05e6bc-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-ee05e6bc
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4f7bda55fe429c2de625b843e77d9bb8d450fad7"
  name: "unverified code (study family 19e36650), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x4f7bda55fe429c2de625b843e77d9bb8d450fad7"
  name: "unverified code (study family 19e36650)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 19e36650"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x4f7bda55fe429c2de625b843e77d9bb8d450fad7` (unverified, family `19e36650`, 2 addresses, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
