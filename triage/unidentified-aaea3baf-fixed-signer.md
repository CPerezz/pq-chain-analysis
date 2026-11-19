---
id: unidentified-aaea3baf-fixed-signer
title: "NEARIntentsFacet: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-aaea3baf
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8f00e690a45e75d7a1a765163829ad33244a1c33"
  name: "NEARIntentsFacet (study family 06110f67)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 06110f67"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x8f00e690a45e75d7a1a765163829ad33244a1c33` (NEARIntentsFacet, family `06110f67`, 1 address, $0): LI.FI NEARIntents facet: the signer must be BACKEND_SIGNER, fixed in the facet's code; the diamond can swap the facet. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
