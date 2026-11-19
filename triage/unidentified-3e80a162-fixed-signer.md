---
id: unidentified-3e80a162-fixed-signer
title: "2 contract families (3 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3e80a162
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0017377a40449e5adfda9a98bd4dd0909ba3a6dc"
  name: "BullBearSettlement (study family 4a0a4fd7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x52e172c80cea31816ed0e3431401b60f70842333"
  name: "unverified code (study family 0744755a)"
  upgradeable: "no"
families:
- code: "0x0017377a40449e5adfda9a98bd4dd0909ba3a6dc"
  name: "BullBearSettlement (study family 4a0a4fd7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4a0a4fd7, 0744755a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0017377a40449e5adfda9a98bd4dd0909ba3a6dc` (BullBearSettlement, family `4a0a4fd7`, 2 addresses, $0): BullBear _recoverAttestor: returns the signer or zero / BullBear relayed execution: the route must be signed by BENCHMARK_ATTESTOR, fixed in the code / BullBear benchmark: signed by BENCHMARK_ATTESTOR, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0x52e172c80cea31816ed0e3431401b60f70842333` (unverified, family `0744755a`, 1 address, $0): settlement contract: an attestor that is a constant in the code. Decided by: bytecode and names (no source).
