---
id: unidentified-3e990e78-signer-upgrade-only
title: "3 contract families (3,087 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-3e990e78
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb58fb98befd7c53fc56414d80607fe2b2443f26a"
  name: "unverified code (study family 5b1bfd64), 1 of 2,703 addresses running it"
  upgradeable: "yes"
- address: "0xb749d95386a811b78770190488c1b1428f232c9c"
  name: "unverified code (study family df72af5a), 1 of 223 addresses running it"
  upgradeable: "yes"
- address: "0xb8290fc8d5f7cc3761313798cb1c12803765b9ab"
  name: "unverified code (study family 02e523e9), 1 of 161 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb58fb98befd7c53fc56414d80607fe2b2443f26a"
  name: "unverified code (study family 5b1bfd64)"
  instances: 2703
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 87341
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb749d95386a811b78770190488c1b1428f232c9c"
  name: "unverified code (study family df72af5a)"
  instances: 223
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 14797
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb8290fc8d5f7cc3761313798cb1c12803765b9ab"
  name: "unverified code (study family 02e523e9)"
  instances: 161
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5b1bfd64, df72af5a, 02e523e9"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 3 code families, 3,087 addresses, $102k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb58fb98befd7c53fc56414d80607fe2b2443f26a` (unverified, family `5b1bfd64`, 2,703 addresses, $87k): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Decided by: rule.
- `0xb749d95386a811b78770190488c1b1428f232c9c` (unverified, family `df72af5a`, 223 addresses, $15k): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Decided by: rule.
- `0xb8290fc8d5f7cc3761313798cb1c12803765b9ab` (unverified, family `02e523e9`, 161 addresses, $0): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Decided by: rule.
