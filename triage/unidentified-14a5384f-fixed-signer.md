---
id: unidentified-14a5384f-fixed-signer
title: "2 contract families (6 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-14a5384f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd878d60e9a7f7fd102d5e7136892f724634d2fd7"
  name: "unverified code (study family 40e3a787), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xb59023a98583d61a6f61156ee0d025dae1ed295e"
  name: "unverified code (study family 54bd9858), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0xd878d60e9a7f7fd102d5e7136892f724634d2fd7"
  name: "unverified code (study family 40e3a787)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb59023a98583d61a6f61156ee0d025dae1ed295e"
  name: "unverified code (study family 54bd9858)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 40e3a787, 54bd9858"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd878d60e9a7f7fd102d5e7136892f724634d2fd7` (unverified, family `40e3a787`, 3 addresses, $0): checks against a verifier that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xb59023a98583d61a6f61156ee0d025dae1ed295e` (unverified, family `54bd9858`, 3 addresses, $0): a signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
