---
id: unidentified-3a062313-fixed-signer
title: "3 contract families (3 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3a062313
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfe17b2bb237a4f4c28470ade25be917dfb0da56e"
  name: "unverified code (study family f79f8966)"
  upgradeable: "no"
- address: "0xd4200c17a05c9330d350e3c6f333f30158a85b61"
  name: "unverified code (study family e4f23633)"
  upgradeable: "no"
- address: "0xc4ff9e14824c78d5d55889b3177980f18b30d5e2"
  name: "unverified code (study family f6ef04e8)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f79f8966, e4f23633, f6ef04e8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 3 code families, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xfe17b2bb237a4f4c28470ade25be917dfb0da56e` (unverified, family `f79f8966`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xd4200c17a05c9330d350e3c6f333f30158a85b61` (unverified, family `e4f23633`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xc4ff9e14824c78d5d55889b3177980f18b30d5e2` (unverified, family `f6ef04e8`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
