---
id: unidentified-a710cee5-signer-upgrade-only
title: "2 contract families (3 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-a710cee5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1fe638b2a72235c6a0538f7bffa42951ead9796a"
  name: "unverified code (study family e071da31), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x47268f485a1f42e58d41b41f3ba696e18eced6ed"
  name: "unverified code (study family bbecdfd9)"
  upgradeable: "yes"
families:
- code: "0x1fe638b2a72235c6a0538f7bffa42951ead9796a"
  name: "unverified code (study family e071da31)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e071da31, bbecdfd9"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 2 code families, 3 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x1fe638b2a72235c6a0538f7bffa42951ead9796a` (unverified, family `e071da31`, 2 addresses, $0): stored keys behind an upgradeable implementation; no setter name seen. Decided by: bytecode and names (no source). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
- `0x47268f485a1f42e58d41b41f3ba696e18eced6ed` (unverified, family `bbecdfd9`, 1 address, $0): stored keys behind an upgradeable implementation. Decided by: bytecode and names (no source). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
