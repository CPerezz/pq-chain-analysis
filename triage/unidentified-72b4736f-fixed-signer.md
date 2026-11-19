---
id: unidentified-72b4736f-fixed-signer
title: "9 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-72b4736f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd4b5568c52e1e5c809195a87486109d189c2fbd9"
  name: "unverified code (study family d9953274), 1 of 9 addresses running it"
  upgradeable: "no"
families:
- code: "0xd4b5568c52e1e5c809195a87486109d189c2fbd9"
  name: "unverified code (study family d9953274)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d9953274"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 9 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd4b5568c52e1e5c809195a87486109d189c2fbd9` (unverified, family `d9953274`, 9 addresses, $0): swap executor: a signer that is a constant in the code; the operator's own key. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
