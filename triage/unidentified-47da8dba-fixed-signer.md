---
id: unidentified-47da8dba-fixed-signer
title: "Unverified contract 0x8b2b4f…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-47da8dba
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8b2b4fa53bf1e6b041ead123a994b08df5a5246a"
  name: "unverified code (study family dca44f71)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families dca44f71"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x8b2b4fa53bf1e6b041ead123a994b08df5a5246a` (unverified, family `dca44f71`, 1 address, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
