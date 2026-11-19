---
id: unidentified-0a33a70a-fixed-signer
title: "ERC20Impl (5 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-0a33a70a
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc614f19d0c090b14c1397cda193590e119940c62"
  name: "ERC20Impl (study family 59db0469), 1 of 5 addresses running it"
  upgradeable: "no"
families:
- code: "0xc614f19d0c090b14c1397cda193590e119940c62"
  name: "ERC20Impl (study family 59db0469)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 59db0469"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc614f19d0c090b14c1397cda193590e119940c62` (ERC20Impl, family `59db0469`, 5 addresses, $0): Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the addresses that signed the sweep message,… Decided by: read (function text).
