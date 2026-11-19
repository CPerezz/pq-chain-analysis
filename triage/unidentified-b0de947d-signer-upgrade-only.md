---
id: unidentified-b0de947d-signer-upgrade-only
title: "HikeshiExodusUpgradeableV1 (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-b0de947d
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xccb9339c825198a905dc078f40fc1f8e7a1720c7"
  name: "HikeshiExodusUpgradeableV1 (study family d05c6fed), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xccb9339c825198a905dc078f40fc1f8e7a1720c7"
  name: "HikeshiExodusUpgradeableV1 (study family d05c6fed)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d05c6fed"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xccb9339c825198a905dc078f40fc1f8e7a1720c7` (HikeshiExodusUpgradeableV1, family `d05c6fed`, 2 addresses, $0): Hikeshi mint: signed by _CLAIM_ADMIN_SIGNER, fixed in the code. Decided by: read (function text).
