---
id: unidentified-2cc99e1d-signer-upgrade-only
title: "NefariousNarwhals (48 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-2cc99e1d
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa578e04d4c0937a834ed790c0a23b8d9f7b2cc25"
  name: "NefariousNarwhals (study families 69b88ee9, 5bbc9e00), 1 of 48 addresses running it"
  upgradeable: "yes"
families:
- code: "0xa578e04d4c0937a834ed790c0a23b8d9f7b2cc25"
  name: "NefariousNarwhals (study families 69b88ee9, 5bbc9e00)"
  instances: 48
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 69b88ee9"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 48 addresses, $4k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xa578e04d4c0937a834ed790c0a23b8d9f7b2cc25` (NefariousNarwhals, family `69b88ee9`, 48 addresses, $4k): NFT proxy upgradeTo: the caller and the signer are two addresses written in the code. Decided by: read (function text).
