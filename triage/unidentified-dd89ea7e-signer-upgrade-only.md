---
id: unidentified-dd89ea7e-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-dd89ea7e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd7259ac28bfbc26555a5cbafac117af20fe0233b"
  name: "unverified code (study family 817e7fe4), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xd7259ac28bfbc26555a5cbafac117af20fe0233b"
  name: "unverified code (study family 817e7fe4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 817e7fe4"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xd7259ac28bfbc26555a5cbafac117af20fe0233b` (unverified, family `817e7fe4`, 2 addresses, $0): one stored verifier behind a proxy; no setter name seen. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
