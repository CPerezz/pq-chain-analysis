---
id: unidentified-1fcd234d-fixed-signer
title: "MergedAdapterWithoutRoundsPufStakingV1 (6 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-1fcd234d
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x26dc62470d4fa7f9cbcd597f9862345a2b3515aa"
  name: "MergedAdapterWithoutRoundsPufStakingV1 (study family 98da8b6b), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0x26dc62470d4fa7f9cbcd597f9862345a2b3515aa"
  name: "MergedAdapterWithoutRoundsPufStakingV1 (study family 98da8b6b)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98da8b6b"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x26dc62470d4fa7f9cbcd597f9862345a2b3515aa` (MergedAdapterWithoutRoundsPufStakingV1, family `98da8b6b`, 6 addresses, $0): RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
