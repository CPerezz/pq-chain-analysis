---
id: unidentified-fb38b903-fixed-signer
title: "DogZone721: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-fb38b903
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4178e73f2f942b814ca454a77706429f53dfae10"
  name: "DogZone721 (study family d4de1d4c)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d4de1d4c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4178e73f2f942b814ca454a77706429f53dfae10` (DogZone721, family `d4de1d4c`, 1 address, $0): DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Decided by: read.
