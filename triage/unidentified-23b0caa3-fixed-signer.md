---
id: unidentified-23b0caa3-fixed-signer
title: "FacetEtherBridgeV6: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-23b0caa3
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x68c56f4d88846a4cdce966d92d92a0636baf40fe"
  name: "FacetEtherBridgeV6 (study family 64bfbfdb)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 64bfbfdb"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x68c56f4d88846a4cdce966d92d92a0636baf40fe` (FacetEtherBridgeV6, family `64bfbfdb`, 1 address, $0): Solady ERC20 permit (variant, assembly): the recovered address must be the owner named / Facet bridge withdraw: signed by a signer address written into the code; the caller must be the transaction's origin. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
