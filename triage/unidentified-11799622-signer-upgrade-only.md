---
id: unidentified-11799622-signer-upgrade-only
title: "LeftoverExchanger (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-11799622
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb01f8f528702d411d24c9bb8cc0e2fff779ec013"
  name: "LeftoverExchanger (study family 10aaa29e), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb01f8f528702d411d24c9bb8cc0e2fff779ec013"
  name: "LeftoverExchanger (study family 10aaa29e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 10aaa29e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $4k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb01f8f528702d411d24c9bb8cc0e2fff779ec013` (LeftoverExchanger, family `10aaa29e`, 2 addresses, $4k): 1inch LeftoverExchanger ERC-1271: the signer must be _OWNER, fixed in the code. Decided by: read (function text).
