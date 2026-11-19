---
id: unidentified-9a8f92a8-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-9a8f92a8
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x98b2a83db1d8fa8800323dfadd6325843eeb204f"
  name: "unverified code (study family 7c55910c), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x98b2a83db1d8fa8800323dfadd6325843eeb204f"
  name: "unverified code (study family 7c55910c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7c55910c"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x98b2a83db1d8fa8800323dfadd6325843eeb204f` (unverified, family `7c55910c`, 2 addresses, $0): deposit addresses: releases need a signature of BEACON.signer() checked with OpenZeppelin SignatureChecker (a signer with code answers through ERC-1271); the signer lives in an upgradeable beacon proxy. Decided by: read. Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
