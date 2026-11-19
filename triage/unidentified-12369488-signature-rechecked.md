---
id: unidentified-12369488-signature-rechecked
title: "2 contract families (4,307 addresses): under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-12369488
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xdf708431162ba247ddae362d2c919e0fbafcf9de"
  name: "unverified code (study family e20f92ec), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb589deaa32ea4e4f2595d5e7237ce995c4d2de08"
  name: "BondedECDSAKeep (study family cf7404a9), 1 of 4,305 addresses running it"
  upgradeable: "no"
families:
- code: "0xdf708431162ba247ddae362d2c919e0fbafcf9de"
  name: "unverified code (study family e20f92ec)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 30136
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb589deaa32ea4e4f2595d5e7237ce995c4d2de08"
  name: "BondedECDSAKeep (study family cf7404a9)"
  instances: 4305
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e20f92ec, cf7404a9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 2 code families, 4,307 addresses, $30k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xdf708431162ba247ddae362d2c919e0fbafcf9de` (unverified, family `e20f92ec`, 2 addresses, $30k): Keep v1 random beacon: a DKG result counts only with signatures of the group's members, each recovered (OpenZeppelin recover) and compared with the member at its index, checked when the result is submitted. A member… Decided by: read.
- `0xb589deaa32ea4e4f2595d5e7237ce995c4d2de08` (BondedECDSAKeep, family `cf7404a9`, 4,305 addresses, $0): Keep ManagedGrant.recoverStake: no signature (matched on a word) / Keep TokenGrant.recoverStake: no signature / Keep TokenGrantStake.recoverStake: no signature / Keep BondedECDSAKeep submitSignature: the signature must… Decided by: read (function text).
