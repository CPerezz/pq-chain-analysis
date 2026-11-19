---
id: unidentified-00000000-fixed-signer
title: "204 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-00000000
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb8075b9c90be4d02267b4d39f713e1d8156e2fd9"
  name: "unverified code (study family abc52467), 1 of 204 addresses running it"
  upgradeable: "no"
families:
- code: "0xb8075b9c90be4d02267b4d39f713e1d8156e2fd9"
  name: "unverified code (study family abc52467)"
  instances: 204
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families abc52467"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 204 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb8075b9c90be4d02267b4d39f713e1d8156e2fd9` (unverified, family `abc52467`, 204 addresses, $0): 204 ERC-1271 clones answering for a signer that is a constant in the code. Decided by: bytecode and names (no source).
