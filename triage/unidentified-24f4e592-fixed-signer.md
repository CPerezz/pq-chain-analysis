---
id: unidentified-24f4e592-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-24f4e592
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4"
  name: "unverified code (study family c3b027e1), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4"
  name: "unverified code (study family c3b027e1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c3b027e1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4` (unverified, family `c3b027e1`, 2 addresses, $5k): a token claim contract behind a proxy (3 ETH with tokens): a signer with code ends claims. Not established beyond the decompiler: whether one of the unresolved functions sets the signer. Decided by: bytecode and names (no source).
