---
id: unidentified-52ab9558-fixed-signer
title: "Unverified contract 0xdf2d4b…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-52ab9558
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xdf2d4bffec010debd302674c9fb9cda99bb5e852"
  name: "unverified code (study family 5b3b5ce2)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5b3b5ce2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xdf2d4bffec010debd302674c9fb9cda99bb5e852` (unverified, family `5b3b5ce2`, 1 address, $0): a signed zone with three selectors: signers in a mapping, no function to change them. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
