---
id: unidentified-4a57d20f-fixed-signer
title: "MergedAdapterWithRoundsRsethethV1 (7 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-4a57d20f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd83ba0fba552862d679d77d074e01cdf259f7a4f"
  name: "MergedAdapterWithRoundsRsethethV1 (study family 4a78aa9e), 1 of 7 addresses running it"
  upgradeable: "no"
families:
- code: "0xd83ba0fba552862d679d77d074e01cdf259f7a4f"
  name: "MergedAdapterWithRoundsRsethethV1 (study family 4a78aa9e)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4a78aa9e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 7 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd83ba0fba552862d679d77d074e01cdf259f7a4f` (MergedAdapterWithRoundsRsethethV1, family `4a78aa9e`, 7 addresses, $0): RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
