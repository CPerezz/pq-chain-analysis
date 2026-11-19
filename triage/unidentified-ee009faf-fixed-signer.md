---
id: unidentified-ee009faf-fixed-signer
title: "RedstoneCoreOracle (127 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ee009faf
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb77d06d97dc1e641cd514d8df89befc07350b445"
  name: "RedstoneCoreOracle (study family 367d52f9), 1 of 127 addresses running it"
  upgradeable: "no"
families:
- code: "0xb77d06d97dc1e641cd514d8df89befc07350b445"
  name: "RedstoneCoreOracle (study family 367d52f9)"
  instances: 127
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 367d52f9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 127 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb77d06d97dc1e641cd514d8df89befc07350b445` (RedstoneCoreOracle, family `367d52f9`, 127 addresses, $0): RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Decided by: read (function text).
