---
id: unidentified-4cc8b005-fixed-signer
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4cc8b005
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7f0740d7ff721758303869c542379e26e5050df8"
  name: "unverified code (study family f767b566), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x7f0740d7ff721758303869c542379e26e5050df8"
  name: "unverified code (study family f767b566)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f767b566"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x7f0740d7ff721758303869c542379e26e5050df8` (unverified, family `f767b566`, 3 addresses, $2k): BitGo pattern (isSigner, signers). Decided by: bytecode and names (no source).
