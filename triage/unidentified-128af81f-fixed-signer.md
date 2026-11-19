---
id: unidentified-128af81f-fixed-signer
title: "2 contract families (2 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-128af81f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x56d06158bb8d2e42a6c5994a9a12a5c6d642f064"
  name: "eNATBurnWrapped20 (study family 13d7e451)"
  upgradeable: "no"
- address: "0xc3dcdfb76ee8575e923bef9240cf58a9a7a222e0"
  name: "unverified code (study family 9736cd82)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 13d7e451, 9736cd82"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x56d06158bb8d2e42a6c5994a9a12a5c6d642f064` (eNATBurnWrapped20, family `13d7e451`, 1 address, $0): eNAT wrapper deposit: the receipt must be signed by _protocolOperator, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0xc3dcdfb76ee8575e923bef9240cf58a9a7a222e0` (unverified, family `9736cd82`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
