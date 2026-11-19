---
id: unidentified-ab8a4d51-fixed-signer
title: "239 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ab8a4d51
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf78a209d40d7295c228f5e3f1e19cd9c9a55e724"
  name: "unverified code (study family 6a7335e9), 1 of 239 addresses running it"
  upgradeable: "no"
families:
- code: "0xf78a209d40d7295c228f5e3f1e19cd9c9a55e724"
  name: "unverified code (study family 6a7335e9)"
  instances: 239
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6a7335e9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 239 addresses, $722 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xf78a209d40d7295c228f5e3f1e19cd9c9a55e724` (unverified, family `6a7335e9`, 239 addresses, $722): 239 clones with two selectors and one stored key. Decided by: bytecode and names (no source).
