---
id: unidentified-d8293ad2-fixed-signer
title: "Unverified contract 0xbb928a…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-d8293ad2
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbb928a44c681f57fb5fe7c13e6d1e014d92a1251"
  name: "unverified code (study family b076e64a)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b076e64a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xbb928a44c681f57fb5fe7c13e6d1e014d92a1251` (unverified, family `b076e64a`, 1 address, $0): paymaster checking a relayer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
