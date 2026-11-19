---
id: unidentified-9a8f92a8-fixed-signer
title: "AuthorityPlanner: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-9a8f92a8
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x326261b4d820719fe0badbe8faecc090928977fb"
  name: "AuthorityPlanner (study family bb8b5f97)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bb8b5f97"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x326261b4d820719fe0badbe8faecc090928977fb` (AuthorityPlanner, family `bb8b5f97`, 1 address, $0): plans must be signed by the planner's authority (SignatureChecker, read); no function replaces it. Decided by: read. Executed: a real transaction reverts when its signer has code.
