---
id: unidentified-a326184c-signer-upgrade-only
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-a326184c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x95c3f94d27f25e338051a7c05b255fb1f9e46930"
  name: "unverified code (study family 24e73ad6), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0x95c3f94d27f25e338051a7c05b255fb1f9e46930"
  name: "unverified code (study family 24e73ad6)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 24e73ad6"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x95c3f94d27f25e338051a7c05b255fb1f9e46930` (unverified, family `24e73ad6`, 3 addresses, $0): quote signer that is a constant in the code, behind a proxy. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
