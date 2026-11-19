---
id: unidentified-a8a53b42-fixed-signer
title: "SNPBridgeReleaseVault: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a8a53b42
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x02e60f97feb25f9141e4e0a574b5b60d94b5eb27"
  name: "SNPBridgeReleaseVault (study family 8df9f133)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8df9f133"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x02e60f97feb25f9141e4e0a574b5b60d94b5eb27` (SNPBridgeReleaseVault, family `8df9f133`, 1 address, $0): SNP bridge seals: each signer must be one of the validators fixed in the code, without duplicates / SNP bridge fee consent: the depositor may sign a fee cap; claims without a consent exist (by name). Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
