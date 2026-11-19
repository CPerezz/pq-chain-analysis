---
id: unidentified-0fd13e11-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-0fd13e11
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2beadaf92406de00bb0120141a23191db6f20b4a"
  name: "unverified code (study family 705b7868), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x2beadaf92406de00bb0120141a23191db6f20b4a"
  name: "unverified code (study family 705b7868)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 705b7868"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x2beadaf92406de00bb0120141a23191db6f20b4a` (unverified, family `705b7868`, 2 addresses, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
