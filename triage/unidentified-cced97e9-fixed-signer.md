---
id: unidentified-cced97e9-fixed-signer
title: "Unverified contract 0xc97c01…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-cced97e9
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc97c01ab261abeee8c633065e560cf46b09ea5a1"
  name: "unverified code (study family 04f45214)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 04f45214"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc97c01ab261abeee8c633065e560cf46b09ea5a1` (unverified, family `04f45214`, 1 address, $0): four selectors: one stored signatory, no setter. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
