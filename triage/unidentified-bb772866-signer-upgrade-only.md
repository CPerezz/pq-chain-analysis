---
id: unidentified-bb772866-signer-upgrade-only
title: "151 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-bb772866
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9621b5d7aa295f7cc686f1c07a547c916ce200f3"
  name: "unverified code (study family 6dc5b682), 1 of 151 addresses running it"
  upgradeable: "yes"
families:
- code: "0x9621b5d7aa295f7cc686f1c07a547c916ce200f3"
  name: "unverified code (study family 6dc5b682)"
  instances: 151
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6dc5b682"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 151 addresses, $902 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x9621b5d7aa295f7cc686f1c07a547c916ce200f3` (unverified, family `6dc5b682`, 151 addresses, $902): 151 proxies whose upgrade is signed by a signer that is a constant in the code. Decided by: bytecode and names (no source).
