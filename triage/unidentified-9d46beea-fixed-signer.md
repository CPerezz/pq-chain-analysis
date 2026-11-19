---
id: unidentified-9d46beea-fixed-signer
title: "ERC20Bridge (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-9d46beea
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2a5a53582b2e70f3157120eb6ec556dd3fe50c8d"
  name: "ERC20Bridge (study family 4e86c9eb), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x2a5a53582b2e70f3157120eb6ec556dd3fe50c8d"
  name: "ERC20Bridge (study family 4e86c9eb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4e86c9eb"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x2a5a53582b2e70f3157120eb6ec556dd3fe50c8d` (ERC20Bridge, family `4e86c9eb`, 2 addresses, $0): ERC20Bridge: a withdrawal must be signed by `validator`, set in the constructor, with no setter. If that key's account takes code, nobody can withdraw. Decided by: read. Executed: a real transaction reverts when its signer has code.
