---
id: unidentified-6ca8c4d5-signer-upgrade-only
title: "MergedAdapterWithRoundsPufethethV1 (6 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-6ca8c4d5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3b9c09bde7776c32c518e2e787412a9bbaa7685f"
  name: "MergedAdapterWithRoundsPufethethV1 (study family 124046a3), 1 of 6 addresses running it"
  upgradeable: "yes"
families:
- code: "0x3b9c09bde7776c32c518e2e787412a9bbaa7685f"
  name: "MergedAdapterWithRoundsPufethethV1 (study family 124046a3)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 124046a3"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x3b9c09bde7776c32c518e2e787412a9bbaa7685f` (MergedAdapterWithRoundsPufethethV1, family `124046a3`, 6 addresses, $0): RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
