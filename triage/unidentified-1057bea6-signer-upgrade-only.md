---
id: unidentified-1057bea6-signer-upgrade-only
title: "55 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-1057bea6
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1cfd0ccd30e85eea9f7844897d5c187f793ad088"
  name: "unverified code (study family efcfa5df), 1 of 55 addresses running it"
  upgradeable: "yes"
families:
- code: "0x1cfd0ccd30e85eea9f7844897d5c187f793ad088"
  name: "unverified code (study family efcfa5df)"
  instances: 55
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families efcfa5df"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 55 addresses, $2k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x1cfd0ccd30e85eea9f7844897d5c187f793ad088` (unverified, family `efcfa5df`, 55 addresses, $2k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule.
