---
id: unidentified-e303e26c-signer-upgrade-only
title: "5 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-e303e26c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x049ae2f4f50ed4391eab3ebc0146a232ab92669e"
  name: "unverified code (study family b1102d9b), 1 of 5 addresses running it"
  upgradeable: "yes"
families:
- code: "0x049ae2f4f50ed4391eab3ebc0146a232ab92669e"
  name: "unverified code (study family b1102d9b)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b1102d9b"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x049ae2f4f50ed4391eab3ebc0146a232ab92669e` (unverified, family `b1102d9b`, 5 addresses, $0): a constant signer behind a replaceable implementation. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
