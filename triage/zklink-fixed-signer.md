---
id: zklink-fixed-signer
title: "ZklinkFastPool: under EIP-8151 the signed functions stop once the fixed signer has code"
project: zklink
status: candidate
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbdc4dd4d467e55fa5276925b2f136e75df3f86f1"
  name: "ZklinkFastPool (study family fc2a6174)"
  upgradeable: "no"
  value_usd: 1423256
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fc2a6174"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $1.4M held. Rated by hand: read: 2 of 3 fixed signers move the operator's own liquidity.

## Evidence

- `0xbdc4dd4d467e55fa5276925b2f136e75df3f86f1` (ZklinkFastPool, family `fc2a6174`, 1 address, $1.4M): zkLink fast pool withdrawETH: every signature must come from the signer it names, an allowed signer; two distinct ones are needed; no function changes the signers / zkLink fast pool withdrawErc20: as withdrawETH /… Decided by: read (function text).
