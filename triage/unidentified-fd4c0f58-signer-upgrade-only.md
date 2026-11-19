---
id: unidentified-fd4c0f58-signer-upgrade-only
title: "GeneralTransferManager (127 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-fd4c0f58
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7299403aa008d5bb3e539a58620d9e1b94e5373"
  name: "GeneralTransferManager (study family 5d53e00e), 1 of 127 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb7299403aa008d5bb3e539a58620d9e1b94e5373"
  name: "GeneralTransferManager (study family 5d53e00e)"
  instances: 127
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5d53e00e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 127 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb7299403aa008d5bb3e539a58620d9e1b94e5373` (GeneralTransferManager, family `5d53e00e`, 127 addresses, $0): Polymath transfer manager v3: the signer must hold the operator permission. Decided by: read (function text).
