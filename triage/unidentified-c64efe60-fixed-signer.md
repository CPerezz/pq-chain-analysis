---
id: unidentified-c64efe60-fixed-signer
title: "WOREPrivateSale: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c64efe60
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe617f1722955706bc487257439d9d61fd3a991a4"
  name: "WOREPrivateSale (study family f77cc2a5)"
  upgradeable: "no"
  value_usd: 28873
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f77cc2a5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $29k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xe617f1722955706bc487257439d9d61fd3a991a4` (WOREPrivateSale, family `f77cc2a5`, 1 address, $29k): WORE private sale: a purchase needs the presale list signature of SIGNER, a private address set in the constructor with no setter; the ETH raised is withdrawn by an admin's direct call. A SIGNER with code ends the… Decided by: read.
