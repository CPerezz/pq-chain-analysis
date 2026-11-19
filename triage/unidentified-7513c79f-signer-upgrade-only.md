---
id: unidentified-7513c79f-signer-upgrade-only
title: "SmartAccount (680 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-7513c79f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2da74aad722b57a039d5e2df9497438e20886858"
  name: "SmartAccount (study family c4d40d28), 1 of 680 addresses running it"
  upgradeable: "yes"
families:
- code: "0x2da74aad722b57a039d5e2df9497438e20886858"
  name: "SmartAccount (study family c4d40d28)"
  instances: 680
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7760
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c4d40d28"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 680 addresses, $8k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2da74aad722b57a039d5e2df9497438e20886858` (SmartAccount, family `c4d40d28`, 680 addresses, $8k): validateUserOp: the recovered address must be the owner / validateUserOpWithoutSig: the recovered address must be the owner / isValidSignature: the recovered address must be an owner. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
