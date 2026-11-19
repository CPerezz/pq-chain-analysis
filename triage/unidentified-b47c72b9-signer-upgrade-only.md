---
id: unidentified-b47c72b9-signer-upgrade-only
title: "EntryLogic (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-b47c72b9
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d"
  name: "EntryLogic (study family 4ccd8b34), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d"
  name: "EntryLogic (study family 4ccd8b34)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4ccd8b34"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d` (EntryLogic, family `4ccd8b34`, 2 addresses, $0): bridge fee quote: the signer must be feeSigner. Decided by: read (function text).
