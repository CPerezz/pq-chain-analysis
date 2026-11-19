---
id: unidentified-ff03410d-signer-upgrade-only
title: "Registry: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-ff03410d
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0da2679000ea5380d1361cc3cca7d4e8c881f766"
  name: "Registry (study family a276c394)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a276c394"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x0da2679000ea5380d1361cc3cca7d4e8c881f766` (Registry, family `a276c394`, 1 address, $0): the recovered address must be the attester. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
