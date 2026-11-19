---
id: unidentified-2bcfbfdb-signer-upgrade-only
title: "LaunchCoreV4 (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-2bcfbfdb
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x40102afb79353c8455df2463a967696883aa5d1b"
  name: "LaunchCoreV4 (study family 5c8d0b27), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x40102afb79353c8455df2463a967696883aa5d1b"
  name: "LaunchCoreV4 (study family 5c8d0b27)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5c8d0b27"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x40102afb79353c8455df2463a967696883aa5d1b` (LaunchCoreV4, family `5c8d0b27`, 2 addresses, $0): OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / the recovered address must be the key passed in by the caller of this helper (a price key) / the account named must sign: ECDSA, else its… Decided by: read (function text). Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
