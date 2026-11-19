---
id: unidentified-ecf083ed-signer-upgrade-only
title: "AvoMFAManager (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-ecf083ed
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x27a26e2f1cad33cd0389a85ab09a6b4f169bc34f"
  name: "AvoMFAManager (study family 89961c45), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x27a26e2f1cad33cd0389a85ab09a6b4f169bc34f"
  name: "AvoMFAManager (study family 89961c45)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 89961c45"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x27a26e2f1cad33cd0389a85ab09a6b4f169bc34f` (AvoMFAManager, family `89961c45`, 2 addresses, $0): the recovered address must be in the signers mapping of the MFA manager. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
