---
id: unidentified-a18c8784-fixed-signer
title: "161 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a18c8784
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb59de7bb764efb174269d6ba877bd37ab0baf81b"
  name: "unverified code (study family ebf836d3), 1 of 161 addresses running it"
  upgradeable: "no"
families:
- code: "0xb59de7bb764efb174269d6ba877bd37ab0baf81b"
  name: "unverified code (study family ebf836d3)"
  instances: 161
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ebf836d3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 161 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb59de7bb764efb174269d6ba877bd37ab0baf81b` (unverified, family `ebf836d3`, 161 addresses, $0): 161 ERC-1271 contracts answering for an operator that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
