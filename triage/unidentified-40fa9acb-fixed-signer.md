---
id: unidentified-40fa9acb-fixed-signer
title: "FixedPricePool (91 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-40fa9acb
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb6f48899d84b95bc08168faf9e797926e4c76e68"
  name: "FixedPricePool (study family e96f4137), 1 of 91 addresses running it"
  upgradeable: "no"
families:
- code: "0xb6f48899d84b95bc08168faf9e797926e4c76e68"
  name: "FixedPricePool (study family e96f4137)"
  instances: 91
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e96f4137"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 91 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb6f48899d84b95bc08168faf9e797926e4c76e68` (FixedPricePool, family `e96f4137`, 91 addresses, $0): FixedPricePool: buys must carry a signature of delegateSigner(), a value fixed in each pool's code. Decided by: read.
