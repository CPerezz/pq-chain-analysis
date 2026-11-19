---
id: unidentified-91e60e06-signer-upgrade-only
title: "SimpleAccount (3,776 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-91e60e06
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x17162489643970027c6c8a91015ef752b30eb7f3"
  name: "SimpleAccount (study family 64d06ec8), 1 of 3,776 addresses running it, 1 by 7702 delegation"
  upgradeable: "yes"
families:
- code: "0x17162489643970027c6c8a91015ef752b30eb7f3"
  name: "SimpleAccount (study family 64d06ec8)"
  instances: 3776
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "yes"
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 64d06ec8"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 3,776 addresses, $9k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x17162489643970027c6c8a91015ef752b30eb7f3` (SimpleAccount, family `64d06ec8`, 3,776 addresses, $9k): SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Decided by: read (same function texts). Executed: a real transaction reverts when its signer has code.
