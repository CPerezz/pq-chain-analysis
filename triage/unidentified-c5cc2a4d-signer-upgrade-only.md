---
id: unidentified-c5cc2a4d-signer-upgrade-only
title: "145 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-c5cc2a4d
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7b36869ca50b6a90655890199b5fe0998028cd6c"
  name: "unverified code (study family b30106ea), 1 of 145 addresses running it"
  upgradeable: "yes"
families:
- code: "0x7b36869ca50b6a90655890199b5fe0998028cd6c"
  name: "unverified code (study family b30106ea)"
  instances: 145
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b30106ea"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 145 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x7b36869ca50b6a90655890199b5fe0998028cd6c` (unverified, family `b30106ea`, 145 addresses, $0): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule.
