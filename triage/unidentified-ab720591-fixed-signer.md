---
id: unidentified-ab720591-fixed-signer
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ab720591
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x635c7e2de558a04a33525a9489045a7245281db7"
  name: "unverified code (study family 42cce71f), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x635c7e2de558a04a33525a9489045a7245281db7"
  name: "unverified code (study family 42cce71f)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 42cce71f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $4k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x635c7e2de558a04a33525a9489045a7245281db7` (unverified, family `42cce71f`, 3 addresses, $4k): time-locked vaults (3; 220 recoveries in the window): the signer set looks fixed at creation; the constant admin can extend time locks and sweep ETH. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
