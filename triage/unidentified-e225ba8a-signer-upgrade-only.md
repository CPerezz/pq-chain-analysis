---
id: unidentified-e225ba8a-signer-upgrade-only
title: "17 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-e225ba8a
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbc0f5564d86713639da6b3baee754668cce46dcf"
  name: "unverified code (study family 6ea853c9), 1 of 17 addresses running it"
  upgradeable: "yes"
families:
- code: "0xbc0f5564d86713639da6b3baee754668cce46dcf"
  name: "unverified code (study family 6ea853c9)"
  instances: 17
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6ea853c9"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 17 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xbc0f5564d86713639da6b3baee754668cce46dcf` (unverified, family `6ea853c9`, 17 addresses, $0): a constant and a stored key behind an upgradeable proxy. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
