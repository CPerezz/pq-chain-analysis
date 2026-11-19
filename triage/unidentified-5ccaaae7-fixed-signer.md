---
id: unidentified-5ccaaae7-fixed-signer
title: "Custodian: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-5ccaaae7
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xce00901a0638d758d6f89d59dfa32120d2259b0c"
  name: "Custodian (study family f7ca127d)"
  upgradeable: "no"
  value_usd: 62618
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f7ca127d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $63k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xce00901a0638d758d6f89d59dfa32120d2259b0c` (Custodian, family `f7ca127d`, 1 address, $63k): Gluon Custodian: every withdrawal and exit needs the operator's ECDSA signature on the entry (verifySignedBy(entry.hash, signature, operator)) and the caller must be the entry's account; the operator is set in the… Decided by: read.
