---
id: unidentified-5f5d219c-fixed-signer
title: "TrixmojiMarket: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-5f5d219c
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x21c1a938d06f87a039abfc48d1ccb459f55b1685"
  name: "TrixmojiMarket (study family aac9d7f8)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families aac9d7f8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x21c1a938d06f87a039abfc48d1ccb459f55b1685` (TrixmojiMarket, family `aac9d7f8`, 1 address, $0): TrixmojiMarket approval: signed by `verifier`, fixed in the code. Decided by: read (function text).
