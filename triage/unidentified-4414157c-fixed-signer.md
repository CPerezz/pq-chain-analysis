---
id: unidentified-4414157c-fixed-signer
title: "VVVVCTokenDistributor: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4414157c
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfae502ab8fa48189e6037b9b20b810a54d8cec76"
  name: "VVVVCTokenDistributor (study family 29d17b29)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 29d17b29"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xfae502ab8fa48189e6037b9b20b810a54d8cec76` (VVVVCTokenDistributor, family `29d17b29`, 1 address, $0): VVV token distributor: claims must be signed by `signer`, set in the constructor, with no setter. Decided by: read.
