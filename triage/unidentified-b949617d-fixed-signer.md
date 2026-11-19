---
id: unidentified-b949617d-fixed-signer
title: "AgentShareEth: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b949617d
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb3617e96ab2005af2bc33cc4d1665ba5a2a9a956"
  name: "AgentShareEth (study family 2cc7b350)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2cc7b350"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb3617e96ab2005af2bc33cc4d1665ba5a2a9a956` (AgentShareEth, family `2cc7b350`, 1 address, $0): AgentShareEth mint: the voucher must be signed by gateSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
