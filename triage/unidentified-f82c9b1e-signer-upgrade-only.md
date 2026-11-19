---
id: unidentified-f82c9b1e-signer-upgrade-only
title: "Vault (115 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-f82c9b1e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa521ba3bfa3e629ef1d983e230e6dae47e511801"
  name: "Vault (study family 5cf12370), 1 of 115 addresses running it"
  upgradeable: "yes"
families:
- code: "0xa521ba3bfa3e629ef1d983e230e6dae47e511801"
  name: "Vault (study family 5cf12370)"
  instances: 115
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5cf12370"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 115 addresses, $2k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xa521ba3bfa3e629ef1d983e230e6dae47e511801` (Vault, family `5cf12370`, 115 addresses, $2k): SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Decided by: read (same function texts).
