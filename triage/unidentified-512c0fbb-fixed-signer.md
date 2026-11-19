---
id: unidentified-512c0fbb-fixed-signer
title: "AGIMint (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-512c0fbb
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb27e219a28dcde18278355e41c5bdc8828eec459"
  name: "AGIMint (study family 0f8a2184), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xb27e219a28dcde18278355e41c5bdc8828eec459"
  name: "AGIMint (study family 0f8a2184)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0f8a2184"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb27e219a28dcde18278355e41c5bdc8828eec459` (AGIMint, family `0f8a2184`, 2 addresses, $0): AGIMint: the signer must be the address the caller passes, which is gateSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
