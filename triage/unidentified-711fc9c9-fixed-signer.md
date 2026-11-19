---
id: unidentified-711fc9c9-fixed-signer
title: "LayerSwapFacet: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-711fc9c9
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x04e051d8e3627a79785f8e210b1d61a877aa737a"
  name: "LayerSwapFacet (study family f2787599)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f2787599"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x04e051d8e3627a79785f8e210b1d61a877aa737a` (LayerSwapFacet, family `f2787599`, 1 address, $0): LI.FI LayerSwap facet: the signer must be BACKEND_SIGNER, fixed in the facet's code; the diamond can swap the facet. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
