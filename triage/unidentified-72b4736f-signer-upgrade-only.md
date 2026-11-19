---
id: unidentified-72b4736f-signer-upgrade-only
title: "2 contract families (18 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-72b4736f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9c4dffb4f7e8217a8ac0555d67e125f8769284ba"
  name: "unverified code (study family 77c8091b), 1 of 11 addresses running it"
  upgradeable: "yes"
- address: "0xad3b67bca8935cb510c8d18bd45f0b94f54a968f"
  name: "unverified code (study family f971fb88), 1 of 7 addresses running it"
  upgradeable: "yes"
families:
- code: "0x9c4dffb4f7e8217a8ac0555d67e125f8769284ba"
  name: "unverified code (study family 77c8091b)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 862219
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xad3b67bca8935cb510c8d18bd45f0b94f54a968f"
  name: "unverified code (study family f971fb88)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 77c8091b, f971fb88"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 2 code families, 18 addresses, $863k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x9c4dffb4f7e8217a8ac0555d67e125f8769284ba` (unverified, family `77c8091b`, 11 addresses, $862k): ERC-1271 contract behind a proxy answering for a signer fixed in its code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xad3b67bca8935cb510c8d18bd45f0b94f54a968f` (unverified, family `f971fb88`, 7 addresses, $722): ERC-1271 contract behind a proxy; a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
