---
id: unidentified-12ee2de7-signer-upgrade-only
title: "2 contract families (7 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-12ee2de7
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc351e44b5300d099b1e82c2b659bcf7a64afe97b"
  name: "unverified code (study family 2f524076), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0xf202fa23a358527b7d317d8c99fc54559b1c7a81"
  name: "unverified code (study family 48c896a2)"
  upgradeable: "yes"
families:
- code: "0xc351e44b5300d099b1e82c2b659bcf7a64afe97b"
  name: "unverified code (study family 2f524076)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2f524076, 48c896a2"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 2 code families, 7 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xc351e44b5300d099b1e82c2b659bcf7a64afe97b` (unverified, family `2f524076`, 6 addresses, $0): an upgradeable CoW order-signing contract (8 recoveries); whose signatures count is not established beyond the owner and the upgrade. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xf202fa23a358527b7d317d8c99fc54559b1c7a81` (unverified, family `48c896a2`, 1 address, $0): the same design as 2f524076. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
