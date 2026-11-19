---
id: unidentified-12a55aef-fixed-signer
title: "Unverified contract 0xa06e12…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-12a55aef
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa06e12cf1a6bc589d71eb908b7469886c003cf1f"
  name: "unverified code (study family 0d3bb5f5)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0d3bb5f5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $180 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa06e12cf1a6bc589d71eb908b7469886c003cf1f` (unverified, family `0d3bb5f5`, 1 address, $180): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
