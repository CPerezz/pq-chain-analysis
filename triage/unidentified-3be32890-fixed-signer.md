---
id: unidentified-3be32890-fixed-signer
title: "UnitFacet: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3be32890
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x989a7efabb9be76ac3424b940862d9cf55334873"
  name: "UnitFacet (study family 0076321e)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0076321e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x989a7efabb9be76ac3424b940862d9cf55334873` (UnitFacet, family `0076321e`, 1 address, $0): LI.FI Unit facet: signed by BACKEND_SIGNER, fixed in the facet's code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
