---
id: unidentified-07e09541-fixed-signer
title: "Unverified contract 0x6ddab0…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-07e09541
status: candidate
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6ddab021daedcfba8c4e12911b906a69da0e6795"
  name: "unverified code (study family 37213de0)"
  upgradeable: "no"
  value_usd: 9252340
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 37213de0"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $9.3M held. Rated by hand: decompiled: the owner withdraws and escapes without a signature; the operator's own inventory.

## Evidence

- `0x6ddab021daedcfba8c4e12911b906a69da0e6795` (unverified, family `37213de0`, 1 address, $9.3M): RFQ pool (5,127 ETH): quotes are checked against a signer that is a constant in the code; the pool also has withdraw. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
