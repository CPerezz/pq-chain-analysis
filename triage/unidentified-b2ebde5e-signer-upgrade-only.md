---
id: unidentified-b2ebde5e-signer-upgrade-only
title: "Bridge (6 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-b2ebde5e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x07701d18dbaa3875aecc46eeee7db7bb115217d2"
  name: "Bridge (study family 559a2e4e), 1 of 6 addresses running it"
  upgradeable: "yes"
families:
- code: "0x07701d18dbaa3875aecc46eeee7db7bb115217d2"
  name: "Bridge (study family 559a2e4e)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 559a2e4e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $4k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x07701d18dbaa3875aecc46eeee7db7bb115217d2` (Bridge, family `559a2e4e`, 6 addresses, $4k): bridge requests must be signed by one stored signer address (read); no setter among its function names; the contract sits behind a proxy. Decided by: read.
