---
id: unidentified-ad714915-signer-upgrade-only
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-ad714915
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd42b0ecf8a9f8ba9db7b0c989d73cf0bd5f83b66"
  name: "unverified code (study family 9f802c7a), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0xd42b0ecf8a9f8ba9db7b0c989d73cf0bd5f83b66"
  name: "unverified code (study family 9f802c7a)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9f802c7a"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xd42b0ecf8a9f8ba9db7b0c989d73cf0bd5f83b66` (unverified, family `9f802c7a`, 3 addresses, $0): ERC-1271 contract behind a proxy; a signer that is a constant in the code. Decided by: bytecode and names (no source).
