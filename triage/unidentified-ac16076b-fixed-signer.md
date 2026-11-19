---
id: unidentified-ac16076b-fixed-signer
title: "6 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ac16076b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa5a137eabfc977bc77d30750a35353dc7ec7ca46"
  name: "unverified code (study family b8537f44), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0xa5a137eabfc977bc77d30750a35353dc7ec7ca46"
  name: "unverified code (study family b8537f44)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b8537f44"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa5a137eabfc977bc77d30750a35353dc7ec7ca46` (unverified, family `b8537f44`, 6 addresses, $0): a verifying paymaster (v0.6): its signer looks immutable; the owner withdraws the deposit directly. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
