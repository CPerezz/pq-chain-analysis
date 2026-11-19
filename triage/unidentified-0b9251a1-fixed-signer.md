---
id: unidentified-0b9251a1-fixed-signer
title: "BlockATMEthPayoutV2: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-0b9251a1
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x40c31c859eb6d1a25ee288372672864fe2d15da6"
  name: "BlockATMEthPayoutV2 (study family 1617d0b3)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1617d0b3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x40c31c859eb6d1a25ee288372672864fe2d15da6` (BlockATMEthPayoutV2, family `1617d0b3`, 1 address, $0): BlockATM payout (newer build): the same design as adfd1a78; the finance list is set in the constructor and has no add or remove; finance addresses also withdraw by direct call. Decided by: read. Executed: a real transaction reverts when its signer has code.
