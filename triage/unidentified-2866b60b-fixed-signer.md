---
id: unidentified-2866b60b-fixed-signer
title: "EthBridge (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-2866b60b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd40ffe9bfcc977051029c01f0fd4c93f10ed6413"
  name: "EthBridge (study family 496eb5b1), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xd40ffe9bfcc977051029c01f0fd4c93f10ed6413"
  name: "EthBridge (study family 496eb5b1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9203
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 496eb5b1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $9k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd40ffe9bfcc977051029c01f0fd4c93f10ed6413` (EthBridge, family `496eb5b1`, 2 addresses, $9k): EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Decided by: read (function text).
