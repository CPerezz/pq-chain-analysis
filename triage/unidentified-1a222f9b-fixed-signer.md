---
id: unidentified-1a222f9b-fixed-signer
title: "11,284 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-1a222f9b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x61dbdccd5e1a5482b6a5900812c4ade5249663ec"
  name: "unverified code (study family 748e11a0), 1 of 11,284 addresses running it, 11,283 by 7702 delegation"
  upgradeable: "no"
families:
- code: "0x61dbdccd5e1a5482b6a5900812c4ade5249663ec"
  name: "unverified code (study family 748e11a0)"
  instances: 11284
  list: "every address running this code at block 26,438,999 (11,283 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 748e11a0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 11,284 addresses, $361 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x61dbdccd5e1a5482b6a5900812c4ade5249663ec` (unverified, family `748e11a0`, 11,284 addresses, $361): 7702 delegate used by 11,283 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Decided by: bytecode and names (no source).
