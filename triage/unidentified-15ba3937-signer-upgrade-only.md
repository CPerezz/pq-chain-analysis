---
id: unidentified-15ba3937-signer-upgrade-only
title: "SimpleAccount (15 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-15ba3937
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc30f1d138a6d51b1b23e5ef086a2f18e12156730"
  name: "SimpleAccount (study family a69eaf4d), 1 of 15 addresses running it"
  upgradeable: "yes"
families:
- code: "0xc30f1d138a6d51b1b23e5ef086a2f18e12156730"
  name: "SimpleAccount (study family a69eaf4d)"
  instances: 15
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a69eaf4d"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 15 addresses, $180 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xc30f1d138a6d51b1b23e5ef086a2f18e12156730` (SimpleAccount, family `a69eaf4d`, 15 addresses, $180): SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Decided by: read (same function texts). Executed: a real transaction reverts when its signer has code.
