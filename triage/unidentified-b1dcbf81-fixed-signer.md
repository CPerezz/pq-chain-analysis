---
id: unidentified-b1dcbf81-fixed-signer
title: "24 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b1dcbf81
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4184449cd85cdfd4836fd282214174850d5fca9c"
  name: "unverified code (study family a45132c2), 1 of 24 addresses running it"
  upgradeable: "no"
families:
- code: "0x4184449cd85cdfd4836fd282214174850d5fca9c"
  name: "unverified code (study family a45132c2)"
  instances: 24
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 72002
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a45132c2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 24 addresses, $72k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4184449cd85cdfd4836fd282214174850d5fca9c` (unverified, family `a45132c2`, 24 addresses, $72k): BitGo pattern: a stored signer other than the caller; no function name that changes signers. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
