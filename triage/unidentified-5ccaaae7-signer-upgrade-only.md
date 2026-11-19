---
id: unidentified-5ccaaae7-signer-upgrade-only
title: "SpotLogic: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-5ccaaae7
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2d627ff93d32f5febb04d68409a889895b4aef2d"
  name: "SpotLogic (study family 3ac61356)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3ac61356"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2d627ff93d32f5febb04d68409a889895b4aef2d` (SpotLogic, family `3ac61356`, 1 address, $0): Gluon SpotLogic: withdrawals and exits need an entry signed by `operator`, set in the constructor with no setter; the app is replaced by a successor version through Gluon's upgrade proposals, which is how the operator… Decided by: read.
